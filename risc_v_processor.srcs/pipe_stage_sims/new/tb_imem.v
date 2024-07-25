`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/24/2024 10:57:03 PM
// Design Name: 
// Module Name: tb_imem
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


module tb_imem;
    reg clk = 0;
    reg mem_read_ex;
    reg mem_write_ex;
    reg [4:0] rd_ex;
    reg [31:0] alu_val;
    reg [31:0] rs2_val_ex;
    wire [31:0] dout;
    wire read_valid;
    
//    instr_blk_mem_top data_mem(
//        .clk(clk),
//        .wen(mem_write_ex),
//       // .mem_size(mem_size_ex),
//        .addr(alu_val),
//        .din(rs2_val_ex),
//        .dout(dout),
//        .read_valid(read_valid)
//    );
    
    initial begin
        clk = 0;
        mem_read_ex = 0;
        mem_write_ex = 1;
//        mem_size_ex = 2'b11;
        alu_val = 32'd4;
        rs2_val_ex = 32'hd;
        #10;
        clk = 1;
        #10;
        clk = 0;
        mem_read_ex = 1;
        mem_write_ex = 0;
//        mem_size_ex = 2'b11;
        alu_val = 32'd4;
        rs2_val_ex = 32'hx;
        #10;
        clk = 1;
        #10;
        clk = 0;
        #10;
        clk = 1;
        #10;
        clk = 0;
        #10;
        clk = 1;
        #10;
        clk = 0;
        #10;
        clk = 1;
        $finish;
        end
endmodule
