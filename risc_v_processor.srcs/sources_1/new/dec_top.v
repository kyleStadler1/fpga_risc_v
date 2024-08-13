`timescale 1ns / 1ps
module dec_top (
    input clk, 
    input [31:0] instruction,
    input en, 
    output reg [4:0] rs1, 
    output reg [4:0] rs2,
    output reg [4:0] rd,
    output reg [31:0] imm,
    output reg [3:0] alu_ctrl,
    output reg [1:0] alu_sel_A,
    output reg [1:0] alu_sel_B,
    output reg reg_write, 
    output reg mem_read,
    output reg mem_write,
    output reg [1:0] mem_size,
    output reg branch,
    output reg jal,
    output reg jalr,
    output reg lui,
    output reg aupc
    //output reg [6:0] debug
    );

    wire [4:0] _rs1, _rs2, _rd;
    wire [31:0] _imm;
    wire [3:0] _alu_ctrl;
    wire [1:0] _alu_sel_A, _alu_sel_B;
    wire _reg_write, _mem_read, _mem_write;
    wire [1:0] _mem_size;
    wire _branch, _jal, _jalr, _lui, _aupc;
    //wire [6:0] _debug;

    // Instantiate the decode module
    decode decode(
        .clk(clk),
        .instr(instruction),
        .en(en),
        .rs1(_rs1),
        .rs2(_rs2),
        .rd(_rd),
        .imm(_imm),
        .alu_ctrl(_alu_ctrl),
        .alu_sel_A(_alu_sel_A),
        .alu_sel_B(_alu_sel_B),
        .reg_write(_reg_write),
        .mem_read(_mem_read),
        .mem_write(_mem_write),
        .mem_size(_mem_size),
        .branch(_branch),
        .jal(_jal),
        .jalr(_jalr),
        .lui(_lui),
        .aupc(_aupc)
        //.debug(_debug)
    );

    // Always block to assign values to the registers on each positive edge of the clock
    always @(posedge clk) begin
        if (en) begin
            rs1 <= _rs1;
            rs2 <= _rs2;
            rd <= _rd;
            imm <= _imm;
            alu_ctrl <= _alu_ctrl;
            alu_sel_A <= _alu_sel_A;
            alu_sel_B <= _alu_sel_B;
            reg_write <= _reg_write;
            mem_read <= _mem_read;
            mem_write <= _mem_write;
            mem_size <= _mem_size;
            branch <= _branch;
            jal <= _jal;
            jalr <= _jalr;
            lui <= _lui;
            aupc <= _aupc;
            //debug <= _debug;
        end
    end

endmodule