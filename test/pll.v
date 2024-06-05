module pll(
    input wire clkin,  // 12 MHz input clock
    output wire clkout // 30 MHz output clock
);
    SB_PLL40_PAD #(
        .FEEDBACK_PATH("SIMPLE"),
        .DIVR(4'b0000),         // Divider R
        .DIVF(7'b0111111),      // Divider F
        .DIVQ(3'b100),          // Divider Q
        .FILTER_RANGE(3'b001)   // Filter Range
    ) pll_inst (
        .PACKAGEPIN(clkin),
        .PLLOUTCORE(clkout),
        .LOCK(),
        .BYPASS(1'b0),
        .RESETB(1'b1)
    );
endmodule

