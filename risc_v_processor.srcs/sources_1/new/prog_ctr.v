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
    input[31:0] branch_vect, //msb represents sign, in units of instruction offset (units = 4bytes)
    input sel, // 0 is +4, 1 is take from alu
    output wire [31:0] pc_val //unit is byte address, lsb should always be 0
    );
    parameter RST_VECT = 32'h0;
    reg[31:0] curr_instr = 32'h0; 
    reg[31:0] next_instr = 32'h0;
    initial begin
        curr_instr = RST_VECT;
    end
    always @(posedge clk) begin
        if (rst) begin
            next_instr = RST_VECT;
        end else if (en) begin
            case(sel)
                1'b1 : next_instr = branch_vect;
                1'b0 : next_instr = curr_instr + 3'b100; //next 
                default : next_instr = 32'd999;
            endcase
            curr_instr <= next_instr;
        end
    end
    assign pc_val = curr_instr;
endmodule

