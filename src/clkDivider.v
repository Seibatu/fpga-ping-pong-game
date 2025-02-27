`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Seiba 
// 
// Create Date: 25.02.2025 19:53:45
// Design Name: 
// Module Name: clkDivider
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

module clkDivider 
#(parameter integer N = 50_000_000)(
    input Clk, Rst,
    output reg slw_clk
);

// Counter to generate slow clock
reg [$clog2(N/2)-1:0] cnt_tmp;

always @ (posedge Clk or posedge Rst) begin
    if (Rst) begin
        cnt_tmp <= 0;
        slw_clk <= 0;
    end
    else if (cnt_tmp == (N/2)-1) begin
        slw_clk <= ~slw_clk;
        cnt_tmp <= 0;
    end
    else cnt_tmp <= cnt_tmp + 1;
end

endmodule
