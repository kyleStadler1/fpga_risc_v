`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/09/2024 08:21:09 PM
// Design Name: 
// Module Name: tb_pcToMem
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


module tb_pcToMem;
    reg clk;
    wire [31:0] mem_addr;
    reg read_write;//1 for write, 0 for read
    reg [31:0] data_in;
    wire [31:0] data_out;
    reg pc_en;
    wire [31:0] instr_addr; //sel = 1
    reg [31:0] _instr_addr; //sel = 0
    reg addrSel;
    
    reg_sram myram(clk, mem_addr, read_write, data_in, data_out);
    prog_ctr pc(clk, pc_en, 1'b0, 12'b0, 20'b0, 2'b0, instr_addr);
        
    initial  begin
        clk = 0;
        forever #(10) clk = ~clk;
    end
    
    initial begin
        addrSel = 0;
        pc_en = 0;
        #20;
        //populate memory with instructions
        read_write = 1;
        _instr_addr = 32'h0;
        data_in = 32'ha;
        #20;
        _instr_addr = 32'h4;
        data_in = 32'hb;
        #20;
        _instr_addr = 32'h8;
        data_in = 32'hc;
        #20;
        _instr_addr = 32'hc;
        data_in = 32'hd;
        #20;
        _instr_addr = 32'h10;
        data_in = 32'he;
        #20;
        _instr_addr = 32'h14;
        data_in = 32'hf;
        #20;
        //done loading instructions
        read_write = 0;
        addrSel = 1;
        pc_en = 1;
        #200;
    end
    
    assign mem_addr = addrSel ? instr_addr : _instr_addr;
    
    
    
endmodule




