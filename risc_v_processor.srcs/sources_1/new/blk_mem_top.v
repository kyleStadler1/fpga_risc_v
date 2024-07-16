`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/15/2024 12:25:56 AM
// Design Name: 
// Module Name: blk_mem_top
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


module blk_mem_top(
    input clk,
    input wen,
    input [14:0] addr,
    input [31:0] din,
    output [31:0] dout,
    output reg read_valid
    );
    blk_mem_gen M(clk, {wen,wen,wen,wen}, addr, din, dout);
    reg [15:0] prev_op;
    always @(posedge clk) begin
        prev_op <= {addr, ren};
        read_valid <= prev_op == {addr, ren};
   end 
endmodule

