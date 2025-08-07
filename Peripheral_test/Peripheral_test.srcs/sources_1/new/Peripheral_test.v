module peripheral_controls(
    input wire Clk,                   // 100MHz input clock
    input wire RESET,          // Enable button input
    input wire [2:0] Switch,       // Active-High DIP switches
    output reg [7:0] SevenSegment,    // Seven segments output
    output reg [3:0] Enable,          // Enable pins for each display module
    output reg [7:0] LED
            
);

    // Internal signals
    reg clk_i = 0;                   
    reg [27:0] counter = 28'b0;       // Counter for clock division
    reg [3:0] bcd = 0;                // Value to display on seven segment
    integer i = 0;                    // Counter for timing
    reg [3:0] led_index = 0;          // Index for running LED pattern

    // Clock divider
    always @(posedge Clk) begin
        counter <= counter + 1;
        clk_i <= counter[18];
    end

    // Main process
    always @(posedge clk_i) begin
        if (!RESET) begin
            // DIP switches logic (active-low)
            if (Switch[0]) begin
                // DIP 1 ON
                SevenSegment <= 8'b10000010; // 3
                Enable <= 4'b1110;           // only last digit
                LED <= 8'b00000011;
            end
            else if (Switch[1]) begin
                // DIP 2 ON
                SevenSegment <= 8'b10001000; // 5
                Enable <= 4'b1110;
                LED <= 8'b00000101;
            end
            else if (Switch[2]) begin
                // DIP 3 ON
                SevenSegment <= 8'b11000011; // 7
                Enable <= 4'b1110;
                LED <= 8'b00000111;
             end
            else begin
                // No DIP active - count and run LEDs
                Enable <= 4'b0000;
                if (i == 100) begin
                    bcd <= (bcd == 9) ? 0 : bcd + 1;
                    i <= 0;
                    led_index <= led_index + 1;
                    LED <= (8'b00000001 << led_index);
                end else begin
                    i <= i + 1;
                end

                // BCD to seven segment
                case (bcd)
                    0: SevenSegment <= 8'b00000001;
                    1: SevenSegment <= 8'b11000111;
                    2: SevenSegment <= 8'b00100010;
                    3: SevenSegment <= 8'b10000010;
                    4: SevenSegment <= 8'b11000100;
                    5: SevenSegment <= 8'b10001000;
                    6: SevenSegment <= 8'b00001000;
                    7: SevenSegment <= 8'b11000011;
                    8: SevenSegment <= 8'b00000000;
                    9: SevenSegment <= 8'b10000000;
                    default: SevenSegment <= 8'b11111111;
                endcase
            end
        end else begin
            // If EnableButton is not pressed
            SevenSegment <= 8'b11111111;
            Enable <= 4'b1111;
            LED <= 8'b00000000;
            bcd <= 0;
            i <= 0;
        end
    end
endmodule
