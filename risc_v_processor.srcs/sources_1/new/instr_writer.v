`timescale 1ns / 1ps


module instr_writer (
    input clk,
    output instr_write_en,
    output [31:0] addr,
    output [31:0] data
);

parameter last_index = 32'd2;

reg [8:0] mi [0 : last_index];


reg init = 0;
reg [31:0] load_index = 32'b0;
always @(posedge clk) begin
    if (!init) begin
        instr_write_en = 1;
        mi[0] <= 32'h00600093;
        mi[1] <= 32'h00700113;
        mi[2] <= 32'h002081b3;
        init <= 1;
    end else if (load <= last_index) begin
        instr_write_en = 1;
        addr = load_index << 2;
        data = mi[load_index];
    end else begin
        instr_write_en = 0;
        addr = 32'bx;
        data = 32'bx;
    end
end
endmodule