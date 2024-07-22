`timescale 1ns / 1ps



module tb_decode;
    reg clk = 0;
    reg [31:0] branch_vect = 32'b0;
    reg branch_en = 0;

    wire dma_instr_en;
    wire [31:0] dma_instr_addr;
    wire [31:0] dma_instr_data;

    wire [31:0] instruction;
    wire instruction_valid;
    wire [31:0] pc_val;

    //decode output wires
   wire [4:0] rs1;
   wire [4:0] rs2;
   wire [31:0] rs1_val; 
   wire [31:0] rs2_val_dec; 
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

    instr_writer writer(
        .clk(clk),
        .instr_write_en(dma_instr_en),
        .addr(dma_instr_addr),
        .data(dma_instr_data)
    );


     fetch_top fetch(
        //inputs
        .clk(clk),
        .branch_vect(branch_vect),
        .branch_en(branch_en),
        .dma_instr_write_en(dma_instr_en),
        .dma_instr_addr(dma_instr_addr),
        .dma_instr_write_data(dma_instr_data),
        //outputs
        .instruction(instruction),
        .instr_valid(instruction_valid),
        .pc_val(pc_val)
    );
   dec_top decode(
       //inputs
       .clk(clk),
       .instruction(instruction),
       .en(1'b1),
       .rs1_val_in(dout_A),
       .rs2_val_in(dout_B),
       //outputs
       .rs1(rs1),
       .rs2(rs2),
       .rs1_val(rs1_val),
       .rs2_val(rs2_val_dec),
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
       .aupc(aupc)
   );
    
    always begin
        #20 clk <= clk + 1;
    end



endmodule