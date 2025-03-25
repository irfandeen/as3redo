`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.03.2025 01:03:45
// Design Name: 
// Module Name: flexible_clock
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


module flexible_clock #(
    parameter CLK_DIV = 1
)(
    input wire clk_in,
    output reg clk_out = 0
);
    reg [31:0] counter = 0;
    always @ (posedge clk_in) begin
        if (counter + 1 == CLK_DIV) begin
            counter <= 0;
            clk_out <= ~clk_out;
        end
        else begin
            counter <= counter + 1;
        end
    end
endmodule
