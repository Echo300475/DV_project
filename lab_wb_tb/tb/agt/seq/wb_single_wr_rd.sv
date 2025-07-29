class wb_single_wr_rd #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends base_seq #(REQ, RSP);

   `uvm_object_param_utils(wb_single_wr_rd #(REQ, RSP))
   
   string my_name;

   //integer drain_time = 10; //co the thay doi

   function new(string name = "");
      super.new(name);
      my_name = name;
   endfunction

   task write;
      REQ req_pkt;
      RSP rsp_pkt;

      req_pkt = REQ::type_id::create("WB WRITE PACKET CREATED");
      $display("------------------------------------------------------------------------------------------------------------------------------------------------------------");
      req_pkt.cyc = 1;
      req_pkt.stb = 1;
      req_pkt.sel = 1;
      req_pkt.we = 1;
      req_pkt.addr = wb_cfg_h.temp_address;
      req_pkt.dat_in = $random();
      
      wait_for_grant();
      send_request(req_pkt);
      uvm_report_info(my_name,$psprintf("SENDING WB WRITE PACKET"));
      $display("------------------------------------------------------------------------------------------------------------------------------------------------------------");
      get_response(rsp_pkt);
      uvm_report_info(my_name,$psprintf("RECEIVED WB WRITE RESPONSE PACKET %x",rsp_pkt.addr));
      $display("------------------------------------------------------------------------------------------------------------------------------------------------------------");
   endtask

   task read;
      REQ req_pkt;
      RSP rsp_pkt;

      req_pkt = REQ::type_id::create("WB READ PACKET CREATED");
      $display("------------------------------------------------------------------------------------------------------------------------------------------------------------");
      req_pkt.cyc = 1;
      req_pkt.stb = 1;
      req_pkt.sel = 1;
      req_pkt.we = 0;
      req_pkt.addr = wb_cfg_h.temp_address;
      
      wait_for_grant();
      send_request(req_pkt);
      uvm_report_info(my_name,$psprintf("SENDING WB READ PACKET"));
      $display("------------------------------------------------------------------------------------------------------------------------------------------------------------");
      get_response(rsp_pkt);
      uvm_report_info(my_name,$psprintf("RECEIVED WB READ RESPONSE PACKET %x",rsp_pkt.addr));
      $display("------------------------------------------------------------------------------------------------------------------------------------------------------------");
   endtask
   
   task pause(integer pause_time);
      REQ req_pkt;
      RSP rsp_pkt; 
  
  	  // Wait for a number of clocks
      req_pkt = REQ::type_id::create($psprintf("DO_WAIT"));
      $display("------------------------------------------------------------------------------------------------------------------------------------------------------------");
    	req_pkt.do_wait = 1;
      req_pkt.num_wait = pause_time;
      wait_for_grant();
      send_request(req_pkt);
      get_response(rsp_pkt);
      uvm_report_info(my_name,$psprintf("RECEIVED WB DO WAIT RESPONSE PACKET %x",rsp_pkt.addr));
      $display("------------------------------------------------------------------------------------------------------------------------------------------------------------");
	 endtask

   task body;
      super.body();
      // task and func
      for(int ii=0;ii<5;ii++) begin
         assert(wb_cfg_h.randomize());
         `uvm_info(my_name,$psprintf("TRANSACTION NUMBER %0d",ii),UVM_NONE)
         $display("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
         write();
         read();
         pause(20);
      end
   endtask

endclass
