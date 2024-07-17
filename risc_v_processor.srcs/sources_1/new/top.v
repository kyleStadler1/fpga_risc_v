// top main module

module top(
    input clk, 
    input en,
    output [31:0] rs1_val,
    output [31:0] rs2_val,
    output [4:0] rd,
    output [19:0] imm,
    output [3:0] alu_ctrl,
    output alu_src,
    output reg_write,
    output mem_read,
    output mem_write,
    output [1:0] mem_size,
    output branch,
    output jump,
    output jump_reg,
    output lui,
    output aupc,
    output [31:0] pc_decode_to_exec_piped


    );

    //PC inputs
    //clk
    wire en;
    wire pc_rst;
    wire [31:0] alu_out_to_pc;
    wire pc_sel;
    //PC outputs
    wire [31:0] pc_instr_addr;
    //PC Instantiation
    prog_ctr pc(clk, en, pc_rst, alu_out_to_pc, pc_sel, pc_instr_addr);

    //IMEM inputs
    //clk
    wire [3:0] imem_wen = 4'b0000;
    //wire [13:0] imem_addr;
    wire [31:0] imem_din = 32'b0;
    //IMEM outputs
    wire [31:0] imem_dout;
    wire imem_read_valid;
    //IMEM Instantiation
    instr_blk_mem_top imem(clk, imem_wen, pc_instr_addr, imem_din, imem_dout, imem_read_valid);
    
    wire [31:0] pc_instr_addr_decodePipe;
    fetch_to_decode_reg_wall f_to_dec (clk, en, pc_instr_addr, pc_instr_addr_decodePipe);

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
    wire [31:0] rs1_val;
    wire [31:0] rs2_val;
    reg_file reg_file_inst (
        .clk(clk),
        .read_addr_A(decode_rs1),
        .read_addr_B(decode_rs2),
        .wen_A(decode_reg_write),
        .write_addr_A(decode_rd),
        .din_A(imem_dout),
        .wen_B(1'b0),            // Assuming write enable B is not used
        .write_addr_B(5'b0),     // Assuming write address B is not used
        .din_B(32'b0),           // Assuming data input B is not used
        .dout_A(rs1_val),        // Connecting to the output signal
        .dout_B(rs2_val)         // Connecting to the output signal
    );
    decode_to_execute_reg_wall decode_to_execute_inst (
        .clk(clk),
        .en(en),
        .rs1_val_in(rs1_val),
        .rs2_val_in(rs2_val),
        .rd_in(decode_rd),
        .imm_in(decode_imm),
        .alu_ctrl_in(decode_alu_ctrl),
        .alu_src_in(decode_alu_src),
        .reg_write_in(decode_reg_write),
        .mem_read_in(decode_mem_read),
        .mem_write_in(decode_mem_write),
        .mem_size_in(decode_mem_size),
        .branch_in(decode_branch),
        .jump_in(decode_jump),
        .jump_reg_in(decode_jump_reg),
        .lui_in(decode_lui),
        .aupc_in(decode_aupc),
        .pc_val_in(pc_instr_addr_decodePipe),
        .rs1_val(rs1_val),
        .rs2_val(rs2_val),
        .rd(rd),
        .imm(imm),
        .alu_ctrl(alu_ctrl),
        .alu_src(alu_src),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_size(mem_size),
        .branch(branch),
        .jump(jump),
        .jump_reg(jump_reg),
        .lui(lui),
        .aupc(aupc),
        .pc_val(pc_decode_to_exec_piped)
    );
        
endmodule