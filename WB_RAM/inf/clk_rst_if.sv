`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2025 12:54:29 PM
// Design Name: 
// Module Name: 
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

interface clk_rst_if (output logic clk, output logic rst); 

	integer reset_length;
	integer num;
	
	task do_reset (reset_length);
		rst = 0;
		repeat (5) @(posedge clk);
		rst = 1;
	endtask 
	
	task do_wait (num);
		repeat (num) @(posedge clk);
	endtask 
	
	initial begin 
		#1 
		clk = 1;
		rst = 0;
		forever begin
			#30 clk = ~clk;
		end  
	end 

endinterface 