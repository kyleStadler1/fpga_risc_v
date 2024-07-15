`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/09/2024 10:28:27 PM
// Design Name: 
// Module Name: decode
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module decode(
    input clk, 
    input en, 
    input [31:0] instr,
    input [31:0] reg_file [0:31], //might need to change this to a packed array
    //output wire [6:0] opcode,
    //output wire [2:0] funct3,
    //output wire [6:0] funct7,
    output wire [4:0] rs1,
    output wire [4:0] rs2,
    output wire [4:0] rd,
    output wire [31:0] imm,
    output reg [31:0] alu_inA,
    output reg [31:0] alu_inB,
    output reg [3:0] alu_ctrl, //make a var and make this a wire maybe
    output reg reg_write, //
    output reg rw_sel, //read = 0, write = 1
    output reg [1:0] rw_width, //0 = rw disable
    output reg is_signed,
    output reg branch,
    output reg jump_link
    );
    
    parameter ALU_AND  = 4'b0000;  // Bitwise AND
    parameter ALU_OR   = 4'b0001;  // Bitwise OR
    parameter ALU_XOR  = 4'b0010;  // Bitwise XOR
    parameter ALU_ADD  = 4'b0011;  // Addition
    parameter ALU_SUB  = 4'b0100;  // Subtraction
    parameter ALU_SLT  = 4'b0101;  // Set on Less Than (signed comparison)
    parameter ALU_SLTU = 4'b0110;  // Set on Less Than Unsigned (unsigned comparison)
    parameter ALU_SLL  = 4'b0111;  // Shift Left Logical
    parameter ALU_SRL  = 4'b1000;  // Shift Right Logical
    parameter ALU_SRA  = 4'b1001;  // Shift Right Arithmetic
    parameter ALU_NOR  = 4'b1010;  // Bitwise NOR (often used for comparison)
    parameter ALU_LUI  = 4'b1011;  // Load Upper Immediate (usually a special case)
    parameter ALU_BEQ  = 4'b1100;  // Branch if Equal (used for branch comparisons)
    parameter ALU_BNE  = 4'b1101;  // Branch if Not Equal (used for branch comparisons)
    parameter ALU_BLT = 4'b1110;  // Branch if LESS Than
    parameter ALU_BGET = 4'b1111;  // Branch if GREATER Than EQUAL to
    
    parameter R_TYPE = 7'b0110011;
    parameter I_TYPE = 7'b0010011;
    parameter STORE = 7'b0100011;
    parameter LOAD = 7'b0000011;
    parameter BRANCH = 7'b1100011;
    parameter JALR = 7'b1100111;
    parameter JAL = 7'b1101111;
    parameter AUIPC = 7'b0010111;
    parameter LUI = 7'b0110111;
    parameter ENV = 7'b1110011;
    
    parameter RW_DISABLE = 2'b00;
    parameter RW_BYTE = 2'b1;
    parameter RW_HALF = 2'b10;
    parameter RW_WORD = 2'b11;
    parameter READ = 0;
    parameter WRITE = 1;

    reg [6:0] _opcode;
    reg [4:0] _rd;
    reg [2:0] _funct3;
    reg [4:0] _rs1;
    reg [4:0] _rs2;
    reg [6:0] _funct7;
    reg [11:0] _imm_I;
    reg [6:0] _imm_SB;
    reg [19:0] _imm_UJ;
    reg [31:0] _alu_inA;
    reg [31:0] _alu_inB;
    always @(posedge clk) begin
        _opcode = instr[6:0];
        _rd = instr[11:7];
        _funct3 = instr[14:12];
        _rs1 = instr[19:15];
        _rs2 = instr[24:20];
        _funct7 = instr[31:25];
        _imm_I = {_funct7, _rs2};
        _imm_SB = _funct7;
        _imm_UJ = {_imm_I, _rs1, _funct3};
        case(_opcode)
            R_TYPE : begin
                            //R Type
                            reg_write <= 1;
                            rw_width <= RW_DISABLE;
                            branch <= 0;
                            jump_link <= 0;
                            _alu_inA = reg_file[_rs1];
                            _alu_inB = reg_file[_rs2];
                            case(_funct3)
                                3'h0 : alu_ctrl <= (_funct7 == 0) ? ALU_ADD : ALU_SUB;
                                3'h4 : alu_ctrl <= ALU_XOR;
                                3'h6 : alu_ctrl <= ALU_OR;
                                3'h7 : alu_ctrl <= ALU_AND;
                                3'h1 : alu_ctrl <= ALU_SLL;
                                3'h5 : alu_ctrl <= (_funct7 == 0) ? ALU_SRL : ALU_SRA;
                                3'h2 : alu_ctrl <= ALU_SLT;
                                3'h3 : alu_ctrl <= ALU_SLTU;
                                endcase
                            end
            I_TYPE : begin
                            //I alu imm Type
                            reg_write <= 1;
                            rw_width <= RW_DISABLE;
                            branch <= 0;
                            jump_link <= 0;
                            _alu_inA = reg_file[_rs1];
                            _alu_inB = {{20{_imm_I[11]}},_imm_I};
                            case(_funct3)
                                3'h0 : alu_ctrl <= ALU_ADD;
                                3'h4 : alu_ctrl <= ALU_XOR;
                                3'h6 : alu_ctrl <= ALU_OR;
                                3'h7 : alu_ctrl <= ALU_AND;
                                3'h1 : begin 
                                            alu_ctrl <= ALU_SLL;
                                            _alu_inB = _alu_inB & 5'b11111;
                                            end
                                3'h5 : begin 
                                            alu_ctrl <= (_funct7 == 0) ? ALU_SRL : ALU_SRA; 
                                            _alu_inB = _alu_inB & 5'b11111;
                                            end
                                3'h2 : alu_ctrl <= ALU_SLT; 
                                3'h3 : alu_ctrl <= ALU_SLTU;
                                endcase
                            end
            LOAD : begin 
                            //I load Type
                            reg_write <= 1; //
                            rw_sel <= READ;
                            _alu_inA = reg_file[_rs1];
                            _alu_inB = _imm_I;
                            alu_ctrl <= ALU_ADD; //need to mux the alu out to either touch mem then go to rd or just go to rd
                            case(_funct3)
                                3'h0 : begin rw_width <= RW_BYTE;   is_signed <= 1; end
                                3'h1 : begin rw_width <= RW_HALF;   is_signed <= 1; end
                                3'h2 : begin rw_width <= RW_WORD;   is_signed <= 1; end
                                3'h4 : begin rw_width <= RW_BYTE;   is_signed <= 0; end
                                3'h5 : begin rw_width <= RW_HALF;   is_signed <= 0; end
                                endcase
                            end
            STORE : begin
                            //S Type
                            reg_write <= 0;
                            rw_sel <= WRITE;
                            _alu_inA = reg_file[_rs1];
                            _alu_inB = _imm_I;
                            alu_ctrl <= ALU_ADD; //need to mux the alu to touch mem and store contents of rs2 at calculated location
                            case(_funct3)
                                3'h0 : begin rw_width <= RW_BYTE;   is_signed <= 1; end
                                3'h1 : begin rw_width <= RW_HALF;   is_signed <= 1; end
                                3'h2 : begin rw_width <= RW_WORD;   is_signed <= 1; end
                                endcase 
                            end
            BRANCH : begin
                            //B Type
                            branch <= 1;
                            reg_write <= 0;
                            rw_width = RW_DISABLE;
                            _alu_inA = reg_file[_rs1];
                            _alu_inB = reg_file[_rs2];
                            case(_funct3)
                                3'h0 : begin alu_ctrl <= ALU_BEQ;   is_signed <= 1; end 
                                3'h1 : begin alu_ctrl <= ALU_BNE;   is_signed <= 1; end 
                                3'h4 : begin alu_ctrl <= ALU_BLT;   is_signed <= 1; end 
                                3'h5 : begin alu_ctrl <= ALU_BGET;  is_signed <= 1; end 
                                3'h6 : begin alu_ctrl <= ALU_BLT;   is_signed <= 0; end 
                                3'h7 : begin alu_ctrl <= ALU_BGET;  is_signed <= 0; end
                                endcase
                            end
            JAL : begin
                            //J Type jal
                            jump_link <= 1; //set others later
                            reg_write <= 1;
                            _rd = instr + 3'b100;
                            _alu_inA = instr;
                            _alu_inB = _imm_UJ;
                            alu_ctrl <= ALU_ADD;
                            end
            JALR : begin
                            //I Type jalr
                            jump_link <= 1;
                            reg_write <= 1;
                            _rd = instr + 3'b100;
                            _alu_inA = reg_file[rs1];
                            _alu_inB = _imm_I;
                            end
            LUI : begin
                            //U Type lui
                            end
            AUIPC : begin
                            //U Type auipc
                            end
            ENV : begin
                            //I Type Environment Call
                            end
            endcase
                                                     
    end
endmodule
