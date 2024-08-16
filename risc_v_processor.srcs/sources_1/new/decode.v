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
    input [31:0] instr,
    input en,

    output [4:0] rs1, 
    output [4:0] rs2, 
    output  [4:0] rd,
    output  [31:0] imm,
    output  [3:0] alu_ctrl,
    output  [1:0] alu_sel_A,
    output  [1:0] alu_sel_B,
    output  reg_write, 
    output  mem_read,
    output  mem_write,
    output  [1:0] mem_size,
    output  branch,
    output  jal,
    output  jalr,
    output  lui,
    output  aupc,
    output [6:0] debug
   //output multiop
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
    parameter RS2_to_A = 2'b00;
    parameter IMM_to_A = 2'b01;
    parameter four_to_A = 2'b10;
    parameter RS1_to_B = 2'b00;
    parameter PC_to_B = 2'b01;
    parameter twelve_to_B = 2'b10;
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
    reg [31:0] _imm;
    reg [3:0] _alu_ctrl;
    reg [1:0] _alu_sel_A;
    reg [1:0] _alu_sel_B;
    reg _reg_write; 
    reg _mem_read;
    reg _mem_write;
    reg [1:0] _mem_size;
    reg _branch;
    reg _jal;
    reg _jalr;
    reg _lui;
    reg _aupc;
    always @(posedge clk) begin
        _opcode = instr[6:0];
        _funct3 = instr[14:12];
        _funct7 = instr[31:25];
        if (en) begin
            case(_opcode)
                R_TYPE : begin
                    //R Type
                    _rs1 = instr[19:15];
                    _rs2 = instr[24:20];
                    _rd = instr[11:7];
                    _imm = 32'bx;
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
                    _alu_sel_A = RS2_to_A;
                    _alu_sel_B = RS1_to_B;
                    _reg_write = 1;
                    _mem_read = 0;
                    _mem_write = 0;
                    _mem_size = 2'bxx;
                    _branch = 0;
                    _jal = 0;
                    _jalr = 0;
                    _lui = 0;
                    _aupc = 0;
                end
                I_TYPE : begin
                    //I alu imm Type
                    _rs1 = instr[19:15];
                    _rs2 = 5'bxxxxx;
                    _rd = instr[11:7];
                    _imm = {20'b0, _funct7, instr[24:20]};
                    case(_funct3)
                        3'h0 : _alu_ctrl = ALU_ADD;
                        3'h4 : _alu_ctrl = ALU_XOR;
                        3'h6 : _alu_ctrl = ALU_OR;
                        3'h7 : _alu_ctrl = ALU_AND;
                        3'h1 : _alu_ctrl = ALU_SLL;
                        3'h5 : _alu_ctrl = (_funct7 == 0) ? ALU_SRL : ALU_SRA; 
                        3'h2 : _alu_ctrl = ALU_SLT; 
                        3'h3 : _alu_ctrl = ALU_SLTU;
                    endcase
                    _alu_sel_A = IMM_to_A;
                    _alu_sel_B = RS1_to_B;
                    _reg_write = 1;
                    _mem_read = 0;
                    _mem_write = 0;
                    _mem_size = 2'bxx;
                    _branch = 0;
                    _jal = 0;
                    _jalr = 0;
                    _lui = 0;
                    _aupc = 0;
                end
                LOAD : begin 
                    //I load Type
                    _rs1 = instr[19:15];
                    _rs2 = 5'bxxxxx;
                    _rd = instr[11:7];
                    _imm = {20'b0, _funct7, instr[24:20]};
                    _alu_ctrl = ALU_ADD;
                    _alu_sel_A = IMM_to_A;
                    _alu_sel_B = RS1_to_B;
                    _reg_write = 0;
                    _mem_read = 1;
                    _mem_write = 0;
                    case(_funct3)
                        3'h0 : _mem_size = 2'b01;
                        3'h1 : _mem_size = 2'b10;
                        3'h2 : _mem_size = 2'b11;
                        3'h4 : _mem_size = 2'b01; //havent implemented signed load
                        3'h5 : _mem_size = 4'b10; //havent implemented signed load
                    endcase
                    _branch = 0;
                    _jal = 0;
                    _jalr = 0;
                    _lui = 0;
                    _aupc = 0;
                end
                STORE : begin
                    //S Type
                    _rs1 = instr[19:15];
                    _rs2 = instr[24:20];
                    _rd = 5'bxxxxx;
                    _imm = {20'b0, instr[31:25], instr[11:7]};
                    
                    _alu_ctrl = ALU_ADD;
                    _alu_sel_A = IMM_to_A;
                    _alu_sel_B = RS1_to_B;
                    _reg_write = 0;
                    _mem_read = 0;
                    _mem_write = 1;
                    case(_funct3)
                        3'h0 : _mem_size = 2'b01;
                        3'h1 : _mem_size = 2'b10;
                        3'h2 : _mem_size = 2'b11;
                    endcase 
                    _branch = 0;
                    _jal = 0;
                    _jalr = 0;
                    _lui = 0;
                    _aupc = 0;
                    //_multiop = 0;
                end
                BRANCH : begin
                    //B Type
                    _rs1 = instr[19:15];
                    _rs2 = instr[24:20];
                    _rd = 5'bxxxxx;
                    _imm = {{20{instr[31]}}, instr[31:25], instr[11:7]};
                    case(_funct3)
                        3'h0 : _alu_ctrl = ALU_BEQ;
                        3'h1 : _alu_ctrl = ALU_BNE;
                        3'h4 : _alu_ctrl = ALU_BLT;
                        3'h5 : _alu_ctrl = ALU_BGET;
                        3'h6 : _alu_ctrl = ALU_BLT;
                        3'h7 : _alu_ctrl = ALU_BGET;
                    endcase
                    _alu_sel_A = RS2_to_A;
                    _alu_sel_B = RS1_to_B;
                    _reg_write = 0;
                    _mem_read = 0;
                    _mem_write = 0;
                    _mem_size = 2'bxx;
                    _branch = 1;
                    _jal = 0;
                    _jalr = 0;
                    _lui = 0;
                    _aupc = 0;
                    //_multiop = 1;
                end
                JAL : begin
                    //J Type jal
                    _rs1 = PC_ADDR;
                    _rs2 = 5'bxxxxx;
                    _rd = instr[11:7];
                    _imm = {12'b0, _funct7, instr[24:20], instr[19:15], _funct3};
                    _alu_ctrl = ALU_ADD;
                    _alu_sel_A = four_to_A;
                    _alu_sel_B = PC_to_B;
                    _reg_write = 1;
                    _mem_read = 0;
                    _mem_write = 0;
                    _mem_size = 2'bxx;
                    _branch = 0;
                    _jal = 1; //TEMP
                    _jalr = 0;
                    _lui = 0;
                    _aupc = 0;
                    //_multiop = 1;
                end
                JALR : begin
                    //I Type jalr
                    _rs1 = PC_ADDR;
                    _rs2 = 5'bxxxxx;
                    _rd = instr[11:7];
                    _imm = {20'b0, _funct7, instr[24:20]};
                    _alu_sel_A = four_to_A;
                    _alu_sel_B = PC_to_B;
                    _reg_write = 1;
                    _mem_read = 0;
                    _mem_write = 0;
                    _mem_size = 2'bxx;
                    _branch = 0;
                    _jal = 0;
                    _jalr = 1;
                    _lui = 0;
                    _aupc = 0;
                    //_multiop = 1;
                end
                LUI : begin
                    //U Type lui
                    _rs1 = 5'bxxxxx;
                    _rs2 = 5'bxxxxx;
                    _rd = instr[11:7];
                    _imm = {12'b0, _funct7, instr[24:20], instr[19:15], _funct3};
                    _alu_ctrl = ALU_SLL;
                    _alu_sel_A = IMM_to_A;
                    _alu_sel_B = twelve_to_B;
                    _reg_write = 1;
                    _mem_read = 0;
                    _mem_write = 0;
                    _mem_size = 2'bxx;
                    _branch = 0;
                    _jal = 0;
                    _jalr = 0;
                    _lui = 1;
                    _aupc = 0;
                    //_multiop = 0;
                end
                AUIPC : begin
                    //U Type aupc
                    _rs1 = 5'bxxxxx;
                    _rs2 = 5'bxxxxx;
                    _rd = instr[11:7];
                    _imm = {_funct7, instr[24:20], instr[19:15], _funct3, 12'b0};
                    _alu_ctrl = ALU_SLL;
                    _alu_sel_A = IMM_to_A;
                    _alu_sel_B = twelve_to_B;
                    _reg_write = 0;
                    _mem_read = 0;
                    _mem_write = 0;
                    _mem_size = 2'bxx;
                    _branch = 0;
                    _jal = 0;
                    _jalr = 0;
                    _lui = 0;
                    _aupc = 1;
                    //_multiop = 0;
                end
                ENV : begin
                    //I Type Environment Call
                end
                default : _mem_size = 2'b00;
                endcase
                end 
        if (!en) begin
//                    _rs1 = 1'bx;
//                    _rs2 = 1'bx;
//                    _rd = 1'bx;
//                    _imm = 1'bx;
//                    _alu_ctrl = 1'bx;
//                    _alu_sel_A = 1'bx;
//                    _reg_write = 1'bx;
//                    _mem_read = 1'bx;
//                    _mem_write = 1'bx;
//                    _mem_size = 1'bx;
//                    _branch = 1'bx;
//                    _jal = 1'bx;
//                    _jalr = 1'bx;
//                    _lui = 1'bx;
//                    _aupc = 1'bx;
                end
    end
    assign rs1 = _rs1;
    assign rs2 = _rs2;
    assign rd = _rd;
    assign imm = _imm;
    assign alu_ctrl = _alu_ctrl;
    assign alu_sel_A = _alu_sel_A;
    assign alu_sel_B = _alu_sel_B;
    assign reg_write = _reg_write;
    assign mem_read = _mem_read;
    assign mem_write = _mem_write;
    assign mem_size = _mem_size;
    assign branch = _branch;
    assign jal = _jal;
    assign jalr = _jalr;
    assign lui = _lui;
    assign aupc = _aupc;
    assign debug = _opcode;
endmodule
