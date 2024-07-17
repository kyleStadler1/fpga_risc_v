// top main module

module top(
    input clk, 
    output [4:0] decode_rs1,
    output [4:0] decode_rs2, 
    output [4:0] decode_rd,
    output [19:0] decode_imm,
    output [3:0] decode_alu_ctrl,
    output decode_alu_src,
    output decode_reg_write,
    output decode_mem_read,
    output decode_mem_write,
    output [3:0] decode_mem_size,
    output decode_branch,
    output decode_jump,
    output decode_jump_reg,
    output decode_lui,
    output decode_aupc


    );

    //PC inputs
    //clk
    wire pc_en;
    wire pc_rst;
    wire [31:0] alu_out_to_pc;
    wire pc_sel;
    //PC outputs
    wire [31:0] pc_instr_addr;
    //PC Instantiation
    prog_ctr pc(clk, pc_en, pc_rst, alu_out_to_pc, pc_sel, pc_instr_addr);

    //IMEM inputs
    //clk
    wire [3:0] imem_wen;
    //wire [13:0] imem_addr;
    wire [31:0] imem_din;
    //IMEM outputs
    wire [31:0] imem_dout;
    wire imem_read_valid;
    //IMEM Instantiation
    instr_blk_mem_top imem(clk, imem_wen, pc_instr_addr, imem_din, imem_dout, imem_read_valid);

    //DECODE inputs
    //clk
    //wire [31:0] decode_instr;

    //DECODE outputs
    // wire [4:0] decode_rs1;
    // wire [4:0] decode_rs2; 
    // wire [4:0] decode_rd;
    // wire [19:0] decode_imm;
    // wire [3:0] decode_alu_ctrl;
    // wire decode_alu_src;
    // wire decode_reg_write;
    // wire decode_mem_read;
    // wire decode_mem_write;
    // wire [3:0] decode_mem_size;
    // wire decode_branch;
    // wire decode_jump;
    // wire decode_jump_reg;
    // wire decode_lui;
    // wire decode_aupc;
    //DECODE Instantiation
    decode decode(
        clk, 
        imem_dout, 
        decode_rs1, 
        decode_rs2, 
        decode_rd, 
        decode_imm, 
        decode_alu_ctrl, 
        decode_alu_src,
        decode_reg_write,
        decode_mem_read,
        decode_mem_write,
        decode_mem_size,
        decode_branch,
        decode_jump,
        decode_jump_reg,
        decode_lui,
        decode_aupc
    );   
        
endmodule