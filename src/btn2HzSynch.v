`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.02.2025 21:54:51
// Design Name: 
// Module Name: btn2HzSynch
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


module btn2HzSynch(
    input wire slw_clk,  // 2Hz clock used in FSM
    input wire btn_stable, // Debounced button signal from fast clock
    output reg btn_pulse  // Pulse in sync with slow clock
);
    
    reg btn_last;

    always @(posedge slw_clk) begin
        btn_pulse <= btn_stable & ~btn_last; // Detect rising edge
        btn_last <= btn_stable;
    end

endmodule

