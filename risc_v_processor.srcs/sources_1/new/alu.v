`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/17/2024 10:03:06 PM
// Design Name: 
// Module Name: alu
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


module alu(
    input [3:0] alu_ctrl,
    input [31:0] A,
    input [31:0] B,
    output [31:0] alu_out,
    output branch
    );
    parameter ALU_AND  = 4'b0000;  
    parameter ALU_OR   = 4'b0001;  
    parameter ALU_XOR  = 4'b0010;  
    parameter ALU_ADD  = 4'b0011;  
    parameter ALU_SUB  = 4'b0100;  
    parameter ALU_SLT  = 4'b0101;  
    parameter ALU_SLTU = 4'b0110;  
    parameter ALU_SLL  = 4'b0111;  
    parameter ALU_SRL  = 4'b1000;  
    parameter ALU_SRA  = 4'b1001;  
    parameter ALU_NOR  = 4'b1010;  
    parameter ALU_LUI  = 4'b1011;  
    parameter ALU_BEQ  = 4'b1100;  
    parameter ALU_BNE  = 4'b1101;  
    parameter ALU_BLT = 4'b1110;  
    parameter ALU_BGET = 4'b1111; 
    reg [31:0] _out;
    reg _branch;
    always @(*) begin
         case(alu_ctrl)
            ALU_AND: begin
                _out = A&B;
                _branch = 0;
            end
            
            ALU_OR: begin
                _out = A|B;
                _branch = 0;
            end
            
            ALU_XOR: begin
                _out = A^B;
                _branch = 0;
            end
            
            ALU_ADD: begin
                _out = A+B; //add overflow later?
                _branch = 0;
            end
            
            ALU_SUB: begin
                _out = B-A; //does it auto convert twos compliment cuz thats its own adder
                _branch = 0;
            end
            
            ALU_SLT: begin
                _out = B < A ? 32'd1 : 32'd0;
                _branch = 0;
            end
            
            ALU_SLTU: begin
                _out = B < A ? 32'd1 : 32'd0;
                _branch = 0;
            end
            
            ALU_SLL: begin
                _out = B << A;
                _branch = 0;
            end
            
            ALU_SRL: begin
                _out = A << B;
                _branch = 0;
            end
            
            ALU_SRA: begin
                _out = B <<< A;
                _branch = 0;
            end
            
            ALU_NOR: begin
                _out = ~(A | B) & 32'hFFFFFFFF;
                _branch = 0;
            end
            
            ALU_LUI: begin
                _out = A <<  B;
                _branch = 0;
            end
            
            ALU_BEQ: begin
                _out = 32'bx;
                _branch = (A^B) ? 0 : 1;
            end
            
            ALU_BNE: begin
                _out = 32'bx;
                _branch = (A^B) ? 1 : 0;
            end
            
            ALU_BLT: begin
                _out = 32'bx;
                _branch = B < A ? 1 : 0;
            end
            
            ALU_BGET: begin
                _out = 32'bx;
                _branch = B >= A ? 1 : 0;
            end
        endcase
    end
    assign out = _out;
    assign branch = _branch;
endmodule
