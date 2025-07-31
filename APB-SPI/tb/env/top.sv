//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
//***************************************************************************************************************
// Top level module. It is responsible for instantiating the dut and the interface modules. It also passes the
// interface handle using set_config_object.
//***************************************************************************************************************
import uvm_pkg::*;
import spi_test_pkg::*;

//`include "mux_in_if.sv"
//`include "mux_out_if.sv"
//`include "clk_rst_if.sv"

module top;
   
  wire clk;
  wire rst;
   
  //
  // Interface declaration here
  //
  clk_rst_if clk_rst_if0(.clk(clk),.rst(rst));
  apb_if apb_if0(.clk(clk),.rst(rst));
  spi_if spi_if0(.clk(clk),.rst(rst));
   
  spi_top dut0(
    // APB Interface:
    .PCLK(clk),
    .PRESETN(rst),
    .PSEL(apb_if0.PSEL),
    .PADDR(apb_if0.PADDR[4:0]),
    .PWDATA(apb_if0.PWDATA),
    .PRDATA(apb_if0.PRDATA),
    .PENABLE(apb_if0.PENABLE),
    .PREADY(apb_if0.PREADY),
    .PSLVERR(),
    .PWRITE(apb_if0.PWRITE),
    // Interrupt output
    .IRQ(apb_if0.IRQ),
    // SPI signals
    .ss_pad_o(spi_if0.ss_pad_o),
    .sclk_pad_o(spi_if0.sclk_pad_o),
    .mosi_pad_o(spi_if0.mosi_pad_o),
    .miso_pad_i(spi_if0.miso_pad_i)
	);

  initial begin
    uvm_config_db #(virtual clk_rst_if)::set(null,"*","CLK_RST_VIF",clk_rst_if0);
    uvm_config_db #(virtual apb_if)::set(null,"*","APB_VIF",apb_if0);
    uvm_config_db #(virtual spi_if)::set(null,"*","SPI_VIF",spi_if0);
    run_test();
  end

endmodule
