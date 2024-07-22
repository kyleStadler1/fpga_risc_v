`timescale 1ns / 1ps



module tb_fetch;
    reg clk = 0;
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


    reg [31:0] mi [0 : 2];
    initial begin
        dma_instr_en = 1;
        mi[0] <= 32'h00600093;
        mi[1] <= 32'h00700113;
        mi[2] <= 32'h002081b3;
    end
    always begin
        #20 clk <= clk + 1;
    end


    reg [29:0] ctr = 0;
    always @(posedge clk) begin
        ctr <= ctr + 1;
    end
    always @(*) begin
        case(ctr) 
            0 : begin
                dma_instr_en = 1;
                dma_instr_addr = 32'd0;
                dma_instr_data = mi[0];
                branch_en = 0;
            end
            1 : begin
                dma_instr_en = 1;
                dma_instr_addr = 32'd4;
                dma_instr_data = mi[1];
                 branch_en = 0;
            end
            2 : begin
                dma_instr_en = 1;
                dma_instr_addr = 32'd8;
                dma_instr_data = mi[2];
                 branch_en = 0;
            end
            3 : 
            begin
                dma_instr_en = 0;
                dma_instr_addr = 32'dx;
                dma_instr_data = 32'dx;
                branch_en = 0;
            end
            4 : begin
                dma_instr_en = 0;
                dma_instr_addr = 32'dx;
                dma_instr_data = 32'dx;
                 branch_en = 0;
            end
            5 :  begin
                dma_instr_en = 0;
                dma_instr_addr = 32'dx;
                dma_instr_data = 32'dx;
                branch_en = 1;
                branch_vect = 32'd0;
                //ctr <= 3;
            end
            6 : begin
                ctr <= 3;                
            end
            endcase

    end
endmodule