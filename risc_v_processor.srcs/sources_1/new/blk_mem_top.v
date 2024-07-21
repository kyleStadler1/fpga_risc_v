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
    //input [3:0] wen,
    input wen,
    input [1:0] mem_size,
    input [14:0] addr, //word addressed
    input [31:0] din,
    output [31:0] dout,
    output read_valid
    );
    reg prev_op;
    reg prev_prev_op;
    reg [3:0] write_mask;
    wire [31:0] raw_dout;
    reg [31:0] _dout;
    blk_mem_gen M_d(clk, write_mask, addr, din, raw_dout);

    always @(posedge clk) begin
        prev_op <= wen;
        prev_prev_op <= prev_op;
        
        if (wen) begin
            case(mem_size)
                2'b01 : write_mask = 4'b0001;
                2'b10 : write_mask = 4'b0011;
                2'b11 : write_mask = 4'b1111;
            endcase
        end else begin
            case(mem_size)
                2'b01 : _dout = raw_dout & 32'h000000ff;
                2'b10 : _dout = raw_dout & 32'h0000ffff;
                2'b11 : _dout = raw_dout;
            endcase 
        end
    end
    assign dout = _dout;
    assign read_valid = ~prev_prev_op;
endmodule

