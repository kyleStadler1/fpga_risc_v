`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/01/2024 11:26:51 PM
// Design Name: 
// Module Name: dualExec_top
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


module dualExec_top(
    input clk,
    //direct reg read access
    output [4:0] readAddrA,
    output [4:0] readAddrB,
    input [31:0] doutA,
    input [31:0] doutB,
    //dire reg write access
    output wenA,
    output [4:0] writeAddrA,
    output [31:0] dinA,
    //normal IO
    input [4:0] rs1, 
    input [4:0] rs2, 
    input [4:0] rd,
    input [31:0] imm,
    input [3:0] aluCtrl,
    input [1:0] selA,
    input [1:0] selB,
    input regWrite,
    input jal,
    input jalr,
    input [31:0] pc,
    output reg [4:0] rdOut,
    output reg [31:0] aluVal,
    output reg rs2ValOut,
    output reg modPc,
    output reg [31:0] pcVect
    );
    wire [31:0] rs1Val, rs2Val;
    assign readAddrA = rs1;
    assign readAddrB = rs2;
    assign rs1Val = doutA;
    assign rs2Val = doutB;
    assign wenA = regWrite;
    assign writeAddrA = rd;
    assign dinA = aluVal;
    
    wire [31:0] A, B;
     alu_control_unit acu(
        .rs2Val(rs2),
        .imm(imm),
        .rs1Val(rs1),
        .pcVal(pc),
        .selA(selA),
        .selB(selB),
        .outA(A),
        .outB(B)
    );
    wire branchValid;
    wire [31:0] _aluVal;
    alu alu(
        .alu_ctrl(aluCtrl),
        .A(A),
        .B(B),
        .alu_out(_aluVal),
        .branchValid(branchValid)
    );
    wire [31:0] pc_imm, rs1_imm, _pcVect; //mini alu for just these 2 ops
    assign pc_imm = pc + imm;
    assign rs1_imm = rs1Val + imm;
    assign _pcVect = (branchValid | jal) ? pc_imm : rs1_imm;
    
    always @(posedge clk) begin
        rdOut <= rd;
        aluVal <= _aluVal;
        rs2ValOut <= rs2Val;
        modPc <= branchValid | jal | jalr;
        pcVect <= _pcVect;
    end
endmodule
