module pll_tb;

    reg clkin;
    wire clkout;
    reg [23:0] counter;

    // Instantiate the PLL
    pll uut (
        .clkin(clkin),
        .clkout(clkout)
    );

    // Generate input clock
    always #5 clkin = ~clkin;  // 100 MHz clock

    // Counter to toggle LED
    always @(posedge clkout) begin
        counter <= counter + 1;
    end

    // Initial setup
    initial begin
        clkin = 0;
        counter = 0;
        $monitor("Time = %d, Counter = %d", $time, counter);
    end

    // Run simulation for some time
    initial begin
        #1000 $finish;
    end

endmodule

