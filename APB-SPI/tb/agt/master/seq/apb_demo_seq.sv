//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class apb_demo_seq #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends base_seq #(REQ,RSP);

  `uvm_object_param_utils(apb_demo_seq #(REQ,RSP))
  
  string my_name;
   
  integer drain_time = 10;
  
  function new(string name="");
    super.new(name);
		my_name = name;
  endfunction

	// Write to all four Tx regs
	task write_tx_regs;
    REQ req_pkt;
    RSP rsp_pkt; 
		bit [31:0] temp_data;

		temp_data = 32'haaaaaaaa;
		// Write all four Tx registers
    for (int ii=0; ii<4; ii++) begin
      req_pkt = REQ::type_id::create($psprintf("req_pkt_id_%d",ii));
      req_pkt.addr = ii*4;
			req_pkt.wr_rd = 1;
			req_pkt.wdata = temp_data;
      temp_data = temp_data + 32'h11111111;
      wait_for_grant();
      send_request(req_pkt);
      get_response(rsp_pkt);
      uvm_report_info(my_name,$psprintf("Received reponse packet %x",rsp_pkt.addr));
    end
        
	endtask

	// Write to slave select reg
	task write_ss_reg;
    REQ req_pkt;
    RSP rsp_pkt; 

    req_pkt = REQ::type_id::create($psprintf("SS register"));
    req_pkt.addr = 24;
	  req_pkt.wr_rd = 1;
	  req_pkt.wdata = 1;
    wait_for_grant();
    send_request(req_pkt);
    get_response(rsp_pkt);

	endtask

	// Write to control reg to start transmission
	task write_ctl_reg;
    REQ req_pkt;
    RSP rsp_pkt; 
		bit [31:0] ctl_data;
		bit bit_ass;
		bit bit_ie;
		bit bit_lsb;
		bit bit_txneg;
		bit bit_rxneg;
		bit bit_gobsy;
		bit [6:0] char_len;

		bit_ass   = spi_cfg_h.bit_ass;
		bit_ie    = spi_cfg_h.bit_ie;
		bit_lsb   = spi_cfg_h.bit_lsb;
		bit_txneg = spi_cfg_h.bit_txneg;
		bit_rxneg = spi_cfg_h.bit_rxneg;
		bit_gobsy = spi_cfg_h.bit_gobsy;
		char_len  = spi_cfg_h.num_chars[6:0];
		ctl_data = {18'h0,bit_ass,bit_ie,bit_lsb,bit_txneg,bit_rxneg,bit_gobsy,1'b0,char_len};

	  // Write to control register to initiate the transmission
    req_pkt = REQ::type_id::create($psprintf("Control register"));
    req_pkt.addr = 16;
	  req_pkt.wr_rd = 1;
	  req_pkt.wdata = ctl_data;
    wait_for_grant();
    send_request(req_pkt);
    get_response(rsp_pkt);

	endtask

	// Delay before reading the Rx regs
	task pause(integer pause_time);
    REQ req_pkt;
    RSP rsp_pkt; 

	  // Wait for a number of clocks
    req_pkt = REQ::type_id::create($psprintf("do_wait"));
  	req_pkt.do_wait = 1;
    req_pkt.num_wait = pause_time;
    wait_for_grant();
    send_request(req_pkt);
    get_response(rsp_pkt);
    uvm_report_info(my_name,$psprintf("Received reponse packet %x",rsp_pkt.addr));

	endtask

	// Read the Rx regs
	task read_rx_regs;
    REQ req_pkt;
    RSP rsp_pkt; 

		// Read registers
    for (int ii=0; ii<spi_cfg_h.num_dwords; ii++) begin
      req_pkt = REQ::type_id::create($psprintf("req_pkt_id_%d",ii));
      req_pkt.addr = ii*4;
			req_pkt.wr_rd = 0;
      wait_for_grant();
      send_request(req_pkt);
      get_response(rsp_pkt);
      uvm_report_info(my_name,$psprintf("Received reponse packet %x",rsp_pkt.addr));
    end
        
	endtask

	// Start the transmission max_loop times. Each time num_chars of bits are transmitted
  task body;
      
		super.body();
      
		for (int ii=0; ii<spi_cfg_h.max_loop; ii++) begin
			// Cannot randomize both max_loop and num_chars at the same time, so randomize
			// num_chars here after max_loop has been randomized
			//spi_cfg_h.num_chars = $urandom_range(1,128);
			assert(spi_cfg_h.randomize() with {mode==0;});
			spi_cfg_h.set_mask();
         spi_cfg_h.sem.put(1);
			`uvm_info(my_name,$psprintf("num_chars = %0d, num_dwords = %0d",spi_cfg_h.num_chars,spi_cfg_h.num_dwords),UVM_NONE)
			->spi_cfg_h.sample_e;
			spi_cfg_h.print();
			write_tx_regs();
			if (spi_cfg_h.bit_ass == 0) begin
				write_ss_reg();
			end
			spi_cfg_h.start_tx();
			write_ctl_reg();
			pause(2000);
			read_rx_regs();
			spi_cfg_h.stop_tx();
		end

  endtask
   
endclass
