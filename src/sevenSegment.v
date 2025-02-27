`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Seiba
// 
// Create Date: 25.02.2025 19:49:03
// Design Name: 
// Module Name: sevenSegment
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


module sevenSegment 
#(parameter integer n = 100_000)(
    input Clk, Rst, lose,
    input [11:0] number_win,
    output reg [7:0] seg_7_display,
    output reg [7:0] active_low_anode
);
    
  // Refresh rate = 1kHz (time dependant multiplexing)
    reg [$clog2(n)-1:0] digit_count;
    reg [2:0] digit_for_display;
    reg [3:0] disp_val;

    // Clock-based digit selection
    always @ (posedge Clk or posedge Rst) begin
        if (Rst) begin
            digit_count <= 0;
            digit_for_display <= 0;
        end
        else if (digit_count == n-1) begin
            digit_for_display <= digit_for_display + 1;
            digit_count <= 0;
        end
        else digit_count <= digit_count + 1;
    end
    
    // Determine active-low anode signals
    always @ (*) begin
        if (lose) begin
            case (digit_for_display)
                3'b000 : active_low_anode = 8'b1111_1110; // 1st digit
                3'b001 : active_low_anode = 8'b1111_1101; // 2nd digit
                3'b100 : active_low_anode = 8'b1110_1111; // L
                3'b101 : active_low_anode = 8'b1101_1111; // O
                3'b110 : active_low_anode = 8'b1011_1111; // S
                3'b111 : active_low_anode = 8'b0111_1111; // E
                default : active_low_anode = 8'b1111_1111;
            endcase
        end
        else begin
            case (digit_for_display)
                3'b000 : active_low_anode = 8'b1111_1110; // 1st digit
                3'b001 : active_low_anode = 8'b1111_1101; // 2nd digit
                default: active_low_anode = 8'b1111_1111; // Turn off other digits
            endcase
        end
    end
    
    // Select which value to display
    always @ (*) begin
        case (digit_for_display)
            3'b000 : disp_val = number_win[7:4]; // First win digit
            3'b001 : disp_val = number_win[11:8]; // Second win digit
            3'b100 : disp_val = 4'b1101; // "L"
            3'b101 : disp_val = 4'b1100; // "O"
            3'b110 : disp_val = 4'b1011; // "S"
            3'b111 : disp_val = 4'b1010; // "E"
            default: disp_val = 4'b0000;
        endcase
    end
    
    // 7-segment encoding (active low)
    always @ (*) begin
        case (disp_val)
            4'b0000 : seg_7_display = 8'b1100_0000; // 0
            4'b0001 : seg_7_display = 8'b1111_1001; // 1
            4'b0010 : seg_7_display = 8'b1010_0100; // 2
            4'b0011 : seg_7_display = 8'b1011_0000; // 3
            4'b0100 : seg_7_display = 8'b1001_1001; // 4
            4'b0101 : seg_7_display = 8'b1001_0010; // 5
            4'b0110 : seg_7_display = 8'b1000_0010; // 6
            4'b0111 : seg_7_display = 8'b1111_1000; // 7
            4'b1000 : seg_7_display = 8'b1000_0000; // 8
            4'b1001 : seg_7_display = 8'b1001_0000; // 9
            
            // Letters for "LOSE"
            4'b1010 : seg_7_display = 8'b1000_0110; // E
            4'b1011 : seg_7_display = 8'b1010_0100; // S
            4'b1100 : seg_7_display = 8'b1100_0000; // O
            4'b1101 : seg_7_display = 8'b1100_0111; // L
            default : seg_7_display = 8'b1111_1111; // Blank
        endcase
    end
    
endmodule
