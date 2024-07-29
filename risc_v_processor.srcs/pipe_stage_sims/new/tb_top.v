`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2024 11:36:01 PM
// Design Name: 
// Module Name: tb_top
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


module tb_top;
    reg clk = 0;
    reg [4:0] IO_addr = 32'd5;
    wire [31:0] IO_out;


    wire P0 = 1'dz;
    wire instr_write_en;
    wire [31:0] dma_instr_addr;
    wire [31:0] dma_instr_data;


    wire P2 = 1'dz;

    //fetch output wires
    wire [31:0] instruction; //fetch.instruction -> dec.instruction
    wire [31:0] pc_val_fetch; //fetch.pc_val -> exec.pc_val
    wire instr_valid;
    //decode output wires
    wire [4:0] rs1;
    wire [4:0] rs2;
//    wire [31:0] rs1_val; 
//    wire [31:0] rs2_val_dec; 
    wire [4:0] rd_dec;
    wire [19:0] imm;
    wire [3:0] alu_ctrl;
    wire [1:0] alu_sel_A;
    wire [1:0] alu_sel_B;
    wire reg_write_dec; 
    wire mem_read_dec;
    wire mem_write_dec;
    wire [1:0] mem_size_dec;
    wire branch;
    wire jal;
    wire jalr;
    wire lui;
    wire aupc;
    
    wire P3 = 1'dz;
        //regfile output wires
    wire [4:0] dra_addrA;
    wire [4:0] dra_addrB;
    wire [31:0] dout_A; //regfile.dout_A -> exec.rs1_val_in
    wire [31:0] dout_B; //regfile.dout_B -> exec.rs2_val_in
    
    wire reg_write_toRF;
    wire [4:0] rd_toRF;
    wire [31:0] alu_val_toRF;
    
    wire P4 = 1'dz;
    //execute output wires
    wire mod_pc;
    wire mem_read_ex;
    wire mem_write_ex;
    wire [1:0] mem_size_ex;
    

    

    
    wire [4:0] rd_ex;
    wire [31:0] alu_val;
    wire [31:0] rs2_val_ex;
    wire P6 = 1'dz;
    wire mem_read_valid;
    wire reg_writeB_en;
    wire [1:0] size_B;
    wire [4:0] rdB;
    wire [31:0] dinB;
    //Control wires - ALL NEED TO BE DRIVEN BY USER
//    wire decode_en = 1;
//    wire execute_en = 1;
//    wire storeload_en = 1;
    
    wire [6:0] debug;

    reg_file regfile (
        //inputs
        .clk(clk),
        .read_addr_A(dra_addrA),
        .read_addr_B(dra_addrB),
        .wen_A(reg_write_toRF),
        .write_addr_A(rd_toRF),
        .din_A(alu_val_toRF),
        .wen_B(reg_writeB_en),
        .write_addr_B(rdB),
        .din_B(dinB),
        .read_addr_C(IO_addr),
        //outputs
        .dout_A(dout_A),
        .dout_B(dout_B),
        .dout_C(IO_out)
    );
    instr_writer writer(
        .clk(clk),
        .instr_write_en(dma_instr_en),
        .addr(dma_instr_addr),
        .data(dma_instr_data)
    );


     fetch_top fetch(
        //inputs
        .clk(clk),
        .branch_vect(32'bx),
        .branch_en(1'b0),
        .dma_instr_write_en(dma_instr_en),
        .dma_instr_addr(dma_instr_addr),
        .dma_instr_write_data(dma_instr_data),
        //outputs
        .instruction(instruction),
        .instr_valid(instr_valid),
        .pc_val(pc_val_fetch)
    );
     dec_top decode(
         //inputs
         .clk(clk),
         .instruction(instruction),
         .en(1'b1),
         //outputs
         .rs1(rs1),
         .rs2(rs2),
         .rd(rd_dec),
         .imm(imm),
         .alu_ctrl(alu_ctrl),
         .alu_sel_A(alu_sel_A),
         .alu_sel_B(alu_sel_B),
         .reg_write(reg_write_dec),
         .mem_read(mem_read_dec),
         .mem_write(mem_write_dec),
         .mem_size(mem_size_dec),
         .branch(branch),
         .jal(jal),
         .jalr(jalr),
         .lui(lui),
         .aupc(aupc),
         .debug(debug)
     );
      exec_top execute (
          //inputs
          .clk(clk),
          .en(1'b1),
          .rs1_in(rs1), 
          .rs2_in(rs2), 
          .dra_addrA(dra_addrA), //output
          .dra_addrB(dra_addrB), //output
          .dra_doutA(dout_A),
          .dra_doutB(dout_B),
          .rd_in(rd_dec),
          .imm(imm),
          .alu_ctrl(alu_ctrl),
          .alu_sel_A(alu_sel_A),
          .alu_sel_B(alu_sel_B),
          .reg_write_in(reg_write_dec), 
          .mem_read_in(mem_read_dec),
          .mem_write_in(mem_write_dec),
          .mem_size_in(mem_size_dec),
          .branch(branch),
          .jal(jal),
          .jalr(jalr),
          .lui(lui),
          .aupc(aupc),
          .pc_val(pc_val_fetch),
          //outputs
          .mod_pc(mod_pc),
          .mem_read(mem_read_ex),
          .mem_write(mem_write_ex),
          .mem_size(mem_size_ex),
          
          .reg_write_toRF(reg_write_toRF),
          .rd_toRF(rd_toRF),
          .alu_val_toRF(alu_val_toRF),
          
          .rd(rd_ex),
          .alu_val(alu_val),
          .rs2_val(rs2_val_ex)
      );
      store_load_top storeload(
          //inputs
          .clk(clk),
          .en(1'b1),
          .mem_read(mem_read_ex),
          .mem_write(mem_write_ex),
          .mem_size(mem_size_ex),
          .rd(rd_ex),
          .alu_val(alu_val),
          .rs2_val(rs2_val_ex),
          .reg_writeB_en(reg_writeB_en),
          .rdB(rdB),
          .dinB(dinB),
          .mem_read_valid(mem_read_valid)
      );
    
     always begin
         #20 clk <= clk + 1;
     end
endmodule
