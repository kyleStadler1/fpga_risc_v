`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/30/2024 10:28:22 PM
// Design Name: 
// Module Name: exec_combinatorial_top
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


module exec_combinatorial_top( //fully combanatorial unit so no clock needed
    input [4:0] rs1,
    input [4:0] rs2, 
    input [4:0] rd,
    input [19:0] imm,
    input [31:0] pc,
    input [1:0] selA,
    input [1:0] selB,
    input [3:0] alu_ctrl,
    input regWrite_simple,
    input jal,
    input jalr,
    input auipc,
    input [31:0] prev_alu_val,
    //direct register read access access for alu mux
    output [4:0] readAddrA,
    output [4:0] readAddrB,
    input [31:0] doutA,
    input [31:0] doutB,
    //direct register write access to port A
    output writeEnA,
    output [4:0] writeAddrA,
    output [31:0] dinA,
    //
    input mopFlag,
    //
    output mop_en,
    output modPc_en,
    output [3:0] aluCtrl_mop,
    output [1:0] selA_mop,
    output [1:0] selB_mop,
    output [31:0] curr_alu,
    output [31:0] _a,
    output [31:0] _b,
    output _branch
    );
    wire [31:0] A;
    wire [31:0] B;
    assign _a = A;
    assign _b = B;
   
    wire [31:0] curr_alu_val;
    wire branch;
    assign _branch = branch;
    alu_control_unit acu(
        .rs2(rs2),
        .imm(imm),
        .rs1(rs1),
        .dra_addrA(readAddrA),
        .dra_addrB(readAddrB),
        .dra_doutA(doutA),
        .dra_doutB(doutB),
        .pc_val(pc),
        .alu_val(prev_alu_val),
        .selA(selA),
        .selB(selB),
        .out_A(A),
        .out_B(B)
    );
    alu alu(
        .alu_ctrl(alu_ctrl),
        .A(A),
        .B(B),
        .alu_out(curr_alu_val),
        .branch(branch)
    );
    multiop_controller mop(
        .reg_write(regWrite_simple),
        .alu_branch(branch),
        .jal(jal),
        .jalr(jalr),
        .auipc(auipc),
        .mop_in(mopFlag),
        .aluCtrl_mop(aluCtrl_mop),
        .selA_mop(selA_mop),
        .selB_mop(selB_mop),
        .reg_write_out(writeEnA),
        .mod_pc(modPc_en),
        .mop_out(mop_en)
    );
    assign writeAddrA = rd;
    assign dinA = curr_alu_val;
    assign curr_alu = curr_alu_val;
endmodule
