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
    input [31:0] rs1_val_dec,
    input [31:0] rs2_val_dec,
    input [4:0] rd_dec,
    input [19:0] imm_dec,
    input [3:0] alu_ctrl_dec,
    input [1:0] alu_selA_dec,
    input [1:0] alu_selB_dec,
    input reg_write_dec,
    input mem_read_dec,
    input mem_write_dec,
    input [1:0] mem_size_dec,
    input pot_branch_dec,
    input jump_dec,
    input jump_reg_dec,
    input lui_dec,
    input aupc_dec,
    input [31:0] pc_val_in,

    input [3:0] alu_ctrl_in_mop,
    input [1:0] alu_selA_mop,
    input [1:0] alu_selB_mop,
    input reg_write_in_mop,
    input mod_pc_mop,
    input multiop_mop,
    input [31:0] alu_out_in,
    

    output reg [31:0] rs1_val,
    output reg [31:0] rs2_val, 
    output reg [4:0] rd, //
    output reg [19:0] imm, //r
    output reg [3:0] alu_ctrl,
    output reg [1:0] alu_selA,
    output reg [1:0] alu_selB,
    output reg reg_write,
    output reg mem_read, //
    output reg mem_write, //
    output reg [1:0] mem_size, //
    output reg branch_pot,
    //output reg mod_pc,
    output reg jump,
    output reg jump_reg,
    output reg lui, 
    output reg aupc,
    output reg [31:0] pc_val
    output reg multiop,
    output reg [31:0] alu_out,
    ); 
    reg [1:0] ctr;

    always @(posedge clk) begin
        if (en) begin
            if (mod_pc_mop) begin
                ctr = 2'd3;
            end
            if (ctr > 0) begin //this is to basically wait if a branch occoured to throw away the stuff in the pipe thats worthless
                ctr = ctr - 1;
                rs1_val <= 1'bx;
                rs2_val <= 1'bx;
                rd <= 1'bx;
                imm <= 1'bx;
                alu_ctrl <= 1'bx;
                alu_selA <= 1'bx;
                alu_selB <= 1'bx;
                reg_write <= 1'bx;
                mem_read <= 0;
                mem_write <= 0;
                mem_size <= 1'bx;
                branch_pot <= 0;
                //mod_pc <= 1'b0;
                jump <= 0;
                jump_reg <= 0;
                lui <= 0;
                aupc <= 0;
                pc_val <= 1'bx;
                multiop <= 1'b0;
                alu_out <= 32'bx;
            end else begin
                if (!multiop_mop)
                rs1_val <= rs1_val_dec;
                rs2_val <= rs2_val_dec;
                rd <= rd_dec;
                imm <= imm_dec;
                alu_ctrl <= alu_ctrl_dec;
                alu_selA <= alu_selA_dec;
                alu_selB <= alu_selB_dec;
                reg_write <= reg_write_dec;
                mem_read <= mem_read_dec;
                mem_write <= mem_write_dec;
                mem_size <= mem_size_dec;
                branch_pot <= pot_branch_dec;
                //mod_pc <= 1'b0;
                jump <= jump_dec;
                jump_reg <= jump_reg_dec;
                lui <= lui_dec;
                aupc <= aupc_dec;
                pc_val <= pc_val_in;
                multiop <= 1'b0;
                alu_out <= 32'bx;
            end else begin
                alu_ctrl <= alu_ctrl_mop;
                alu_selA <= alu_selA_mop;
                alu_selB <= alu_selB_mop;
                reg_write <= reg_write_mop;
                //mod_pc <= mod_pc_mop;
                multiop <= multiop_mop;
                alu_out <= alu_out_in;
            end    
        end
    end

endmodule

