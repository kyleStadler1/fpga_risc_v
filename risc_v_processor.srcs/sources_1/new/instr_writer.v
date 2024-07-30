`timescale 1ns / 1ps


module instr_writer (
    input clk,
    output instr_write_en,
    output [31:0] addr,
    output [31:0] data
);

parameter last_index = 32'd5;

reg [31:0] mi [0 : last_index];

reg _en;
reg [31:0] _addr;
reg [31:0] _data;





reg init = 0;
reg [31:0] load_index = 32'b0;
always @(posedge clk) begin
    if (!init) begin
        _en = 1;

mi[0] <= 32'h00500093;  // addi x1, x0, 5
mi[1] <= 32'h00400113;  // addi x2, x0, 5
mi[2] <= 32'h00209463;  // beq x1, x2, 2
mi[3] <= 32'hff9ff06f;  // j end
mi[4] <= 32'h00100193;  // addi x3, x0, 1
mi[5] <= 32'h00200193;  // addi x3, x0, 2






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




//Problem Log//////////////////////////////////////////
//    addi x1, x0, 6  
//    addi x2, x0, 7
//    add x3, x1, x2
//    sb x3, 3(x0)
//    lw x4, 0(x0)
//    sb x3, 2(x0)
//    lw x4, 0(x0)
//    sb x3, 1(x0)
//    lw x4, 0(x0)
//    sb x3, 0(x0)
//    lw x4, 0(x0) //WORKS!?!?! NOW....
//    lb x4, 0(x0)







//////////////////////////////////////////



//        mi[0] <= 32'h00600093;  // addi x1, x0, 6
//        mi[1] <= 32'h00700113;  // addi x2, x0, 7
//        mi[2] <= 32'h002081b3;  // add x3, x1, x2
//        mi[3] <= 32'h003001a3;  // sb x3, 3(x0)
//        mi[4] <= 32'h00002203;  // lw x4, 0(x0)
//        mi[5] <= 32'h00300123;  // sb x3, 2(x0)
//        mi[6] <= 32'h00002203;  // lw x4, 0(x0)
//        mi[7] <= 32'h003000a3;  // sb x3, 1(x0)
//        mi[8] <= 32'h00002203;  // lw x4, 0(x0)
//        mi[9] <= 32'h00300023;  // sb x3, 0(x0)
//        mi[10] <= 32'h00002203; // lw x4, 0(x0)
//        mi[11] <= 32'h00100203; // lb x4, 1(x0)
//        mi[12] <= 32'h00000203; // lb x4, 0(x0)
        
//        mi[13] <= 32'h00201203; // lh x4, 2(x0)
       





