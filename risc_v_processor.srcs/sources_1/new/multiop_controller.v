`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/17/2024 10:03:06 PM
// Design Name: 
// Module Name: multiop_controller
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


module multiop_controller(
    // Input only
    input reg_write,
    input alu_branch,
    // Input and output
    //input [3:0] alu_ctrl_in,
    input jal,
    input jalr,
    input auipc,
    input mop_in,
    output [3:0] aluCtrl_mop,
    output [1:0] selA_mop,
    output [1:0] selB_mop,
    output reg_write_out,
    output mod_pc, //need to update this if or ifnot branch
    output mop_out
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

    parameter RS2_to_A = 2'b00;
    parameter IMM_to_A = 2'b01;
    parameter four_to_A = 2'b10;
    parameter ALU_to_A = 2'b11;
    parameter RS1_to_B = 2'b00;
    parameter PC_to_B = 2'b01;
    parameter twelve_to_B = 2'b10;
    parameter ALU_to_B = 2'b11;
    
    reg [1:0] _alu_selA;
    reg [1:0] _alu_selB;
    reg [3:0] _alu_ctrl_out;
    reg _reg_write_out;
    reg _mod_pc = 0; 
    reg _multiop_out = 0;

    always @(*) begin
        case(mop_in)
            1'b0 : begin
                    if (alu_branch) begin
                        _alu_selA = IMM_to_A;
                        _alu_selB = PC_to_B;
                        _alu_ctrl_out = ALU_ADD;
                        _reg_write_out = 0;
                        _mod_pc = 1;
                        _multiop_out = 1;
                    end   
                    else if (jal) begin
                        _alu_selA = IMM_to_A;
                        _alu_selB = PC_to_B;
                        _alu_ctrl_out = ALU_ADD;
                        _reg_write_out = 1;
                        _mod_pc = 1;
                        _multiop_out = 1;
                    end
                    else if (jalr) begin
                        _alu_selA = IMM_to_A;
                        _alu_selB = RS1_to_B;
                        _alu_ctrl_out = ALU_ADD;
                        _reg_write_out = 1;
                        _mod_pc = 1;
                        _multiop_out = 1;
                    end 
                    else if (auipc) begin
                        _alu_selA = ALU_to_A;
                        _alu_selB = PC_to_B;
                        _alu_ctrl_out = ALU_ADD;
                        _reg_write_out = 1;
                        _multiop_out = 1;
                    end
                    else begin
                        _multiop_out = 0;
                        _mod_pc = 0; 
                        _reg_write_out = reg_write;
                    end
            end
            1'b1 : begin
                _multiop_out = 0;
                _mod_pc = 0;
                _reg_write_out = 0;
            end
        endcase
    end
    assign aluCtrl_mop = _alu_ctrl_out;
    assign selA_mop = _alu_selA;
    assign selB_mop = _alu_selB;
    assign reg_write_out = _reg_write_out;
    assign mod_pc = _mod_pc;
    assign mop_out = _multiop_out;
endmodule