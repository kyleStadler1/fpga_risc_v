`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/23/2024 04:33:29 PM
// Design Name: 
// Module Name: tb_aluCtrlAlu
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


module tb_aluCtrlAlu;
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

    reg [31:0] rs2_val;
    reg [19:0] imm;
    reg [31:0] rs1_val;
    reg [31:0] pc_val;
    reg [31:0] alu_val;
    reg [1:0] selA;
    reg [1:0] selB;
    
    reg [3:0] alu_ctrl;

    // Wires for outputs
    wire [31:0] out_A;
    wire [31:0] out_B;
    wire [31:0] alu_out;
    wire branch;


alu_control_unit alu_control_unit_instance (
    .rs2_val(rs2_val),
    .imm(imm),
    .rs1_val(rs1_val),
    .pc_val(pc_val),
    .alu_val(alu_val),
    .selA(selA),
    .selB(selB),
    .out_A(out_A),
    .out_B(out_B)
);

alu alu_instance (
    .alu_ctrl(alu_ctrl),
    .A(out_A),
    .B(out_B),
    .alu_out(alu_out),
    .branch(branch)
);

initial begin
    rs2_val = 32'd1;
    imm = 19'd2;
    rs1_val = 32'd3;
    pc_val = 32'd4;
    alu_val = 32'dx;
    selA = RS2_to_A;
    selB = RS1_to_B;
    alu_ctrl = ALU_ADD;
    #10;
    selA = IMM_to_A;
    selB = PC_to_B;
    #10;
    selA = four_to_A;
    selB = twelve_to_B;
    #10;
    $finish;
end

endmodule
