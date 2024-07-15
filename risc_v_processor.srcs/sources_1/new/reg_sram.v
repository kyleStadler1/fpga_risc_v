`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/09/2024 05:02:37 PM
// Design Name: 
// Module Name: reg_sram
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


module reg_sram(
    input clk,
    input [31:0] addr,
    input read_write, //1 for write, 0 for read
    input [31:0] data_in,
    output reg [31:0] data_out
    );
    parameter MEM_SIZE = 25; //100B
    parameter READ = 1'b0;
    parameter WRITE = 1'b0;
    reg [31:0] mem [0:MEM_SIZE - 1];
    reg [31:0] _data_out;
    reg [31:0] _data_in;
    reg _done;
    reg [13:0] _i;
    always @(posedge clk) begin
        if(read_write == READ) begin
            _data_out = mem[addr>>2];
            _data_in = mem[addr>>2];
        end else begin //write
            _data_in = data_in;
            _data_out = data_in;
            mem[addr>>2] <= _data_in;
        end  
        data_out <= _data_out;      
    end   
endmodule
