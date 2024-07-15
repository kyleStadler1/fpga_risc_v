`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/09/2024 07:43:54 PM
// Design Name: 
// Module Name: tb_sram
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


module tb_sram;
    wire clk;
    wire rst;
    wire [31:0] addr;
    wire read_write;
    wire [31:0] data_in;
    wire [31:0] data_out;
    
    reg_sram myRam(clk, rst, addr, read_write, data_in, data_out);
    
    initial begin

    end
    
endmodule
