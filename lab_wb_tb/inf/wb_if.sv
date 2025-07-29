`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2025 12:41:36 PM
// Design Name: 
// Module Name: wb_interface
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

interface wb_if(input logic rst, input logic clk);
   parameter DWIDTH = 8;
   parameter AWIDTH = 16;
   //input clk rst
   logic        clk_i;
   logic        rst_i;
   
   //input signal
   logic [AWIDTH-1:0]        adr_i;
   logic [DWIDTH-1:0]        dat_i;
   logic                     we_i;
   logic                     stb_i;
   logic [(DWIDTH/8) - 1 :0] sel_i;
   logic 		                 cyc_i;
   
   //output port
   wire [DWIDTH-1:0]	 dat_o;
   wire 			         ack_o;
   wire                err_o;
   wire                rty_o;

   assign clk_i = clk;
   assign rst_i = rst;

endinterface : wb_if
