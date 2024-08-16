`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/17/2024 01:32:13 AM
// Design Name: 
// Module Name: fetch_to_decode_reg_wall
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


module fetch_to_decode_reg_wall( //double wide reg wall!!!
    input clk,
    input en,
    input [31:0] pc_val_in,
    output reg [31:0] pc_val,
    input newVect_in,
    output reg newVect_out
    );
    reg [31:0] pc_val_intermediate;
    reg newVect_intermediate;
    always @(posedge clk) begin
        if (en) begin
            pc_val_intermediate <= pc_val_in;
            pc_val <= pc_val_intermediate;
            newVect_intermediate <= newVect_in;
            newVect_out <= newVect_intermediate;
        end    
    end
endmodule
