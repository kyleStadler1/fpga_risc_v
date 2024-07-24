`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/23/2024 04:33:29 PM
// Design Name: 
// Module Name: tb_execRegWall
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


module tb_execRegWall;

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
 //alu input src
 parameter RS2_to_A = 2'b00;
 parameter IMM_to_A = 2'b01;
 parameter four_to_A = 2'b10;
 parameter RS1_to_B = 2'b00;
 parameter PC_to_B = 2'b01;
 parameter twelve_to_B = 2'b10;
 //input instr Type
 parameter R_TYPE = 7'b0110011;
 parameter I_TYPE = 7'b0010011;
 parameter STORE = 7'b0100011;
 parameter LOAD = 7'b0000011;
 parameter BRANCH = 7'b1100011;
 parameter JALR = 7'b1100111;
 parameter JAL = 7'b1101111;
 parameter AUIPC = 7'b0010111;
 parameter LUI = 7'b0110111;
 parameter ENV = 7'b1110011;
    reg clk = 0;
    reg en = 1'b1;
    reg [31:0] rs1_val_dec = 32'dx;
    reg [31:0] rs2_val_dec = 32'dx;
    reg [4:0] rd_dec = 5'd3;
    reg [19:0] imm_dec = 32'd6;
    reg [3:0] alu_ctrl_dec = ALU_ADD;
    reg [1:0] alu_selA_dec = IMM_to_A;
    reg [1:0] alu_selB_dec = RS1_to_B;
    reg reg_write_dec = 1;
    reg mem_read_dec = 0;
    reg mem_write_dec = 0;
    reg [1:0] mem_size_dec = 3'bx;
    reg pot_branch_dec = 0;
    reg jump_dec = 0;
    reg jump_reg_dec = 0;
    reg lui_dec = 0;
    reg aupc_dec = 0;
    reg [31:0] pc_val_in = 32'hdeadbeef;
    reg [3:0] alu_ctrl_in_mop;
    reg [1:0] alu_selA_mop;
    reg [1:0] alu_selB_mop;
    reg mod_pc_mop = 0;
    reg multiop_mop = 0;
    reg [31:0] alu_out_in;

    wire [31:0] rs1_val;
    wire [31:0] rs2_val; 
    wire [4:0] rd;
    wire [19:0] imm;
    wire [3:0] alu_ctrl;
    wire [1:0] alu_selA;
    wire [1:0] alu_selB;
    wire reg_write;
    wire mem_read;
    wire mem_write;
    wire [1:0] mem_size;
    wire branch_pot;
    //wire mod_pc,
    wire jump;
    wire jump_reg;
    wire lui; 
    wire aupc;
    wire [31:0] pc_val;
    wire multiop;
    wire [31:0] alu_out;

    decode_to_execute_reg_wall uut (
        .clk(clk),
        .en(en),
        .rs1_val_dec(rs1_val_dec),
        .rs2_val_dec(rs2_val_dec),
        .rd_dec(rd_dec),
        .imm_dec(imm_dec),
        .alu_ctrl_dec(alu_ctrl_dec),
        .alu_selA_dec(alu_selA_dec),
        .alu_selB_dec(alu_selB_dec),
        .reg_write_dec(reg_write_dec),
        .mem_read_dec(mem_read_dec),
        .mem_write_dec(mem_write_dec),
        .mem_size_dec(mem_size_dec),
        .pot_branch_dec(pot_branch_dec),
        .jump_dec(jump_dec),
        .jump_reg_dec(jump_reg_dec),
        .lui_dec(lui_dec),
        .aupc_dec(aupc_dec),
        .pc_val_in(pc_val_in),
        .alu_ctrl_in_mop(alu_ctrl_in_mop),
        .alu_selA_mop(alu_selA_mop),
        .alu_selB_mop(alu_selB_mop),
        .mod_pc_mop(mod_pc_mop),
        .multiop_mop(multiop_mop),
        .alu_out_in(alu_out_in),
        .rs1_val(rs1_val),
        .rs2_val(rs2_val), 
        .rd(rd),
        .imm(imm),
        .alu_ctrl(alu_ctrl),
        .alu_selA(alu_selA),
        .alu_selB(alu_selB),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_size(mem_size),
        .branch_pot(branch_pot),
        .jump(jump),
        .jump_reg(jump_reg),
        .lui(lui),
        .aupc(aupc),
        .pc_val(pc_val),
        .multiop(multiop),
        .alu_out(alu_out)
    );


    always begin
        #20 clk <= clk + 1;
    end


endmodule
