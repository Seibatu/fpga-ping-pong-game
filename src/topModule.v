`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Seiba 
// 
// Create Date: 25.02.2025 19:32:56
// Design Name: 
// Module Name: topModule
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

module topModule (
    input Clk, Rst,            // System clock (100MHz) and Reset
    input Begin_btn, Play_btn, Reset,  // Button Inputs
    output [3:0] LEDs,         // Game LEDs
    output [2:0] Coloured_leds,// Colored LEDs
    output [7:0] seg_7_display,// 7-Segment Display
    output [7:0] active_low_anode // Active-Low Anode Control
);

    // Internal Signals
    wire slw_clk_2Hz;    // 2Hz slow clock for FSM
    wire btn_debounced, play_debounced, reset_debounced; // Debounced button signals
    wire btn_synced_to_fsm, play_synced_to_fsm, reset_synced_to_fsm; // Synced button signals
    wire [3:0] win_counter;
    wire [11:0] number_win;
    wire lose;

    // Instantiate Clock Divider (100MHz → 2Hz)
    clkDivider #(.N(50_000_000)) clk_div (
        .Clk(Clk),
        .Rst(Rst),
        .slw_clk(slw_clk_2Hz)
    );

    // Debounce and Sync Buttons
    btnSynchDebounce debounce_begin (
        .Clk(Clk),
        .btn_async(Begin_btn),
        .btn_stable(btn_debounced)
    );
    
    btnSynchDebounce debounce_play (
        .Clk(Clk),
        .btn_async(Play_btn),
        .btn_stable(play_debounced)
    );
    
    btnSynchDebounce debounce_reset (
        .Clk(Clk),
        .btn_async(Reset),
        .btn_stable(reset_debounced)
    );

    // Synchronize Debounced Signals to 2Hz Clock
    btn2HzSynch sync_begin (
        .slw_clk(slw_clk_2Hz),
        .btn_stable(btn_debounced),
        .btn_pulse(btn_synced_to_fsm)
    );

    btn2HzSynch sync_play (
        .slw_clk(slw_clk_2Hz),
        .btn_stable(play_debounced),
        .btn_pulse(play_synced_to_fsm)
    );

    btn2HzSynch sync_reset (
        .slw_clk(slw_clk_2Hz),
        .btn_stable(reset_debounced),
        .btn_pulse(reset_synced_to_fsm)
    );

    // Instantiate FSM Game Logic
    fsmGameCtrl fsm (
        .slw_clk(slw_clk_2Hz),
        .Rst(Rst),
        .Begin_btn(btn_synced_to_fsm),
        .Play_btn(play_synced_to_fsm),
        .Reset(reset_synced_to_fsm),
        .LEDs(LEDs),
        .Coloured_leds(Coloured_leds),
        .win_counter(win_counter),
        .lose(lose)
    );

    // Convert Binary to BCD
    binaryBCD bin_to_bcd (
        .win_counter(win_counter),
        .number_win(number_win)
    );

    // Display on 7-Segment Display
    sevenSegment #(.n(100_000)) seg_display (
        .Clk(Clk),
        .Rst(Rst),
        .lose(lose),
        .number_win(number_win),
        .seg_7_display(seg_7_display),
        .active_low_anode(active_low_anode)
    );

endmodule

