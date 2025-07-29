//***************************************************************************************************************
//***************************************************************************************************************
`timescale 1ns/1ps

interface clk_rst_if (output logic clk, output logic rst);
// pragma attribute clk_rst_if partition_interface_xif

	task do_reset (integer reset_length); // pragma tbx xtf
		rst = 0;
		repeat (5) @(posedge clk);
		rst = 1;
	endtask

	task do_wait(integer num);
		repeat (num) @(posedge clk);
	endtask
	
	initial begin
		#1;
		clk = 1;
		rst = 0;
		forever begin
			#30 clk = ~clk;
		end
	end

endinterface
