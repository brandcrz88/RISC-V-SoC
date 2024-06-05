module top (
    input CLK,
    input BTN_N, // This is reset_n
    output LED1, LED2, LED3, LED4, LED5,
    output TX
);

   wire uart_tx;
   assign TX = uart_tx;

   parameter MEM_FILE = "firmware.hex";
   
   wire mem_rstrb;
   wire mem_instr;
   wire mem_ready;
   wire [31:0] mem_addr;
   wire [31:0] mem_wdata;
   wire [3:0] mem_wstrb;
   wire [31:0] mem_rdata, rdata_gpio, rdata_uart;

   wire s0_sel_mem;
   wire s1_sel_gpio;
   wire s2_sel_uart;

   wire clk;
   wire pll_locked;
   // PLL section
   pll my_pll(
       .clkin(CLK), 
       .clkout(clk), 
       .locked(pll_locked)
   );

   reg [31:0] processor_rdata;

   always @(*) begin
        processor_rdata = 32'h0;
        case ({s2_sel_uart, s1_sel_gpio, s0_sel_mem})
            3'b001: processor_rdata = mem_rdata;
            3'b010: processor_rdata = rdata_gpio;
            3'b100: processor_rdata = rdata_uart;
        endcase
   end

  Memory #(
      .MEM_FILE(MEM_FILE),
      .SIZE(1024)
  ) D_mem_unit (
      .clk(clk),
      .mem_addr(mem_addr),
      .mem_rdata(mem_rdata),
      .mem_rstrb(s0_sel_mem & mem_rstrb),
      .mem_wdata(mem_wdata),
      .mem_wmask({4{s0_sel_mem}} & mem_wstrb)
  );

  FemtoRV32 processor (
      .clk(clk),
      .reset(~pll_locked || BTN_N),  // Updated reset logic
      .mem_rstrb(mem_rstrb),
      .mem_rbusy(1'b0),
      .mem_wbusy(1'b0),
      .mem_addr(mem_addr),
      .mem_wdata(mem_wdata),
      .mem_wmask(mem_wstrb),
      .mem_rdata(processor_rdata)
  );

   // Vector for GPIO data output
   wire [4:0] csr_gpio_0_data_out;
   assign {LED1, LED2, LED3, LED4, LED5} = csr_gpio_0_data_out;

   gpio_ip gpio_unit(
    // System
    .clk(clk),
    .rst(!BTN_N),
    // GPIO_0.DATA
    .csr_gpio_0_data_out(csr_gpio_0_data_out),

    // Local Bus
    .waddr({4'h0, mem_addr[27:0]}),
    .wdata(mem_wdata),
    .wen(s1_sel_gpio & (|mem_wstrb)),
    .wstrb(mem_wstrb),
    .wready(),
    .raddr({4'h0, mem_addr[27:0]}),
    .ren(s1_sel_gpio & mem_rstrb),
    .rdata(rdata_gpio),
    .rvalid()
   );

   uart_ip uart_unit(
    // System
    .clk(clk),
    .rst(!BTN_N),
    // Local Bus
    .waddr({4'h0, mem_addr[27:0]}),
    .wdata(mem_wdata),
    .wen(s2_sel_uart & (|mem_wstrb)),
    .wstrb(mem_wstrb),
    .wready(),
    .raddr({4'h0, mem_addr[27:0]}),
    .ren(s2_sel_uart & mem_rstrb),
    .rdata(rdata_uart),
    .rvalid(),
    // uart tx
    .o_uart_tx(uart_tx)
   );

  device_select dv_sel(
    .addr(mem_addr),
    .s0_sel_mem(s0_sel_mem),
    .s1_sel_gpio(s1_sel_gpio),
    .s2_sel_uart(s2_sel_uart)
  );

endmodule

