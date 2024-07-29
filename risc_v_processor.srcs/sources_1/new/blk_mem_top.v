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
    wire [1:0] byte_addr;
    reg [3:0] _write_mask;
    reg [3:0] intr_mask;
    reg [3:0] read_mask;
    reg [1:0] intr_offst;
    reg [1:0] read_offst;
    wire [31:0] _dout;
    wire [31:0] byteAddrx8;
    wire [31:0] readOffstx8;
    blk_mem_gen M(clk, wen ? _write_mask : 4'b0000, word_addr,(din << (byteAddrx8)), _dout); //READ FIRST CONFIG
    //masking for both read and write logic
    always @(*) begin
        case (size)
            byte : _write_mask = 4'b0001 << byte_addr;
            half_word : _write_mask = 4'b0011 << byte_addr;
            word : _write_mask = 4'b1111;
        endcase
    end
    assign dout = (_dout & {{8{read_mask[3]}}, {8{read_mask[2]}}, {8{read_mask[1]}}, {8{read_mask[0]}}}) >> (readOffstx8);
    //Pipelined logic
    reg prev_op;
    reg prev_prev_op;
    always @(posedge clk) begin
        intr_mask <= _write_mask;
        read_mask <= intr_mask;
        intr_offst <= byte_addr;
        read_offst <= intr_offst;
        prev_op <= wen;
        prev_prev_op <= prev_op;
    end 
    assign read_valid = ~prev_prev_op;
    
    
    assign word_addr = addr[16:2];
    assign byte_addr = addr[1:0];
    assign byteAddrx8 = byte_addr << 3;
    assign readOffstx8 = read_offst << 3;
endmodule




