`timescale 1ns / 1ps


module instr_writer (
    input clk,
    output instr_write_en,
    output [31:0] addr,
    output [31:0] data
);

parameter last_index = 32'd2;

reg [31:0] mi [0 : last_index];

reg _en;
reg [31:0] _addr;
reg [31:0] _data;


//addi x1 , x0,   6
//addi x2 , x10,   7
//add x3 , x1,  x2
//sw x3 , 0(x0)
//addi x4, x0, 8
//addi x5, x0, 9
//add x6, x4, x5
//sw x6 , 1(x0)
//lb x3, 0(x0)
//lb x6, 1(x0)

//00600093
//00750113
//002081b3
//00302023
//00800213
//00900293
//00520333
//006020a3
//00000183
//00100303


reg init = 0;
reg [31:0] load_index = 32'b0;
always @(posedge clk) begin
    if (!init) begin
        _en = 1;
        mi[0] <= 32'h00600093;
        mi[1] <= 32'h00700113;
        mi[2] <= 32'h002081b3;
//        mi[3] <= 32'h00302023;
//        mi[4] <= 32'h00800213;
//        mi[5] <= 32'h00900293;
//        mi[6] <= 32'h00520333;
//        mi[7] <= 32'h006020a3;
//        mi[8] <= 32'h00000183;
//        mi[9] <= 32'h00100303;
        
        init <= 1;
    end else if (load_index <= last_index) begin
        _en = 1;
        _addr = load_index << 2;
        _data = mi[load_index];
        load_index <= load_index + 1;
    end else begin
        _en = 0;
        _addr = 32'bx;
        _data = 32'bx;
    end
    end
    assign instr_write_en = _en;
    assign addr = _addr;
    assign data = _data;
endmodule