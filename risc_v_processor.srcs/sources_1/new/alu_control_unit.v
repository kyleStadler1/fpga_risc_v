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
    input [31:0] rs2Val,
    input [31:0] imm,
    input [31:0] rs1Val,
    input [31:0] pcVal,
    input [1:0] selA,
    input [1:0] selB,
    output [31:0] outA,
    output [31:0] outB
    );
    parameter RS2_to_A = 2'b00;
    parameter IMM_to_A = 2'b01;
    parameter four_to_A = 2'b10;
    parameter RS1_to_B = 2'b00;
    parameter PC_to_B = 2'b01;
    parameter twelve_to_B = 2'b10;
    reg [31:0] _A;
    reg [31:0] _B;
    always @(*) begin
        case(selA)
            RS2_to_A : _A = rs2Val;
            IMM_to_A : _A = imm;
            four_to_A : _A = 32'd4;
            default : _A = 32'hffffffff;
        endcase
        case(selB)
            RS1_to_B : _B = rs1Val;
            PC_to_B : _B = pcVal;
            twelve_to_B : _B = 32'd12;
            default : _B = 32'hffffffff;
        endcase
        end
        assign outA = _A;
        assign outB = _B;
endmodule