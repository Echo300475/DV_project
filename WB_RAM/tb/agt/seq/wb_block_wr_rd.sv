class wb_block_wr_rd #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends base_seq #(REQ, RSP);

   `uvm_object_param_utils(wb_block_wr_rd #(REQ, RSP))
   
   string my_name;

   //integer drain_time = 10; //co the thay doi
   bit [15:0] adr_hold [15:0];

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

   task read(input integer i);
      REQ req_pkt;
      RSP rsp_pkt;

      req_pkt = REQ::type_id::create("WB READ PACKET CREATED");
      $display("------------------------------------------------------------------------------------------------------------------------------------------------------------");
      req_pkt.cyc = 1;
      req_pkt.stb = 1;
      req_pkt.sel = 1;
      req_pkt.we = 0;
      uvm_report_info(my_name,$psprintf("ADR_MEM = %x",adr_hold[i]));
      $display("------------------------------------------------------------------------------------------------------------------------------------------------------------");
      req_pkt.addr = adr_hold[i];
      
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
      uvm_report_info(my_name,"START WRITE");
      $display("------------------------------------------------------------------------------------------------------------------------------------------------------------");
      
      for(int ii=0;ii<5;ii++) begin
         assert(wb_cfg_h.randomize());
         `uvm_info(my_name,$psprintf("TRANSACTION NUMBER %0d",ii),UVM_NONE)
         $display("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
         write();
         adr_hold[ii] = wb_cfg_h.temp_address;
         uvm_report_info(my_name,$psprintf("ADR_MEM = %x",adr_hold[ii]));
         $display("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
         pause(20);
      end
      
      uvm_report_info(my_name,"DONE WRITE");
      $display("------------------------------------------------------------------------------------------------------------------------------------------------------------");
      pause(100);
      uvm_report_info(my_name,"START READ");
      $display("------------------------------------------------------------------------------------------------------------------------------------------------------------");
      
      for(int ii=0;ii<5;ii++) begin
         `uvm_info(my_name,$psprintf("TRANSACTION NUMBER %0d",ii),UVM_NONE)
         $display("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
         read(ii);
         pause(20);
      end
      
      uvm_report_info(my_name,"DONE READ");
      $display("------------------------------------------------------------------------------------------------------------------------------------------------------------");
      
   endtask

endclass
