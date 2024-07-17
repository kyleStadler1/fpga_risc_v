`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2024 10:02:03 PM
// Design Name: 
// Module Name: prog_ctr
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


module prog_ctr(
    input clk,
    input en,
    input rst,
    input[31:0] alu_output, //msb represents sign, in units of instruction offset (units = 4bytes)
    input sel, // 0 is +4, 1 is take from alu
    output wire [31:0] instr_byteAddr //unit is byte address, lsb should always be 0
    );
    parameter RST_VECT = 32'h0;
    reg[31:0] curr_instr; 
    reg[31:0] next_instr;
    initial begin
        curr_instr = RST_VECT;
    end
    always @(posedge clk) begin
        if (rst) begin
            next_instr = RST_VECT;
        end else if (en) begin
            case(sel)
                1'b1 : next_instr = alu_output;
                2'b00 : next_instr = curr_instr + 3'b100; //next 
            endcase
            curr_instr <= next_instr;
        end
    end
    assign instr_byteAddr = curr_instr;
endmodule

