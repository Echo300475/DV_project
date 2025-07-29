`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2025 01:07:27 PM
// Design Name: 
// Module Name: top
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
import uvm_pkg::*;
import wb_test_pkg::*;

module top;

  wire clk;
  wire rst;

  clk_rst_if clk_rst_vif(.clk(clk), .rst(rst));
  wb_if wb_vif(.clk(clk), .rst(rst));

  wb_slave_model  dut
                  (
                    .clk_i(wb_vif.clk_i),
                    .rst_i(wb_vif.rst_i),
                    .adr_i(wb_vif.adr_i),
                    .dat_i(wb_vif.dat_i),
                    .we_i(wb_vif.we_i),
                    .sel_i(wb_vif.sel_i),
                    .stb_i(wb_vif.stb_i),
                    .cyc_i(wb_vif.cyc_i),
                    .dat_o(wb_vif.dat_o),
                    .ack_o(wb_vif.ack_o),
                    .err_o(wb_vif.err_o),
                    .rty_o(wb_vif.rty_o)
                  );

  initial begin
    uvm_report_info("top","setting interface into database");
    uvm_config_db #(virtual clk_rst_if)::set(null,"*","CLK_RST_VIF",clk_rst_vif);
    uvm_config_db #(virtual wb_if)::set(null,"*","WB_VIF",wb_vif);
    run_test(); 
  end 
endmodule
