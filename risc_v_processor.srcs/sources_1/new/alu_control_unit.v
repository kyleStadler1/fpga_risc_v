`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/17/2024 10:03:06 PM
// Design Name: 
// Module Name: alu_control_unit
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
    // parameter [1:0] BRANCH = 2'b00;
    // parameter [1:0] JAL = 2'b01;
    // parameter [1:0] JALR = 2'b10;
    // parameter [1:0] AUIPC = 2'b11;

module alu_control_unit(
    input [31:0] rs2_val,
    input [19:0] imm,
    input [31:0] rs1_val,
    input [31:0] pc_val,
    input [31:0] alu_val,
    input [1:0] selA,
    input [1:0] selB,
    output [31:0] out_A,
    output [31:0] out_B
    );
    parameter RS2_to_A = 2'b00;
    parameter IMM_to_A = 2'b01;
    parameter 4_to_A = 2'b10;
    parameter ALU_to_A = 2'b11;
    parameter RS1_to_B = 2'b00;
    parameter PC_to_B = 2'b01;
    parameter 12_to_B = 2'b10;
    parameter ALU_to_B = 2'b11;
    case(selA)
        RS2_to_A : out_A = rs2_val;
        IMM_to_A : out_A = {12'b0, imm};
        4_to_A : out_A = 32'd4;
        ALU_to_A : out_A = alu_val;
    endcase
    case(selB)
        RS1_to_B : out_B = rs1_val;
        PC_to_B : out_B = pc_val;
        12_to_B : out_B = 32'd12;
        ALU_to_B : out_B = alu_val;
    endcase
endmodule