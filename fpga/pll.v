module pll(
    input clkin,  // 12 MHz input clock
    output clkout, // 30 MHz output clock
    output locked
);
    SB_PLL40_PAD #(
        .FEEDBACK_PATH("SIMPLE"),
        .DIVR(4'b0000),         // DIVR =  0
        .DIVF(7'b1001111),      // DIVF = 39
        .DIVQ(3'b100),          // DIVQ =  4
        .FILTER_RANGE(3'b001)   // FILTER_RANGE = 1
    ) pll_inst (
        .LOCK(locked),
        .RESETB(1'b1),
        .BYPASS(1'b0),
        .PACKAGEPIN(clkin),
        .PLLOUTGLOBAL(clkout)
    );
endmodule

