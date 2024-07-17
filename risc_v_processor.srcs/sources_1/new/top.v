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
        
     reg [19:0] decode_outs[0:16];
     always @(posedge clk) begin
         decode_outs[0] <= decode_rs1;
         decode_outs[2] <= decode_rs2;
         decode_outs[3] <= decode_rd;
         decode_outs[4] <= decode_imm;
         decode_outs[5] <= decode_alu_ctrl;
         decode_outs[6] <= decode_alu_src;
         decode_outs[7] <= decode_reg_write;
         decode_outs[8] <= decode_mem_read;
         decode_outs[9] <= decode_mem_write;
         decode_outs[10] <= decode_mem_size;
         decode_outs[11] <= decode_branch;
         decode_outs[12] <= decode_jump;
         decode_outs[13] <= decode_jump_reg;
         decode_outs[14] <= decode_lui;
         decode_outs[15] <= decode_aupc;
       end
     
        
endmodule