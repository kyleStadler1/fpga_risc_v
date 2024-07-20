

module mem_to_wb_reg_wall (
    input clk,
    input en,
    input mem_read_in,
    input [4:0] rd_in,
    output reg [4:0] rd,
    output mem_read
);
reg [4:0] rd_inter;
reg mem_read_inter;
always @(posedge clk) begin
    if (en) begin
        rd_inter <= rd_in;
        rd <= rd_inter;

        mem_read_inter <= mem_read_in;
        mem_read <= mem_read_inter;
    end
end
endmodule