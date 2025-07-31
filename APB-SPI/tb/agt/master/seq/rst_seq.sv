//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class rst_seq #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_sequence #(REQ,RSP);

  `uvm_object_param_utils(rst_seq #(REQ,RSP))
  
  string my_name;
   
  function new(string name="");
    super.new(name);
		my_name = name;
  endfunction

	task body;
    REQ   rst_pkt;
    RSP   rsp_pkt; 

    rst_pkt = REQ::type_id::create($psprintf("rst_pkt"));
    rst_pkt.to_reset = 1;
    wait_for_grant();
    send_request(rst_pkt);
    uvm_report_info(my_name,$psprintf("Sending reset packet "));
    get_response(rsp_pkt);
    uvm_report_info(my_name,$psprintf("Received reponse packet"));
	endtask
   
endclass
