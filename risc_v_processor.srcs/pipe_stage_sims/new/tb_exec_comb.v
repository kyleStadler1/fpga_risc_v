`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/30/2024 10:59:12 PM
// Design Name: 
// Module Name: tb_exec_comb
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




module tb_exec_comb;

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

    reg clk = 0;
    reg [31:0] ctr = 0;
    wire [4:0] dra_addrA, dra_addrB;
    wire write_enA;
    wire [4:0] writeAddrA;
    wire [31:0] dinA;


    reg [4:0] rs1, rs2, rd;
    reg [19:0] imm;
    reg [1:0] selA, selB;
    reg [3:0] alu_ctrl;
    reg regWrite_simple;
    reg jal, jalr, auipc;
    reg mopFlag;
    wire mop_en, modPc_en;
    wire [3:0] aluCtrl_mop;
    wire [1:0] selA_mop, selB_mop;
    wire [31:0] _a, _b;
    wire _branch;    
    exec_combinatorial_top ect (
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .imm(imm),
        .pc(ctr << 2),
        .selA(selA),
        .selB(selB),
        .alu_ctrl(alu_ctrl),
        .regWrite_simple(regWrite_simple),
        .jal(jal),
        .jalr(jalr),
        .auipc(auipc),
        .mopFlag(mopFlag),
        .readAddrA(dra_addrA),
        .readAddrB(dra_addrB),
        .doutA(32'd5),
        .doutB(32'd5),
        .writeEnA(write_enA),
        .writeAddrA(writeAddrA),
        .dinA(dinA),
        .mop_en(mop_en),
        .modPc_en(modPc_en),
        .aluCtrl_mop(aluCtrl_mop),
        .selA_mop(selA_mop),
        .selB_mop(selB_mop),
        ._a(_a),
        ._b(_b),
        ._branch(_branch)
        
    );
    
    always @(posedge clk) begin
    ctr <= ctr + 1;
        case(ctr)
        0 : begin
                rs1 = 5'd1;
                rs2 = 5'd2;
                rd = 5'dz;
                imm = 32'd20;
                alu_ctrl = ALU_BEQ;
                selA = RS2_to_A;
                selB = RS1_to_B;
                regWrite_simple = 0;
                jal = 0;
                jalr = 0;
                auipc = 0;
                mopFlag = 0;
            end
        2 : begin 
                rs1 = 5'd1;
                rs2 = 5'd2;
                rd = 5'd3;
                imm = 32'd20;
                alu_ctrl = ALU_ADD;
                selA = RS2_to_A;
                selB = RS1_to_B;
                regWrite_simple = 1;
                jal = 0;
                jalr = 0;
                auipc = 0;
                //mopFlag = 0;
            end
        3 : begin
                rs1 = 5'd1;
                rs2 = 5'd2;
                rd = 5'dz;
                imm = 32'd20;
                alu_ctrl = ALU_BEQ;
                selA = RS2_to_A;
                selB = RS1_to_B;
                regWrite_simple = 0;
                jal = 0;
                jalr = 0;
                auipc = 0;
                mopFlag = 0;
            end
            endcase
    end
    


     always begin
         #20 clk <= clk + 1;
     end

endmodule
