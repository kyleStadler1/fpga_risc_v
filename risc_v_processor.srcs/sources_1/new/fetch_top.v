module fetch_top(
    input clk,
    input en,
    input [31:0] branch_vect,
    input branch_en,
    
    input dma_instr_write_en,
    input [31:0] dma_instr_write_data,
    input [31:0] dma_instr_addr,
    
    output [31:0] instruction,
    output instr_valid,
    output [31:0] pc_val
);
    wire [31:0] _pc_val;
    reg [31:0] pc_val_p0;
    reg [31:0] pc_val_p1;
    prog_ctr(
        .clk(clk),
        .en(en),
        .rst(1'b0),
        .branch_vect(branch_vect),
        .sel(branch_en),
        .pc_val(_pc_val)
    );
    instr_blk_mem_top instr_mem(
        .clk(clk),
        .addr(_pc_val),
        .dma_instr_write_en(dma_instr_write_en),
        .dma_instr_write(dma_instr_write_data),
        .dma_instr_addr(dma_instr_addr),
        .dout(instruction),
        .read_valid(instr_valid)
    );

    fetch_to_decode_reg_wall(
        .clk(clk),
        .en(en),
        .pc_val_in(_pc_val),
        .pc_val(pc_val)
    );

    
    // always @(posedge clk) begin
    //     pc_val_p0 <= _pc_val;
    //     pc_val_p1 <= pc_val_p0;
    // end
    // assign pc_val = pc_val_p1;
endmodule