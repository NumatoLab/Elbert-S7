`timescale 1ns / 1ps

// Audio CS4344/CS4345 Module for Continuous Tone Generation
// Numato Lab base code with I2S implementation for continuous audio
// License : CC BY-SA (http://creativecommons.org/licenses/by-sa/2.0/)

module AudioCS4344ExpansionModule (
    input Clk,      // Assuming a stable input clock (e.g., 100MHz)
                    // This will be used as MCLK for the DAC.
                    // Adjust parameters if a different MCLK is required.

    // Outputs to CS4344/CS4345
    output reg SDIN,    // Serial Data Input
    output reg SCLK,    // Serial Bit Clock (BCLK)
    output reg LRCK,    // Left/Right Clock (Word Clock/Frame Sync)
    output MCLK         // Master Clock
);

// MCLK is directly connected to the input clock
assign MCLK = Clk;

// --- I2S Protocol Parameters ---
// These parameters are crucial and should be verified against the CS4345 datasheet.
// Common values for 48kHz sample rate with 24-bit data:
// MCLK = 256 * Fs (Fs = Sample Rate) or 512 * Fs
// BCLK = 64 * Fs (for stereo 24-bit, 32 clocks per channel)

// Assuming Clk (MCLK) is 100MHz for calculations.
// If your Clk is different, adjust MCLK_CYCLES_PER_BCLK accordingly.

// Target Audio Sample Rate (LRCK frequency)
parameter SAMPLE_RATE_HZ = 48000; // Hz (e.g., 44.1kHz, 48kHz)

// Calculate MCLK cycles needed for one BCLK period
// BCLK_FREQ = 64 * SAMPLE_RATE_HZ; // Standard for 24-bit stereo I2S
// MCLK_CYCLES_PER_BCLK = Clk_Freq / BCLK_FREQ;
// If Clk = 100MHz, BCLK_FREQ = 64 * 48000 = 3,072,000 Hz
// MCLK_CYCLES_PER_BCLK = 100_000_000 / 3_072_000 = ~32.55 (not an integer, problematic for simple division)

// *** Important Adjustment for 100MHz Clock ***
// Since 100MHz doesn't divide cleanly for common audio rates directly,
// we have a few options:
// 1. Use a PLL/MMCM on the FPGA to generate an exact MCLK (e.g., 12.288MHz for 48kHz sample rate)
// 2. Choose parameters that allow integer division with 100MHz.
//    Let's try to target a sample rate that *does* divide cleanly.
//    If MCLK_CYCLES_PER_BCLK = 32 (a common value for 3.125 MHz BCLK from 100MHz MCLK)
//    Then BCLK_FREQ = 100MHz / 32 = 3.125 MHz
//    And SAMPLE_RATE_HZ = BCLK_FREQ / 64 = 3.125MHz / 64 = 48828.125 Hz (close to 48kHz)
//    Let's use these values for this example to get integer divisions.

parameter MCLK_CYCLES_PER_BCLK = 32; // Number of MCLK cycles for one BCLK period
parameter BCLK_CYCLES_PER_LRCK = 64; // Number of BCLK cycles for one LRCK period (2 channels * 32 bits/channel)

// Recalculate derived frequencies based on chosen parameters and 100MHz Clk
localparam ACTUAL_BCLK_FREQ_HZ = 100_000_000 / MCLK_CYCLES_PER_BCLK; // 3,125,000 Hz
localparam ACTUAL_SAMPLE_RATE_HZ = ACTUAL_BCLK_FREQ_HZ / BCLK_CYCLES_PER_LRCK; // 48828.125 Hz

// --- Audio Tone Generation Parameters ---
// This will generate a square wave tone. Adjust TONE_FREQ_HZ for desired pitch.
parameter TONE_FREQ_HZ = 440; // Desired frequency of the continuous tone (e.g., 440 Hz for A4)

// Calculate how many samples are needed for half a period of the tone
// This dictates how long the audio_sample stays high or low.
localparam SAMPLES_PER_HALF_PERIOD = ACTUAL_SAMPLE_RATE_HZ / (2 * TONE_FREQ_HZ);
// Ensure SAMPLES_PER_HALF_PERIOD is at least 1. If TONE_FREQ_HZ is too high, this can become 0.

// --- Internal Registers ---
reg [15:0] mclk_counter = 0; // Counts MCLK cycles to generate BCLK
reg [5:0] bclk_counter = 0;  // Counts BCLK cycles to generate LRCK and manage data bits
reg [23:0] audio_sample = 0; // 24-bit audio data for the current sample
reg [4:0] bit_shift_counter = 0; // Counts which bit of the 24-bit sample is currently being sent (0-23)

// State machine for I2S data transfer
typedef enum logic [1:0] { // Using SystemVerilog enum for clarity
    IDLE_STATE,
    LEFT_CHANNEL_TX,
    RIGHT_CHANNEL_TX
} i2s_state_t;

i2s_state_t i2s_state = IDLE_STATE; // Initialize state variable

// Registers for tone generation
reg tone_level = 1'b0; // Current level of the square wave tone (high/low)
reg [15:0] tone_sample_timer = 0; // Counts samples within a half-period of the tone

always @(posedge Clk) begin
    // --- BCLK Generation ---
    if (mclk_counter == MCLK_CYCLES_PER_BCLK - 1) begin
        mclk_counter <= 0;
        SCLK <= ~SCLK; // Toggle SCLK at the desired BCLK frequency

        // --- I2S Data and Frame (LRCK) Logic (Driven by BCLK) ---
        // I2S typically samples SDIN on the rising edge of SCLK,
        // and LRCK changes after the last bit of the previous frame.
        // We'll update SDIN on the falling edge of SCLK so it's stable for the rising edge.
        if (SCLK == 1'b0) begin // This means SCLK is about to go high (rising edge)
            case (i2s_state)
                IDLE_STATE: begin
                    // This state manages the LRCK timing before starting a new frame.
                    // LRCK typically goes low at the start of the Left channel frame.
                    if (bclk_counter == BCLK_CYCLES_PER_LRCK - 1) begin
                        // End of a full stereo frame, start new one with Left Channel
                        LRCK <= 1'b0; // Set LRCK low for Left Channel
                        i2s_state <= LEFT_CHANNEL_TX;
                        bclk_counter <= 0;
                        bit_shift_counter <= 23; // Start shifting from MSB for 24-bit data

                        // --- Update Tone Sample for New Audio Frame ---
                        if (SAMPLES_PER_HALF_PERIOD > 0) begin // Avoid division by zero if tone_freq is too high
                            if (tone_sample_timer == SAMPLES_PER_HALF_PERIOD - 1) begin
                                tone_level <= ~tone_level; // Toggle tone level
                                tone_sample_timer <= 0;
                            end else begin
                                tone_sample_timer <= tone_sample_timer + 1;
                            end
                        end
                        // Assign the audio sample based on the current tone level
                        // For 24-bit signed audio: Max positive = 24'h7FFFFF, Max negative = 24'h800000
                        audio_sample <= tone_level ? 24'h7FFFFF : 24'h800000;
                    end else begin
                        bclk_counter <= bclk_counter + 1;
                    end
                end

                LEFT_CHANNEL_TX: begin
                    SDIN <= audio_sample[bit_shift_counter]; // Output the current bit (MSB first)
                    if (bit_shift_counter == 0) begin
                        // Last bit of Left Channel sent, transition to Right Channel
                        i2s_state <= RIGHT_CHANNEL_TX;
                        LRCK <= 1'b1; // Set LRCK high for Right Channel
                        bit_shift_counter <= 23; // Reset for 24 bits of Right Channel
                    end else begin
                        bit_shift_counter <= bit_shift_counter - 1;
                    end
                end

                RIGHT_CHANNEL_TX: begin
                    SDIN <= audio_sample[bit_shift_counter]; // Output the current bit
                    if (bit_shift_counter == 0) begin
                        // Last bit of Right Channel sent, return to IDLE for next frame
                        i2s_state <= IDLE_STATE;
                        // LRCK will remain high until the start of the next Left frame (handled in IDLE_STATE)
                    end else begin
                        bit_shift_counter <= bit_shift_counter - 1;
                    end
                end
            endcase
        end
    end else begin
        mclk_counter <= mclk_counter + 1;
    end
end

endmodule