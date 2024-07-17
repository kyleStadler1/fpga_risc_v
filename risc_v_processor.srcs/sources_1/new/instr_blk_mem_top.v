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
    input [3:0] wen,
    input [13:0] addr, //word addressed
    input [31:0] din,
    output [31:0] dout,
    output reg read_valid
    );
    reg [31:0] _dout_raw;
    blk_mem_gen_i M_i(clk, wen, addr, din, dout);
    reg [17:0] prev_op;
    always @(posedge clk) begin 
        prev_op <= {addr, wen};
        read_valid <= prev_op == {addr, wen};
   end 
endmodule
