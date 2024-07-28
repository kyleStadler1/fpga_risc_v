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
    input [31:0] addr,
    input [31:0] din,
    input [1:0] size,
    output [31:0] dout,
    output read_valid
    );
    parameter byte = 2'b01;
    parameter half_word = 2'b10;
    parameter word = 2'b11;
    wire [14:0] word_addr;
    wire [2:0] byte_addr;
    reg [3:0] _mask;
    wire [31:0] _dout;
    blk_mem_gen M(clk, wen ? _mask : 4'b0000, word_addr, din, _dout);
    
    //masking for both read and write logic
    always @(*) begin
            case (size)
                byte : _mask = 4'b0001 << byte_addr;
                half_word : _mask = 4'b0011 << byte_addr;
                word : _mask = 4'b1111;
            endcase
    end
    assign dout = _dout & _mask;//fan it out
   
   //read valid logic
    reg prev_op;
    reg prev_prev_op;
    always @(posedge clk) begin
        prev_op <= wen;
        prev_prev_op <= prev_op;
   end 
   assign read_valid = ~prev_prev_op;
   
   
   assign word_addr = addr[16:2];
   assign byte_addr = addr[1:0];
endmodule




