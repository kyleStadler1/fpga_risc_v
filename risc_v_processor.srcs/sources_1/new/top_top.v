`timescale 1ns / 1ps
module top_top (
    input  clk,
    output [9:0] led
);
    //Write to instruction memory wires - ALL NEED TO BE DRIVEN BY USER
    wire instr_write_en = 0;
    wire [31:0] instr_addr;
    wire [31:0] instr_data;
    //regfile output wires
    wire [31:0] dout_A; //regfile.dout_A -> exec.rs1_val_in
    wire [31:0] dout_B; //regfile.dout_B -> exec.rs2_val_in
    //fetch output wires
    wire [31:0] instruction; //fetch.instruction -> dec.instruction
    wire [31:0] pc_val_fetch; //fetch.pc_val -> exec.pc_val
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
    //execute output wires
    wire mod_pc;
    wire mem_read_ex;
    wire mem_write_ex;
    wire [1:0] mem_size_ex;
    wire reg_write_ex;
    wire [4:0] rd_ex;
    wire [31:0] alu_val;
    wire [31:0] rs2_val_ex;
    //storeload output wires
    wire reg_writeA_en;
    wire [4:0] rdA;
    wire [31:0] dinA;
    wire reg_writeB_en;
    wire [1:0] size_B;
    wire [4:0] rdB;
    wire [31:0] dinB;
    //Control wires - ALL NEED TO BE DRIVEN BY USER
    wire decode_en = 1;
    wire execute_en = 1;
    wire storeload_en = 1;

    //CPU modules instantiation
    reg_file regfile (
        //inputs
        .clk(clk),
        .read_addr_A(rs1),
        .read_addr_B(rs2),
        .wen_A(reg_writeA_en),
        .write_addr_A(rdA),
        .din_A(dinA),
        .wen_B(reg_writeB_en),
        .write_addr_B(rdB),
        .din_B(dinB),
        .size_B(size_B),
        //outputs
        .dout_A(dout_A),
        .dout_B(dout_B)
    );
    fetch_top fetch(
        //inputs
        .clk(clk),
        .branch_vect(alu_val),
        .branch_en(mod_pc),
        .dma_instr_write_en(instr_write_en),
        .dma_instr_addr(instr_addr),
        .dma_instr_write_data(instr_data),
        //outputs
        .instruction(instruction),
        .instr_valid(),
        .pc_val(pc_val_fetch)
    );
    dec_top decode(
        //inputs
        .clk(clk),
        .instruction(instruction),
        .en(decode_en&instr_write_en),
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
    exec_top execute (
        //inputs
        .clk(clk),
        .en(execute_en&instr_write_en),
        .rs1_val_in(rs1_val), 
        .rs2_val_in(rs2_val_dec), 
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
        .reg_write(reg_write_ex),
        .rd(rd_ex),
        .alu_val(alu_val),
        .rs2_val(rs2_val_ex)
    );
    store_load_top storeload(
        //inputs
        .clk(clk),
        .en(storeload_en&instr_write_en),
        .mem_read(mem_read_ex),
        .mem_write(mem_write_ex),
        .mem_size(mem_size_ex),
        .rd(rd_ex),
        .alu_val(alu_val),
        .rs2_val(rs2_val),
        .reg_write(reg_write_ex),
        //outputs
        .reg_writeA_en(reg_writeA_en),
        .rdA(rdA),
        .dinA(dinA),
        .reg_writeB_en(reg_writeB_en),
        .size_B(size_B),
        .rdB(rdB),
        .dinB(dinB)
    );

    
//    parameter instruction_count = 20;
//    reg [31:0] mi [0 : instruction_count-1];

    

//    reg [31:0] ctr = 0;
//    always @(posedge clk) begin
//        ctr <= ctr+1;
//        if (ctr == 0) begin
//            instr_write_en = 1;
//            mi[0] <= 32'h00600093;
//            mi[1] <= 32'h00700113;
//            mi[2] <= 32'h002081b3;
//        end
//        if (ctr > 0 && ctr < 4) begin
//            instr_write_en = 1;
//            instr_addr = ctr - 1;
//            instr_data = mi[ctr - 1];
//        end
//        if (ctr >= 4) begin
//            instr_write_en = 0;
//        end
//    end








    //IO
    assign led[9:0] = alu_val[9:0];

endmodule