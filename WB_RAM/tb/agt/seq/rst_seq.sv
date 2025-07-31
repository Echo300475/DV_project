class rst_seq #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_sequence #(REQ, RSP);

   `uvm_object_param_utils(rst_seq #(REQ, RSP) )

   string my_name;

   function new(string name = "");
      super.new(name);
      my_name = name;
   endfunction

   task body;
      REQ rst_pkt;
      RSP rsp_pkt;

      $display("--------------------------------------------------------------------------------------------------------------------------------------------");
      rst_pkt = REQ::type_id::create($psprintf("rst_pkt") );
      $display("--------------------------------------------------------------------------------------------------------------------------------------------");
      rst_pkt.to_reset = 1;
      wait_for_grant();
      send_request(rst_pkt);
      $display("--------------------------------------------------------------------------------------------------------------------------------------------");
      uvm_report_info(my_name, $psprintf("sending reset signal") );
      $display("--------------------------------------------------------------------------------------------------------------------------------------------");
      get_response(rsp_pkt);
      $display("--------------------------------------------------------------------------------------------------------------------------------------------");
      uvm_report_info(my_name, $psprintf("receive response") );
      $display("--------------------------------------------------------------------------------------------------------------------------------------------");
   endtask

endclass
