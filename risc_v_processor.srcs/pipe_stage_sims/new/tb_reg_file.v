`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/15/2024 03:59:43 PM
// Design Name: 
// Module Name: tb_reg_file
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


module tb_reg_file;
    reg clk = 0;
    reg [4:0] read_addr_A;
    reg [4:0] read_addr_B;
    reg wen_A;
    reg [4:0] write_addr_A;
    reg [31:0] din_A;
    reg wen_B;
    reg [4:0] write_addr_B;
    reg [31:0] din_B;
    reg [4:0] read_addr_C;

    // Declare the outputs as wires
    wire [31:0] dout_A;
    wire [31:0] dout_B;
    wire [31:0] dout_C;

    // Instantiate the reg_file module
    reg_file uut (
        .clk(clk),
        .read_addr_A(read_addr_A),
        .read_addr_B(read_addr_B),
        .wen_A(wen_A),
        .write_addr_A(write_addr_A),
        .din_A(din_A),
        .wen_B(wen_B),
        .write_addr_B(write_addr_B),
        .din_B(din_B),
        .read_addr_C(read_addr_C),
        .dout_A(dout_A),
        .dout_B(dout_B),
        .dout_C(dout_C)
    );
    
    always begin
        #20 clk = ~clk; 
    end
    reg [31:0] ctr = 0;
    
    always @(posedge clk) begin
        ctr <= ctr + 1;
        case(ctr)
 // Initialize and write to register 1
            0: begin
                wen_A <= 1;
                write_addr_A <= 5'd1;  // Write to register 1
                din_A <= 32'hAABBCCDD;  // Write value AABBCCDD to register 1
            end

            // Read from register 1 and write to register 2 simultaneously
            1: begin
                wen_A <= 0;  // Disable write to register 1
                read_addr_A <= 5'd1;  // Read from register 1 (should forward din_A)
                
                wen_B <= 1;
                write_addr_B <= 5'd2;  // Write to register 2
                din_B <= 32'h12345678;  // Write value 12345678 to register 2
            end

            // Read from register 2 and test if forwarding works for register 2
            2: begin
                wen_B <= 0;  // Disable write to register 2
                read_addr_A <= 5'd2;  // Read from register 2 (should forward din_B)
            end

            // Test no forwarding (read value from register file)
            3: begin
                read_addr_A <= 5'd1;  // Read from register 1 (from reg_file, no forwarding)
            end

            // Add more cases if needed to test different forwarding scenarios...
            4: begin
                $finish;  // End simulation after testing
            end
        endcase
    end
    

endmodule
