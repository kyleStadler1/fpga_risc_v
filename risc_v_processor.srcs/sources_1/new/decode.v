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
    output wire [4:0] rs1, //rs1, rs2 are combinatorial throughout since it goes out to reg file and regFile[rs1 and rs2] values 
    output wire [4:0] rs2, //@ clock edge will be ready, same time as below signals are latched out.
    output reg [4:0] rd,
    output reg [19:0] imm,
    output reg [3:0] alu_ctrl,
    output reg alu_src,
    output reg reg_write, 
    output reg mem_read,
    output reg mem_write,
    output reg [3:0] mem_mask,
    output reg branch,
    output reg jump,
    output reg jump_reg,
    output reg lui,
    output reg aupc
    );
    //alu ctrl 
    parameter ALU_AND  = 4'b0000;  
    parameter ALU_OR   = 4'b0001;  
    parameter ALU_XOR  = 4'b0010;  
    parameter ALU_ADD  = 4'b0011;  
    parameter ALU_SUB  = 4'b0100;  
    parameter ALU_SLT  = 4'b0101;  
    parameter ALU_SLTU = 4'b0110;  
    parameter ALU_SLL  = 4'b0111;  
    parameter ALU_SRL  = 4'b1000;  
    parameter ALU_SRA  = 4'b1001;  
    parameter ALU_NOR  = 4'b1010;  
    parameter ALU_LUI  = 4'b1011;  
    parameter ALU_BEQ  = 4'b1100;  
    parameter ALU_BNE  = 4'b1101;  
    parameter ALU_BLT = 4'b1110;  
    parameter ALU_BGET = 4'b1111;  
    //alu input src
    parameter SRC_REG = 0;
    parameter SRC_IMM = 1;
    //input instr Type
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
    //prog ctr addr
    parameter PC_ADDR = 32'bx;
    //temp vars for combinatorial logic
    reg [6:0] _opcode;
    reg [2:0] _funct3;
    reg [6:0] _funct7;
    reg [4:0] _rs1;
    reg [4:0] _rs2;
    reg [4:0] _rd;
    reg [19:0] _imm;
    reg [3:0] _alu_ctrl;
    reg _alu_src;
    reg _reg_write; 
    reg _mem_read;
    reg _mem_write;
    reg [3:0] _mem_mask;
    reg _branch;
    reg _jump;
    reg _jump_reg;
    reg _lui;
    reg _aupc;
    always @(posedge clk) begin
        _opcode = instr[6:0];
        _rd = instr[11:7];
        _funct3 = instr[14:12];
        _rs1 = instr[19:15];
        _rs2 = instr[24:20];
        _funct7 = instr[31:25];
        case(_opcode)
            R_TYPE : begin
                            //R Type
                            _imm = 20'bx;
                            _alu_src = SRC_REG;
                            _reg_write = 1;
                            _mem_read = 0;
                            _mem_write = 0;
                            _mem_mask = 4'b0000;
                            _branch = 0;
                            _jump = 0;
                            _jump_reg = 0;
                            _lui = 1;
                            _aupc = 0;
                            case(_funct3)
                                3'h0 : _alu_ctrl = (_funct7 == 0) ? ALU_ADD : ALU_SUB;
                                3'h4 : _alu_ctrl = ALU_XOR;
                                3'h6 : _alu_ctrl = ALU_OR;
                                3'h7 : _alu_ctrl = ALU_AND;
                                3'h1 : _alu_ctrl = ALU_SLL;
                                3'h5 : _alu_ctrl = (_funct7 == 0) ? ALU_SRL : ALU_SRA;
                                3'h2 : _alu_ctrl = ALU_SLT;
                                3'h3 : _alu_ctrl = ALU_SLTU;
                                endcase
                            end
            I_TYPE : begin
                            //I alu imm Type
                            _imm = {{8{0}}, _funct7, _rs2};
                            _alu_src = SRC_IMM;
                            _reg_write = 1;
                            _mem_read = 0;
                            _mem_write = 0;
                            _mem_mask = 4'b0000;
                            _branch = 0;
                            _jump = 0;
                            _jump_reg = 0;
                            _lui = 1;
                            _aupc = 0;
                            case(_funct3)
                                3'h0 : _alu_ctrl = ALU_ADD;
                                3'h4 : _alu_ctrl = ALU_XOR;
                                3'h6 : _alu_ctrl = ALU_OR;
                                3'h7 : _alu_ctrl = ALU_AND;
                                3'h1 : _alu_ctrl = ALU_SLL;
                                3'h5 : _alu_ctrl = (_funct7 == 0) ? ALU_SRL : ALU_SRA; 
                                3'h2 : alu_ctrl = ALU_SLT; 
                                3'h3 : alu_ctrl = ALU_SLTU;
                                endcase
                            end
            LOAD : begin 
                            //I load Type
                            _imm = {{8{0}}, _funct7, _rs2};
                            _alu_ctrl = ALU_ADD;
                            _alu_src = SRC_IMM;
                            _reg_write = 1;
                            _mem_read = 1;
                            _mem_write = 0;
                            _branch = 0;
                            _jump = 0;
                            _jump_reg = 0;
                            _lui = 1;
                            _aupc = 0;
                            case(_funct3)
                                3'h0 : _mem_mask = 4'b0001;
                                3'h1 : _mem_mask = 4'b0011;
                                3'h2 : _mem_mask = 4'b1111;
                                3'h4 : _mem_mask = 4'b0001; //havent implemented signed load
                                3'h5 : _mem_mask = 4'b0011; //havent implemented signed load
                                endcase
                            end
            STORE : begin
                            //S Type
                            _rd = 5'bx;
                            _imm = {{13{0}}, _funct7};
                            _alu_ctrl = ALU_ADD;
                            _alu_src = SRC_IMM;
                            _reg_write = 0;
                            _mem_read = 0;
                            _mem_write = 1;
                            _branch = 0;
                            _jump = 0;
                            _jump_reg = 0;
                            _lui = 1;
                            _aupc = 0;
                            case(_funct3)
                                3'h0 : _mem_mask = 4'b0001;
                                3'h1 : _mem_mask = 4'b0011;
                                3'h2 : _mem_mask = 4'b1111;
                                endcase 
                            end
            BRANCH : begin
                            //B Type
                            _rd = 5'bx;
                            _imm = {{13{0}}, _funct7};
                            _alu_src = SRC_REG;
                            _reg_write = 0;
                            _mem_read = 0;
                            _mem_write = 0;
                            _mem_mask = 4'b0000;
                            _branch = 1;
                            _jump = 0;
                            _jump_reg = 0;
                            _lui = 1;
                            _aupc = 0;
                            case(_funct3)
                                3'h0 : _alu_ctrl = ALU_BEQ;
                                3'h1 : _alu_ctrl = ALU_BNE;
                                3'h4 : _alu_ctrl = ALU_BLT;
                                3'h5 : _alu_ctrl = ALU_BGET;
                                3'h6 : _alu_ctrl = ALU_BLT;
                                3'h7 : _alu_ctrl = ALU_BGET;
                                endcase
                            end
            JAL : begin
                            //J Type jal
                            _imm = {_funct7, _rs2, _rs1, _funct3};
                            _alu_ctrl = ALU_ADD;
                            _alu_src = SEL_IMM;
                            _rs1 = PC_ADDR;
                            _reg_write = 1;
                            _mem_read = 0;
                            _mem_write = 0;
                            _mem_mask = 4'b0000;
                            _branch = 0;
                            _jump = 1;
                            _jump_reg = 0;
                            _lui = 1;
                            _aupc = 0;
                            end
            JALR : begin
                            //I Type jalr
                            _imm = {{8{0}}, _funct7, _rs2};
                            _alu_ctrl = ALU_ADD;
                            _alu_src = SRC_IMM;
                            _reg_write = 1;
                            _mem_read = 0;
                            _mem_write = 0;
                            _mem_mask = 4'b0000;
                            _branch = 0;
                            _jump = 0;
                            _jump_reg = 1;
                            _lui = 0;
                            _aupc = 0;
                            end
            LUI : begin
                            //U Type lui
                            _imm = {_funct7, _rs2, _rs1, _funct3};
                            _alu_ctrl = ALU_SLL;
                            _alu_src = 1'bx;
                            _reg_write = 1;
                            _mem_read = 0;
                            _mem_write = 0;
                            _mem_mask = 4'b0000;
                            _branch = 0;
                            _jump = 0;
                            _jump_reg = 0;
                            _lui = 1;
                            _aupc = 0;
                            end
            AUIPC : begin
                            //U Type aupc
                            _imm = {_funct7, _rs2, _rs1, _funct3};
                            _alu_ctrl = ALU_SLL;
                            _alu_src = 1'bx;
                            _reg_write = 1;
                            _mem_read = 0;
                            _mem_write = 0;
                            _mem_mask = 4'b0000;
                            _branch = 0;
                            _jump = 0;
                            _jump_reg = 0;
                            _lui = 0;
                            _aupc = 1;
                            end
            ENV : begin
                            //I Type Environment Call
                            end
            endcase
        assign rs1 = _rs1;
        assign rs2 = _rs2;
        rd <= _rd;
        imm <= _imm;
        alu_ctrl <= _alu_ctrl;
        alu_src <= _alu_src;
        reg_write <= _reg_write;
        mem_read <= _mem_read;
        mem_write <= _mem_write;
        mem_mask <= _mem_mask;
        branch <= _branch;
        jump <= _jump;
        jump_reg <= _jump_reg;
        lui <= _lui;
        aupc <= _aupc;
    end
endmodule
