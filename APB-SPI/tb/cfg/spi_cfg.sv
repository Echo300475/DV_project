//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
// pre randomize and post randomize
//***************************************************************************************************************
class spi_cfg extends uvm_object;

   `uvm_object_utils(spi_cfg)
  
   string  my_name;
   integer  num_dwords;
   bit     tx_done;
	integer clk_cnt_ss;
   rand bit     inject_error;
	rand bit [7:0] num_chars;
	bit [127:0]    mask;
	bit [31:0]     mask_arr[4];
	rand integer mode;
	rand bit bit_ass; // control reg bits
	rand bit bit_ie; // control reg bits
	rand bit bit_lsb; // control reg bits
	rand bit bit_txneg; // control reg bits
	rand bit bit_rxneg; // control reg bits
	rand bit bit_gobsy; // control reg bits
	rand integer  max_loop; // control reg bits
	event sample_e;
   semaphore sem;
    
	// Capture coverage of control bits
	covergroup cfg_cov_grp @sample_e;
		ass_cov: coverpoint bit_ass {
			bins ass[] = {0,1};
		}
		ie_cov: coverpoint bit_ie {
			bins ie[] = {0,1};
		}
		lsb_cov: coverpoint bit_lsb {
			bins lsb[] = {0,1};
		}
		txneg_cov: coverpoint bit_txneg {
			bins txneg[] = {0,1};
		}
		rxneg_cov: coverpoint bit_rxneg {
			bins rxneg[] = {0,1};
		}
		/*num_chars_cov: coverpoint num_chars {
			bins num_chars_lo = {1};
			bins num_chars_mid = {[2:127]};
			bins num_chars_hi = {128};
		}*/
		maxloop_cov: coverpoint max_loop {
			bins maxloop[5] = {[2:6]};
		}
      num_chars_cov: coverpoint num_chars {
         bins value_1         = {1};
         bins value_128       = {128};
         bins range_2_to_31   = {[2:31]};
         bins value_32        = {32};
         bins value_33        = {33};
         bins range_34_to_63  = {[34:63]};
         bins value_64        = {64};
         bins value_65        = {65};
         bins range_66_to_95  = {[66:95]};
         bins value_96        = {96};
         bins value_97        = {97};
         bins range_98_to_127 = {[98:127]};
      }
	endgroup
  
  function new(string name = "");
    super.new(name);
    my_name = name;
	 cfg_cov_grp = new;
    // add a semaphore, initialise it to 0
    sem = new(1);
  endfunction

	// virtual function to support the print() function
  function void do_print(uvm_printer printer);
    printer.print_field("inject_error",inject_error,$bits(inject_error));
    printer.print_field("max_loop",max_loop,$bits(max_loop));
    printer.print_field("bit_ass",bit_ass,$bits(bit_ass));
    printer.print_field("bit_ie",bit_ie,$bits(bit_ie));
    printer.print_field("bit_lsb",bit_lsb,$bits(bit_lsb));
    printer.print_field("bit_txneg",bit_txneg,$bits(bit_txneg));
    printer.print_field("bit_rxneg",bit_rxneg,$bits(bit_rxneg));
    printer.print_field("num_chars",num_chars,$bits(num_chars));
  endfunction

	function void start_tx;
		tx_done = 0;
		clk_cnt_ss = 0;
	endfunction
  
	function void stop_tx;
		tx_done = 1;
	endfunction
 
  /*function void set_max_loop;
		max_loop = $urandom_range(2,10);
	endfunction*/
  
	// Set the proper masking for the Rx regs based on the number of
	// bits in num_chars
  function void set_mask;
		mask = 0;
		for (int ii=0; ii<num_chars; ii++) begin
			mask[ii] = 1;
		end
		mask_arr[0] = mask[31:0];
		mask_arr[1] = mask[63:32];
		mask_arr[2] = mask[95:64];
		mask_arr[3] = mask[127:96];
		if (num_chars % 32 == 0) begin
			num_dwords = num_chars / 32;
		end else begin
			num_dwords = (num_chars / 32) + 1;
		end
	endfunction

  constraint default_config_c {
      inject_error == 0;
      //max_loop == $urandom_range(2,10);
      max_loop inside {[2:6]};
      soft num_chars inside {[1:128]};
      num_chars dist {
            128     := 1,
            1       := 1,
            [2:31]  :/ 1,
            32      := 1,
            33      := 1,
            [34:63] :/ 1,
            64      := 1,
            65      := 1,
            [66:95] :/ 1,
            96      := 1,
            97      := 1,
            [98:127]:/ 1
      };
		//max_loop == 1;
		(mode == 0) -> {
				bit_ass   == 1;
				bit_ie    == 1;
				bit_lsb   == 1;
				bit_txneg == 0;
				bit_rxneg == 1;
				bit_gobsy == 1;
		}
		(mode == 1) -> {
				bit_ass   == 1;
				bit_ie    == 1;
				bit_lsb   == 1;
				bit_txneg == 1;
				bit_rxneg == 0;
				bit_gobsy == 1;
		}
		(mode == 2) -> {
				bit_ass   == 1;
				bit_ie    == 1;
				bit_lsb   == 0;
				bit_txneg == 0;
				bit_rxneg == 1;
				bit_gobsy == 1;
		}
		(mode == 3) -> {
				bit_ass   == 0;
				bit_ie    == 1;
				bit_lsb   == 1;
				bit_txneg == 0;
				bit_rxneg == 1;
				bit_gobsy == 1;
		}
  }
  
endclass
