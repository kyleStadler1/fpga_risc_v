`timescale 1ns / 1ps



module tb_fetch;
    reg clk = 0;
    reg [31:0] branch_vect;
    reg branch_en;

    wire dma_instr_en;
    wire [31:0] dma_instr_addr;
    wire [31:0] dma_instr_data;

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
    
   instr_writer writer(
        .clk(clk),
        .instr_write_en(dma_instr_en),
        .addr(dma_instr_addr),
        .data(dma_instr_data)
    );


    always begin
        #20 clk <= clk + 1;
    end


    reg [29:0] ctr = 0;
    always @(posedge clk) begin
        ctr <= ctr + 1;
    end
    always @(*) begin
        case(ctr) 
            3 : 
            begin
                branch_en = 0;
            end
            4 : begin
                 branch_en = 0;
            end
            5 :  begin
                branch_en = 1;
                branch_vect = 32'd0;
            end
            6 : begin
                ctr <= 3;                
            end
            endcase

    end
endmodule