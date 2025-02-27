`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.02.2025 21:29:54
// Design Name: 
// Module Name: btnSynchDebounce
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


module btnSynchDebounce(
    input wire Clk,       // Fast system clock (e.g., 100 MHz)
    input wire btn_async, // Asynchronous button input
    output reg btn_stable // Debounced button output
);
    
    reg [23:0] counter;   // Counter for debouncing
    reg btn_sync1, btn_sync2; // Synchronization flip-flops

    always @(posedge Clk) begin
        // Synchronization stage
        btn_sync1 <= btn_async;
        btn_sync2 <= btn_sync1;
    end

    always @(posedge Clk) begin
        // Debounce logic - ensure button is stable for 10 ms
        if (btn_sync2 == btn_stable) begin
            counter <= 0;  // Reset counter if button state is stable
        end 
        else begin
            counter <= counter + 1; // Increase count when button changes
            if (counter >= 24'd10_000_000) begin // 10 ms debounce at 100MHz
                btn_stable <= btn_sync2; // Update stable output
                counter <= 0; // Reset counter
            end
        end
    end

endmodule

