`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Seiba 
// 
// Create Date: 25.02.2025 19:52:45
// Design Name: 
// Module Name: binaryBCD
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

module binaryBCD(
    input [3:0] win_counter,
    output reg [11:0] number_win
);

    integer i;

    always @ (*) begin
        // Initialize number_win to zero
        number_win = 12'b0;
        number_win[3:0] = win_counter;  // Load binary value into least significant nibble

        // Perform Double Dabble algorithm (shift binary into BCD)
        for(i = 0; i < 4; i = i + 1) begin
            // Adjust BCD digits if >= 5 before shifting
            if (number_win[7:4] >= 5)
                number_win[7:4] = number_win[7:4] + 3;
            if (number_win[11:8] >= 5)
                number_win[11:8] = number_win[11:8] + 3;

            // Shift left by 1 bit
            number_win = number_win << 1;
        end
    end 

endmodule
