`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/24/2024 10:07:18 PM
// Design Name: 
// Module Name: tb_dmem
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


module tb_dmem;
    reg clk = 0;
    reg mem_read;
    reg mem_write;
    reg [1:0] mem_size;
    reg [4:0] rd;
    reg [31:0] addr;
    reg [31:0] din;
    wire [31:0] dout;
    wire read_valid;
    
    blk_mem_top data_mem(
        .clk(clk),
        .wen(mem_write),
        .addr(addr),
        .din(din),
        .size(mem_size),
        .dout(dout),
        .read_valid(read_valid)
    );
    
//    initial begin
//        clk = 0;
//        mem_read_ex = 0;
//        mem_write_ex = 1;
//        mem_size_ex = 2'b11;
//        alu_val = 32'd0;
//        rs2_val_ex = 32'hd;
//        #10;
//        clk = 1;
//        #10;
//        clk = 0;
//        mem_read_ex = 1;
//        mem_write_ex = 0;
//        mem_size_ex = 2'b11;
//        rs2_val_ex = 32'hx;
//        #10;
//        clk = 1;
//        #10;
//        clk = 0;
//        #10;
//        clk = 1;
//        #10;
//        clk = 0;
//        #10;
//        clk = 1;
//        #10;
//        clk = 0;
//        #10;
//        clk = 1;
//        $finish;
//        end
        
    reg [31:0] ctr = 0;
    always @(posedge clk) begin
        ctr <= ctr + 1;
        case(ctr)
        1 : begin
            mem_read = 0;
            mem_write = 1;
            mem_size = 2'b01;
            addr = 0;
            din = 32'ha;
            end
        2 : begin
            mem_read = 0;
            mem_write = 1;
            mem_size = 2'b01;
            addr = 1;
            din = 32'hb;
            end
        3 : begin
            mem_read = 0;
            mem_write = 1;
            mem_size = 2'b01;
            addr = 2;
            din = 32'hc;
            end
        4 : begin
            mem_read = 0;
            mem_write = 1;
            mem_size = 2'b01;
            addr = 3;
            din = 32'hd;
            end
        5 : begin
            mem_read = 1;
            mem_write = 0;
            mem_size = 2'b11;
            addr = 0;
            end
        6 : begin
            mem_read = 1;
            mem_write = 0;
            mem_size = 2'b10;
            addr = 0;
            end
        7 : begin
            mem_read = 1;
            mem_write = 0;
            mem_size = 2'b10;
            addr = 2;
            end
        8 : begin
            mem_read = 1;
            mem_write = 0;
            mem_size = 2'b01;
            addr = 0;
            end
        9 : begin
            mem_read = 1;
            mem_write = 0;
            mem_size = 2'b01;
            addr = 1;
            end
        10 : begin
            mem_read = 1;
            mem_write = 0;
            mem_size = 2'b01;
            addr = 2;
            end
        11 : begin
            mem_read = 1;
            mem_write = 0;
            mem_size = 2'b01;
            addr = 3;
            end
        endcase
    end  

    
     always begin
         #20 clk <= clk + 1;
     end
endmodule
