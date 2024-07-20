`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/16/2024 01:14:36 AM
// Design Name: 
// Module Name: instr_blk_mem_top
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


module instr_blk_mem_top(
    input clk,
    input [13:0] addr, //word addressed
    input dma_instr_write_en,
    input [31:0] dma_instr_write, //data
    input [31:0] dma_instr_addr, //
    output [31:0] dout,
    output read_valid
    );
    reg prev_op;
    reg prev_prev_op;
    blk_mem_gen_i instruction_mem(clk, {dma_instr_write_en, dma_instr_write_en, dma_instr_write_en, dma_instr_write_en}, dma_instr_write_en ? dma_instr_addr : addr, dma_instr_write, dout);
    always @(posedge clk) begin
        prev_op <= dma_instr_write_en;
        prev_prev_op <= prev_op;
    end
    assign read_valid = ~prev_prev_op;
endmodule
