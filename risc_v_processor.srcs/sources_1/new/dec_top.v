module dec_top (
    input clk, 
    input [31:0] instruction,
    input instr_valid,
    input en, 
// reg file querie - fully combinatorial
    output [4:0] rs1,
    output [4:0] rs2,
    input [31:0] rs1_val_in,
    input [31:0] rs2_val_in,
//
    output [31:0] rs1_val, 
    output [31:0] rs2_val, 
    output  [4:0] rd,
    output  [19:0] imm,
    output  [3:0] alu_ctrl,
    output  [1:0] alu_sel_A,
    output  [1:0] alu_sel_B,
    output  reg_write, 
    output  mem_read,
    output  mem_write,
    output  [1:0] mem_size,
    output  branch,
    output  jal,
    output  jalr,
    output  lui,
    output  aupc
);
    decode decode(
        .clk(clk),
        .instr(instruction),
        .en(en)

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
        ,jal(jal),
        .jalr(jalr),
        .lui(lui),
        .aupc(aupc)
    );
    assign rs1_val = rs1_val_in;
    assign rs2_val = rs2_val_in;
endmodule