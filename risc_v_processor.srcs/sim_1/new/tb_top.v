`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/16/2024 02:19:10 AM
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
    reg clk;
    
    //PC inputs
    //clk
    reg pc_en;
    wire pc_rst = 0;
    wire [31:0] alu_out_to_pc;
    wire pc_sel = 0;
    //PC outputs
    wire [31:0] pc_instr_addr;
   //PC Instantiation
   prog_ctr pc(clk, pc_en, pc_rst, alu_out_to_pc, pc_sel, pc_instr_addr);
   

   wire [31:0] instr_input_addr;
   //IMEM inputs
   //clk
    reg [3:0] imem_wen;
    reg [13:0] imem_addr;
    assign imem_addr = imem_wen ? instr_addr : pc_instr_addr;
    reg [31:0] imem_din;
    //IMEM outputs
    wire [31:0] imem_dout;
    wire imem_read_valid;
    //IMEM Instantiation
    instr_blk_mem_top imem(clk, imem_wen, imem_addr, imem_din, imem_dout, imem_read_valid);
    
    //DECODE inputs
    //clk
    //wire [31:0] decode_instr;
    
    //DECODE outputs
    wire [4:0] decode_rs1;
    wire [4:0] decode_rs2; 
    wire [4:0] decode_rd;
    wire [19:0] decode_imm;
    wire [3:0] decode_alu_ctrl;
    wire decode_alu_src;
    wire decode_reg_write;
    wire decode_mem_read;
    wire decode_mem_write;
    wire [3:0] decode_mem_size;
    wire decode_branch;
    wire decode_jump;
    wire decode_jump_reg;
    wire decode_lui;
    wire decode_aupc;
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
        reg[31:0] ctr;
        reg [31:0] instrs [0:10];
        initial begin
            clk <= 0;
            ctr <= 0;
            pc_en <= 0;
            instrs[0] <= 32'h00000297; // auipc t0, 0x0
            instrs[1] <= 32'h00028067; // addi t0, t0, offset for value1
            instrs[2] <= 32'h0002a003; // lw t1, 0(t0)
            instrs[3] <= 32'h00000297; // auipc t0, 0x0
            instrs[4] <= 32'h00028067; // addi t0, t0, offset for value2
            instrs[5] <= 32'h0002a403; // lw t2, 0(t0)
            instrs[6] <= 32'h006302b3; // add t3, t1, t2
            instrs[7] <= 32'h00000297; // auipc t0, 0x0
            instrs[8] <= 32'h00028067; // addi t0, t0, offset for result
            instrs[9] <= 32'h0002a023; // sw t3, 0(t0)
            instrs[10] <= 32'h00000073; // ecall
        end
        
        always begin
            #10clk <= ~clk;
        end

        always @(posedge clk) begin
            ctr <= ctr + 1;
            if (ctr <= 10) begin
                imem_wen = 4'b1111;
                instr_addr = ctr;
                imem_din = instrs[ctr];
            end else begin
                pc_instr_addr = pc_instr[31:2]; 
                if (ctr == 11) begin
                    imem_wen = 4'b0000;
                    pc_en <= 1;
                end
                
            end
        end
        
endmodule
