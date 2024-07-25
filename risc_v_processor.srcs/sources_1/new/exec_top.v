`timescale 1ns / 1ps
module exec_top (
    input clk,
    input en,
    input [4:0] rs1_in, 
    input [4:0] rs2_in, 
    output [4:0] dra_addrA, //direct regfile read access for alu mux
    output [4:0] dra_addrB, //direct regfile read access for alu mux
    input [31:0] dra_doutA, //direct regfile read access for alu mux
    input [31:0] dra_doutB, //direct regfile read access for alu mux
    input [4:0] rd_in,
    input [19:0] imm,
    input [3:0] alu_ctrl,
    input [1:0] alu_sel_A,
    input [1:0] alu_sel_B,
    input reg_write_in, 
    input mem_read_in,
    input mem_write_in,
    input [1:0] mem_size_in,
    input branch,
    input jal,
    input jalr,
    input lui,
    input aupc,
    input [31:0] pc_val,
    output reg mod_pc,
    output reg mem_read,
    output reg mem_write,
    output reg [1:0] mem_size,
    output reg_write_toRF,
    output [4:0] rd_toRF,
    output [31:0] alu_val_toRF,
    output reg [4:0] rd,
    output reg [31:0] alu_val,
    output reg [31:0] rs2_val
);
    wire [4:0] rs2_latched;
    wire [19:0] imm_latched;
    wire [4:0] rs1_latched;
    wire [31:0] pc_val_latched;
    wire [31:0] alu_val_latched;
    wire [1:0] selA_latched;
    wire [1:0] selB_latched;
    wire [3:0] alu_ctrl_latched;
    wire [31:0] alu_out;
    wire jal_mop;
    wire jalr_mop;
    wire auipc_mop;
    wire mop_in;
    wire [3:0] alu_ctrl_mop;
    wire [1:0] selA_mop;
    wire [1:0] selB_mop;
    wire reg_write_mop;
    wire mod_pc_mop;
    wire multiop_mop;
    wire mem_read_latched;
    wire [1:0] mem_size_latched;
    wire reg_write_latched;
    wire [4:0] rd_latched;
    decode_to_execute_reg_wall dtoex (
        .clk(clk),
        .en(1'b1),
        .rs1_dec(rs1_in),
        .rs2_dec(rs2_in),
        .rd_dec(rd_in),
        .imm_dec(imm),
        .alu_ctrl_dec(alu_ctrl),
        .alu_selA_dec(alu_sel_A),
        .alu_selB_dec(alu_sel_B),
        .reg_write_dec(reg_write_in),
        .mem_read_dec(mem_read_in),
        .mem_write_dec(mem_write_in),
        .mem_size_dec(mem_size_in),
        .pot_branch_dec(branch),
        .jump_dec(jal),
        .jump_reg_dec(jalr),
        .lui_dec(lui),
        .aupc_dec(aupc),
        .pc_val_in(pc_val),
        //mop control inputs below
        .alu_ctrl_in_mop(alu_ctrl_mop),
        .alu_selA_mop(selA_mop),
        .alu_selB_mop(selB_mop),
            //.reg_write_in_mop(reg_write_mop),
        .mod_pc_mop(mod_pc_mop),
        .multiop_mop(multiop_mop),
        //alu
        .alu_out_in(alu_out),
        //outputs
        .rs1(rs1_latched),
        .rs2(rs2_latched), 
        .rd(rd_latched), 
        .imm(imm_latched), 
        .alu_ctrl(alu_ctrl_latched),
        .alu_selA(selA_latched),
        .alu_selB(selB_latched),
        .reg_write(reg_write_latched),
        .mem_read(mem_read_latched), 
        .mem_write(mem_write_latched), 
        .mem_size(mem_size_latched), 
        .branch_pot(), //dont need?
        .jump(jal_mop),
        .jump_reg(jalr_mop),
        .lui(), //dont need?
        .aupc(auipc_mop),
        .pc_val(pc_val_latched),
        .multiop(mop_in),
        .alu_out(alu_val_latched)
    );
    wire [31:0] out_A;
    wire [31:0] out_B;
    alu_control_unit acu(
        .rs2(rs2_latched),
        .imm(imm_latched),
        .rs1(rs1_latched),
        .dra_addrA(dra_addrA),
        .dra_addrB(dra_addrB),
        .dra_doutA(dra_doutA),
        .dra_doutB(dra_doutB),
        .pc_val(pc_val_latched),
        .alu_val(alu_val_latched),
        .selA(selA_latched),
        .selB(selB_latched),
        .out_A(out_A),
        .out_B(out_B)
    );
    wire branch_conf;
    alu alu(
        .alu_ctrl(alu_ctrl_latched),
        .A(out_A),
        .B(out_B),
        .alu_out(alu_out),
        .branch(branch_conf)
    );
    multiop_controller mop(
        .alu_branch(branch_conf),
        .jump_in(jal_mop),
        .auipc_in(auipc_mop),
        .multiop_in(mop_in),
        .alu_ctrl_out(alu_ctrl_mop),
        .alu_selA(selA_mop),
        .alu_selB(selB_mop),
        .reg_write_out(reg_write_mop),
        .mod_pc(mod_pc_mop),
        .multiop_out(multiop_mop)
    );
    always @(posedge clk) begin
        if (en) begin
            mod_pc <= mod_pc_mop;
            mem_read <= mem_read_latched;
            mem_write <= mem_read_latched;
            mem_size <= mem_size_latched;
            rd <= rd_latched;
            alu_val <= alu_out;
            rs2_val <= dra_doutB;
        end
    end
    assign reg_write_toRF = multiop_mop ? reg_write_mop : reg_write_latched;
    assign rd_toRF = rd_latched;
    assign alu_val_toRF = alu_out;
endmodule