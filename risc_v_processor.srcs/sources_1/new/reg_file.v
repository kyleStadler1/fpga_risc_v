`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/16/2024 11:46:28 PM
// Design Name: 
// Module Name: reg_file
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


module reg_file( //2 read statges 2 write stages
        input clk,
        input [4:0] read_addr_A,
        input [4:0] read_addr_B,
        input wen_A,
        input [4:0] write_addr_A,
        input [31:0] din_A,
        input wen_B,
        input [4:0] write_addr_B,
        input [31:0] din_B,
        input [1:0] size_B,
        output [31:0] dout_A,
        output [31:0] dout_B
    );
    
    reg [31:0] reg_file [31:0];
    always @(posedge clk) begin
        reg_file[32'd0] = 32'd0;
        if (wen_A) begin
            reg_file[write_addr_A] <= din_A;
        end
        if (wen_B) begin
            case(size_B)
            2'b01 : reg_file[write_addr_B] <= (din_B & 32'h000000ff);
            2'b10 : reg_file[write_addr_B] <= (din_B & 32'h0000ffff);
            2'b11 : reg_file[write_addr_B] <= (din_B);
            endcase
            
        end
    end
    assign dout_A = reg_file[read_addr_A];
    assign dout_B = reg_file[read_addr_B];
endmodule
