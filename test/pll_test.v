module pll_test (
    input wire CLK,        // 12 MHz input clock
    input wire BTN_N,      // Reset button (active low)
    output wire LED1       // LED output
);

    wire clkout;
    pll my_pll (
        .clkin(CLK),
        .clkout(clkout)
    );

    // Simple counter to toggle LED
    reg [23:0] counter;
    always @(posedge clkout or negedge BTN_N) begin
        if (!BTN_N)
            counter <= 0;
        else
            counter <= counter + 1;
    end

    assign LED1 = counter[23]; // Blink LED1 to verify PLL output

endmodule

