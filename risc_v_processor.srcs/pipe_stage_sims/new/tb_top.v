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
    //tb wires
    reg clk = 0;
    reg [4:0] IO_addr = 5'd5;
    wire [31:0] IO_out;
//////////////////////////////////////////////////////////////////////////////////
    wire P0 = 1'dz; 
    wire instr_write_en;
    wire [31:0] dma_instr_addr;
    wire [31:0] dma_instr_data;
//////////////////////////////////////////////////////////////////////////////////
    wire P2 = 1'dz;
    //fetch output wires
    wire [31:0] instruction; 
    wire [31:0] pc_val_fetch; 
    wire newVect_fetch;
    wire instr_valid;
//////////////////////////////////////////////////////////////////////////////////
    wire P3 = 1'dz;
    //decode output
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;
    wire [31:0] imm;
    wire [3:0] aluCtrl;
    wire [1:0] selA;
    wire [1:0] selB;
    wire regWriteDec; 
    wire memReadDec;
    wire memWriteDec;
    wire [1:0] memSizeDec;
    wire branch;
    wire jal;
    wire jalr;
    wire lui;
    wire aupc;
    reg [31:0] pc_val_dec;
    reg newVect_dec;
    //regfile AB read, A write wires
    wire [4:0] readAddrA;
    wire [4:0] readAddrB;
    wire [31:0] doutA; 
    wire [31:0] doutB; 
  
    //wire [4:0] writeAddrA;
    //wire [31:0] dinA;
    wire [31:0] _a, _b;
//////////////////////////////////////////////////////////////////////////////////
    wire P4 = 1'dz;
    //execute output wires
    wire wenA;
    wire [4:0] rdOut;
    wire [31:0] aluVal;
    wire [31:0] rs2Val;
    wire modPc;
    wire [31:0] pcVect;
    reg memReadExec, memWriteExec;
    reg [1:0] memSizeExec;
//////////////////////////////////////////////////////////////////////////////////    
    wire P5 = 1'dz;
    //stoeLoad outoputs
    wire memReadValid;
    //regfile B write wires
    wire wenB;
    wire [4:0] writeAddrB;
    wire [31:0] dinB;
//////////////////////////////////////////////////////////////////////////////////   
    

    reg_file regfile (
        //inputs
        .clk(clk),
        .read_addr_A(readAddrA),
        .read_addr_B(readAddrB),
        .wen_A(wenA),
        .write_addr_A(rdOut),
        .din_A(aluVal),
        .wen_B(wenB),
        .write_addr_B(writeAddrB),
        .din_B(dinB),
        .read_addr_C(IO_addr),
        //outputs
        .dout_A(doutA),
        .dout_B(doutB),
        .dout_C(IO_out)
    );
    instr_writer writer(
        .clk(clk),
        .instr_write_en(instr_write_en),
        .addr(dma_instr_addr),
        .data(dma_instr_data)
    );
     fetch_top fetch(
        //inputs
        .clk(clk),
        .branch_vect(pcVect),
        .branch_en(modPc),
        .dma_instr_write_en(instr_write_en),
        .dma_instr_addr(dma_instr_addr),
        .dma_instr_write_data(dma_instr_data),
        //outputs
        .instruction(instruction),
        .instr_valid(instr_valid),
        .pc_val(pc_val_fetch),
        .newVect(newVect_fetch)
    );
    dec_top decode(
         //inputs
         .clk(clk),
         .instruction(instruction),
         .en(1'b1),
         //outputs
         .rs1(rs1),
         .rs2(rs2),
         .rd(rd),
         .imm(imm),
         .alu_ctrl(aluCtrl),
         .alu_sel_A(selA),
         .alu_sel_B(selB),
         .reg_write(regWriteDec),
         .mem_read(memReadDec),
         .mem_write(memWriteDec),
         .mem_size(memSizeDec),
         .branch(branch),
         .jal(jal),
         .jalr(jalr),
         .lui(lui),
         .aupc(aupc)
         //.debug()
    );
    always @(posedge clk) begin
        pc_val_dec <= pc_val_fetch;
        newVect_dec <= newVect_fetch;
    end
    exec_top execute(
        .clk(clk),
        .en(1'b1),
        .newVect(newVect_dec),
        .readAddrA(readAddrA),
        .readAddrB(readAddrB),
        .doutA(doutA),
        .doutB(doutB),
//        .wenA(wenA),
//        .writeAddrA(writeAddrA),
//        .dinA(dinA),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .imm(imm),
        .aluCtrl(aluCtrl),
        .selA(selA),
        .selB(selB),
        .regWrite(regWriteDec),
        .jal(jal),
        .jalr(jalr),
        .pc(pc_val_dec),
        .wenA(wenA),
        .rdOut(rdOut),
        .aluVal(aluVal),
        .rs2ValOut(rs2Val),
        .modPc(modPc),
        .pcVect(pcVect),
        .a(_a),
        .b(_b)
    );
    always @(posedge clk) begin
        memReadExec <= memReadDec;
        memWriteExec <= memWriteDec;
        memSizeExec <= memSizeDec;
    end
    store_load_top storeload(
        //inputs
        .clk(clk),
        .en(1'b1),
        .mem_read(memReadExec),
        .mem_write(memWriteExec),
        .mem_size(memSizeExec),
        .rd(rdOut),
        .alu_val(aluVal),
        .rs2_val(rs2Val),
        .reg_writeB_en(wenB),
        .rdB(writeAddrB),
        .dinB(dinB),
        .mem_read_valid(memReadValid)
    );
     always begin
         #20 clk <= ~clk;
     end
endmodule
