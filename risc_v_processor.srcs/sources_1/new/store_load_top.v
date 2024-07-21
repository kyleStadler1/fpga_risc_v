`timescale 1ns / 1ps
module store_load_top (
    input clk,
    input en,
    input mem_read,
    input mem_write,
    input [1:0] mem_size,
    input [4:0] rd,
    input [31:0] alu_val,
    input [31:0] rs2_val,
    input reg_write,

    output reg_writeA_en,
    output [4:0] rdA,
    output [31:0] dinA,

    output reg_writeB_en,
    output [1:0] size_B,
    output [4:0] rdB,
    output [31:0] dinB
);
    wire read_valid;


    blk_mem_top data_mem(
        .clk(clk),
        .wen(mem_write),
        .mem_size(mem_size),
        .addr(alu_val),
        .din(rs2_val),
        .dout(dinB),
        .read_valid(read_valid)
    );

    reg [4:0] rd_p0;
    reg [4:0] rd_p1;
    reg mem_read_p0;
    reg mem_read_p1;
    reg [1:0] mem_size_p0;
    reg [1:0] mem_size_p1;
    always @(posedge clk) begin
        if (en) begin
            rd_p0 <= rd;
            rd_p1 <= rd_p0;
            mem_read_p0 <= mem_read;
            mem_read_p1 <= mem_read_p0;
            mem_size_p0 <= mem_size;
            mem_size_p1 <= mem_size_p0;

        end
    end


    assign reg_writeA_en = reg_write;
    assign rdA = rd;
    assign dinA = alu_val;

    assign reg_writeB_en = mem_read_p1;
    assign size_B = mem_size_p1;
    assign rdB = rd_p1;
endmodule