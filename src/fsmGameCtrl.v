`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Seiba
// 
// Create Date: 25.02.2025 19:54:45
// Design Name: 
// Module Name: fsmGameCtrl
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

module fsmGameCtrl(
    input slw_clk, Rst,
    input Begin_btn, Play_btn, Reset,
    output reg [3:0] win_counter,
    output reg lose,
    output reg [3:0] LEDs,
    output reg [2:0] Coloured_leds
);
    
    // FSM State and Registers
    reg [2:0] next_state, state;
    reg clk_count;

    // State Encoding
    localparam  INITIAL_st        = 3'b000,
                BEGIN_1st_cycle_st = 3'b001,
                BEGIN_2nd_cycle_st = 3'b010,
                PLAYERWIN_st      = 3'b011,
                CPWIN_st          = 3'b100;

    // State Register
    always @ (posedge slw_clk or posedge Rst) begin
        if (Rst)
            state <= INITIAL_st;
        else
            state <= next_state;
    end

    // FSM Logic
    always @ (posedge slw_clk or posedge Rst) begin
        if (Rst) begin
            Coloured_leds <= 3'b000;
            win_counter <= 4'b0000;
            lose <= 1'b0;
            LEDs <= 4'b0000;
            clk_count <= 1'b0;
            next_state <= INITIAL_st;
        end
        else begin
            case (state)
                // Initial state when the game waits for the begin signal
                INITIAL_st : begin
                    Coloured_leds <= 3'b000;
                    win_counter <= 4'b0000;
                    lose <= 1'b0;
                    LEDs <= 4'b1000; // Start with the first LED on

                    if (Begin_btn) 
                        next_state <= BEGIN_1st_cycle_st;
                    else 
                        next_state <= INITIAL_st;
                end

                // First cycle: LEDs shift right
                BEGIN_1st_cycle_st : begin  
                    LEDs <= LEDs >> 1; // 1000 -> 0100 -> 0010 -> 0001

                    if (LEDs[0] == 1)
                        next_state <= BEGIN_2nd_cycle_st;
                    else if (Reset)
                        next_state <= INITIAL_st;
                end

                // Second cycle: LEDs shift left
                BEGIN_2nd_cycle_st : begin  
                    LEDs <= LEDs << 1; // 0001 -> 0010 -> 0100 -> 1000

                    if (LEDs[3] == 1 && Play_btn) begin
                        next_state <= BEGIN_1st_cycle_st; // Bounce back
                        win_counter <= win_counter + 1; // Increment success count
                    end 
                    else if (LEDs[3] && !Play_btn)
                        next_state <= CPWIN_st; // Computer wins
                    else if (Reset)
                        next_state <= INITIAL_st;

                    if(win_counter == 10) // Player wins after 10 successful hits
                        next_state <= PLAYERWIN_st;
                end

                // Player wins
                PLAYERWIN_st : begin 
                    if (clk_count) begin
                        Coloured_leds <= 3'b111; // Flash LEDs
                    end 
                    else begin
                        Coloured_leds <= 3'b000;
                    end

                    clk_count <= ~clk_count; // Toggle clock counter

                    if(Reset)
                       next_state <= INITIAL_st;
                end

                // Computer wins
                CPWIN_st : begin 
                    lose <= 1'b1;

                    if (clk_count) begin
                        LEDs <= 4'b1111; // Flash LEDs
                    end 
                    else begin
                        LEDs <= 4'b0000;
                    end

                    clk_count <= ~clk_count; // Toggle clock counter

                    if(Reset)
                        next_state <= INITIAL_st;
                end            

                default : next_state <= INITIAL_st;           
            endcase
        end
    end
    
endmodule
