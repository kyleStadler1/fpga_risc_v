



module tb_fetch;
    reg clk;
    reg [31:0] branch_vect;
    reg branch_en;

    reg dma_instr_en;
    reg [31:0] dma_instr_addr;
    reg [31:0] dma_instr_data;

    wire [31:0] instruction;
    wire instruction_valid;
    wire [31:0] pc_val;

     fetch_top fetch(
        //inputs
        .clk(clk),
        .branch_vect(branch_vect),
        .branch_en(branch_en),
        .dma_instr_write_en(dma_instr_en),
        .dma_instr_addr(dma_instr_addr),
        .dma_instr_write_data(dma_instr_data),
        //outputs
        .instruction(instruction),
        .instr_valid(instruction_valid),
        .pc_val(pc_val)
    );


    reg [31:0] mi [0 : instruction_count-1];
    initial begin
        dma_instr_en = 1;
        mi[0] <= 32'h00600093;
        mi[1] <= 32'h00700113;
        mi[2] <= 32'h002081b3;
    end


    reg [31:0] ctr = 0;
    always @(posedge clk) begin
        ctr <= ctr + 1;
        if (ctr < 3) begin
            branch_en = 0;
            dma_instr_en = 1;
            dma_instr_addr = ctr;
            dma_instr_data = mi[ctr];
        end else if (ctr < 6)begin
            branch_en = 0;
            dma_instr_en = 0;
        end else begin
            ctr = 0;
            branch en = 1;
            branch_vect = 32'd0;
        end

    end
endmodule