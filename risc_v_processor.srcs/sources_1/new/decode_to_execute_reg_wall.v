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
    //feed from decode    
    input [4:0] rs1_in_dec,
    input [4:0] rs2_in_dec,
    input [4:0] rd_in_dec,
    input [19:0] imm_in_dec,
    input [3:0] alu_ctrl_in_dec,
    input [1:0] alu_selA_in_dec,
    input [1:0] alu_selB_in_dec,
    input reg_write_in_dec,
    input mem_read_in_dec,
    input mem_write_in_dec,
    input [1:0] mem_size_in_dec,
    input jal_in_dec,
    input jalr_in_dec,
    input aupc_in_dec,
    input [31:0] pc_val_in,
    //feed from mop
    input mop_en_in,
    input mod_pc_in,
    input [3:0] alu_ctrl_in_mop,
    input [1:0] selA_in_mop,
    input [1:0] selB_in_mop,
    input [31:0] curr_alu_val_in,
    //muxed output from either mop or decode
    output [1:0] alu_selA_out,
    output [1:0] alu_selB_out,
    output [3:0] alu_ctrl_out,
    //decode always output
    output [4:0] rs1_out,
    output [4:0] rs2_out, 
    output [4:0] rd_out, //
    output [19:0] imm_out, //
    output reg_write_simple_out,
    output mem_read_out, //
    output mem_write_out, //
    output [1:0] mem_size_out,
    output jal_out,
    output jalr_out,
    output aupc_out,
    output [31:0] pc_val_out,
    //mop always output
    output mop_en_out,
    output [31:0] prev_alu_val_out,
    output _sel
    ); 
    reg [1:0] alu_selA_dec, alu_selA_mop;
    reg [1:0] alu_selB_dec, alu_selB_mop;
    reg [3:0] alu_ctrl_dec, alu_ctrl_mop;
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [4:0] rd;
    reg [19:0] imm;
    reg reg_write_simple;
    reg mem_read;
    reg mem_write;
    reg [1:0] mem_size;
    reg jal;
    reg jalr;
    reg aupc;
    reg [31:0] pc_val;
    reg mop_en;
    reg [31:0] prev_alu_val;
    
    reg sel;
    reg [1:0] ctr = 0;
    always @(posedge clk) begin
        ctr = mod_pc_in ? 2'd10 : 2'd0;
        if (ctr > 0) begin
            ctr <= ctr - 1;
        end
        sel <= mop_en_in | ctr > 0;
        
        rs1 <= rs1_in_dec;
        rs2 <= rs2_in_dec;
        rd <= rd_in_dec;
        imm <= imm_in_dec;
        alu_ctrl_dec <= alu_ctrl_in_dec;
        alu_selA_dec <= alu_selA_in_dec;
        alu_selB_dec <= alu_selB_in_dec;
        reg_write_simple <= reg_write_in_dec;
        mem_read <= mem_read_in_dec;
        mem_write <= mem_write_in_dec;
        mem_size <= mem_size_in_dec;
        jal <= jal_in_dec;
        jalr <= jalr_in_dec;
        aupc <= aupc_in_dec;
        pc_val <= pc_val_in;
        mop_en <= mop_en_in;
        alu_ctrl_mop <= alu_ctrl_in_mop;
        alu_selA_mop <= selA_in_mop;
        alu_selB_mop <= selB_in_mop;
        prev_alu_val <= curr_alu_val_in;
    end
    
    assign alu_selA_out = sel ? alu_selA_mop : alu_selA_dec;
    assign alu_selB_out = sel ? alu_selB_mop : alu_selB_dec;
    assign alu_ctrl_out = sel ? alu_ctrl_mop : alu_ctrl_dec;
    assign rs1_out = rs1;
    assign rs2_out = rs2;
    assign rd_out = rd;
    assign imm_out = imm;
    assign reg_write_simple_out = reg_write_simple;
    assign mem_read_out = mem_read;
    assign mem_write_out = mem_write;
    assign mem_size_out = mem_size;
    assign jal_out = sel ? 0 : jal;
    assign jalr_out = sel ? 0 : jalr;
    assign aupc_out = sel ? 0 : aupc;
    assign pc_val_out = pc_val;
    assign mop_en_out = mop_en;
    assign prev_alu_val_out = prev_alu_val;
    
    assign _sel = sel;
endmodule

