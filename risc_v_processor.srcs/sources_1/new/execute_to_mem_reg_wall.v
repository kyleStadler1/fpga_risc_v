

module execute_to_wb_reg_wall (
    input clk, 
    input en,
    //input reg_write_in,
    input mod_pc_in,
    input mem_read_in,
    input mem_write_in,
    input [1:0] mem_size_in,
    input [4:0] rd_in,
    input [31:0] alu_val_in,
    input [31:0] rs2_val_in,

    //output reg reg_write,
    output reg mod_pc,
    output reg mem_read,
    output reg mem_write,
    output reg [1:0] mem_size,
    output reg [4:0] rd,
    output reg [31:0] alu_val,
    output reg [31:0] rs2_val
);
always @(posedge clk) begin
    if (en) begin
        //reg_write <= reg_write_in;
        mod_pc <= mod_pc_in;
        mem_read <= mem_read_in;
        mem_write <= mem_write_in;
        mem_size <= mem_size_in;
        rd <= rd_in;
        alu_val <= alu_val_in;
        rs2_val <= rs2_val_in;
    end
end


endmodule