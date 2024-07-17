`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/17/2024 01:20:33 AM
// Design Name: 
// Module Name: decode_to_execute_reg_wall
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


module decode_to_execute_reg_wall(
    input clk,
    input en,
    input [31:0] rs1_val_in,
    input [31:0] rs2_val_in,
    input [4:0] rd_in,
    input [19:0] imm_in,
    input [3:0] alu_ctrl_in,
    input alu_src_in,
    input reg_write_in,
    input mem_read_in,
    input mem_write_in,
    input [1:0] mem_size_in,
    input branch_in,
    input jump_in,
    input jump_reg_in,
    input lui_in,
    input aupc_in,
    input [31:0] pc_val_in,
    output reg [31:0] rs1_val,
    output reg [31:0] rs2_val,
    output reg [4:0] rd,
    output reg [19:0] imm,
    output reg [3:0] alu_ctrl,
    output reg alu_src,
    output reg reg_write,
    output reg mem_read,
    output reg mem_write,
    output reg [1:0] mem_size,
    output reg branch,
    output reg jump,
    output reg jump_reg,
    output reg lui,
    output reg aupc,
    output reg [31:0] pc_val
    );
    always @(posedge clk) begin
        if (en) begin
            rs1_val <= rs1_val_in;
            rs2_val <= rs2_val_in;
            rd <= rd_in;
            imm <= imm_in;
            alu_ctrl <= alu_ctrl_in;
            alu_src <= alu_src_in;
            reg_write <= reg_write_in;
            mem_read <= mem_read_in;
            mem_write <= mem_write_in;
            mem_size <= mem_size_in;
            branch <= branch_in;
            jump <= jump_in;
            jump_reg <= jump_reg_in;
            lui <= lui_in;
            aupc <= aupc_in;
            pc_val <= pc_val_in;
        end    
    end

endmodule
