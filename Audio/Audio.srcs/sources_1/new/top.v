module top (
    input clk,           // 100 MHz clock input
    output wire lrck,           // Left/Right clock to CS4344
    output wire sclk,           // Bit clock to CS4344
    output wire sdin,           // Audio data to CS4344
    output wire mclk            // Master clock to CS4344
);

wire clk_12mhz;

// Instantiate the clocking wizard to get 12.288 MHz
clk_wiz_0 clkgen (
    .clk_in(clk),
    .mclk(clk_12mhz)
);

// Map 12.288 MHz to MCLK pin
assign mclk = clk_12mhz;

// I2S Tone Generator
i2s_test_tone tonegen (
    .clk(clk_12mhz),   // This is MCLK
    .lrck(lrck),
    .sclk(sclk),
    .sdin(sdin)
);

endmodule
