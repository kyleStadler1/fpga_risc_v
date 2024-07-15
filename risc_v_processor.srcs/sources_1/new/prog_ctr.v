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
    input[11:0] branch_ofst, //msb represents sign, in units of instruction offset (units = 4bytes)
    input[19:0] jump_ofst, //msb represents sign, in units of instruction offset (units = 4bytes)
    input[1:0] sel, // [branchCtrl, jumpCtrl]
    output wire [31:0] instr //unit is byte address, lsb should always be 0
    );
    parameter RST_VECT = 32'h0;
    reg[31:0] curr_instr; 
    reg[31:0] next_instr = RST_VECT;
    initial begin
        curr_instr = RST_VECT;
    end
    always @(posedge clk) begin
        if (rst) begin
            next_instr <= RST_VECT;
        end else if (en) begin
            case(sel)
                2'b10 : next_instr = ({{20{branch_ofst[11]}}, branch_ofst} << 2); //branch
                2'b01 : next_instr = ({{12{jump_ofst[19]}}, jump_ofst} << 2); //jump
                2'b00 : next_instr = curr_instr + 3'b100; //next instr
                2'b11 : next_instr = 32'bx; //error: branchCtrl, jumpCtrl should be exclusive, undefined state
            endcase
            curr_instr <= next_instr;
        end
    end
    assign instr_byteAddr = curr_instr;
endmodule

