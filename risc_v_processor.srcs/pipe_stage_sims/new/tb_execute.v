`timescale 1ns / 1ps

module tb_execute;
    reg clk = 0;
    reg [31:0] instruction;
    reg en = 1;
    reg [31:0] doutA = 32'd4;
    reg [31:0] doutB = 32'd5;
    reg [31:0] pc = 0;


    // Wires to connect dec_top and exec_top
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;
    wire [31:0] imm;
    wire [3:0] alu_ctrl;
    wire [1:0] alu_sel_A;
    wire [1:0] alu_sel_B;
    wire reg_write;
    wire mem_read;
    wire mem_write;
    wire [1:0] mem_size;
    wire branch;
    wire jal;
    wire jalr;
    wire lui;
    wire aupc;
    wire [6:0] debug;

    wire [4:0] readAddrA;
    wire [4:0] readAddrB;
    wire wenA;
    wire [4:0] writeAddrA;
    wire [31:0] dinA;
    wire p = 1'bz;
    wire [4:0] rdOut;
    wire [31:0] aluVal;
    wire [31:0] rs2ValOut;
    wire modPc;
    wire [31:0] pcVect;
    dec_top decoder (
        .clk(clk),
        .instruction(instruction),
        .en(en),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .imm(imm),
        .alu_ctrl(alu_ctrl),
        .alu_sel_A(alu_sel_A),
        .alu_sel_B(alu_sel_B),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_size(mem_size),
        .branch(branch),
        .jal(jal),
        .jalr(jalr),
        .lui(lui),
        .aupc(aupc),
        .debug(debug)
    );
    // Instantiate exec_top
    exec_top executor (
        .clk(clk),
        .en(en),
        .readAddrA(readAddrA),
        .readAddrB(readAddrB),
        .doutA(doutA),
        .doutB(doutB),
        .wenA(wenA),
        .writeAddrA(writeAddrA),
        .dinA(dinA),
        .rs1(rs1),              // Connected from dec_top
        .rs2(rs2),              // Connected from dec_top
        .rd(rd),                // Connected from dec_top
        .imm(imm),              // Connected from dec_top
        .aluCtrl(alu_ctrl),     // Connected from dec_top
        .selA(alu_sel_A),       // Connected from dec_top
        .selB(alu_sel_B),       // Connected from dec_top
        .regWrite(reg_write),   // Connected from dec_top
        .jal(jal),              // Connected from dec_top
        .jalr(jalr),            // Connected from dec_top
        .pc(pc),
        .rdOut(rdOut),
        .aluVal(aluVal),
        .rs2ValOut(rs2ValOut),
        .modPc(modPc),
        .pcVect(pcVect)
    );
     always begin
         #20 clk <= ~clk;
     end
     
    always @(posedge clk) begin
        pc <= pc + 4;
        case(pc)
            0   : instruction = 32'h00a00093; // addi x1, x0, 10
            4   : instruction = 32'h00b00113; // addi x2, x0, 11
            8   : instruction = 32'h00c00193; // addi x3, x0, 12
            12  : instruction = 32'h00d00213; // addi x4, x0, 13
            16  : instruction = 32'h00100023; // sb x1, 0(x0)
            20  : instruction = 32'h002000a3; // sb x2, 1(x0)
            24  : instruction = 32'h00300123; // sb x3, 2(x0)
            28  : instruction = 32'h004001a3; // sb x4, 3(x0)
            32  : instruction = 32'h00002283; // lw x5, 0(x0)
            36  : instruction = 32'h00001283; // lh x5, 0(x0)
            40  : instruction = 32'h00201283; // lh x5, 2(x0)
            44  : instruction = 32'h00000283; // lb x5, 0(x0)
            48  : instruction = 32'h00100283; // lb x5, 1(x0)
            52  : instruction = 32'h00200283; // lb x5, 2(x0)
            56  : instruction = 32'h00300283; // lb x5, 3(x0)
            default: instruction = 32'h00000000; // NOP or default instruction
        endcase
    end

     
endmodule