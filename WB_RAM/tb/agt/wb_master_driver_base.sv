class wb_master_driver_base #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_driver #(REQ,RSP);

   `uvm_component_param_utils(wb_master_driver_base #(REQ,RSP))

   string my_name;
   
   integer rsp_pkt_cnt;
   wb_cfg wb_cfg_h;

   uvm_analysis_port #(REQ) wb_drv_to_agt_port;
   uvm_analysis_port #(REQ) cov_port;
   
   function new(string name, uvm_component parent);
      super.new(name, parent);
      rsp_pkt_cnt = 0;
   endfunction

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      my_name = get_name();
      wb_drv_to_agt_port = new($psprintf("%s_wb_drv_to_agt_port", my_name),this);
      cov_port = new($psprintf("%s_cov_port",my_name),this);
   endfunction

   function void connect_phase(uvm_phase phase);
      uvm_object  tmp_obj;
   endfunction 

   function void start_of_simulation_phase(uvm_phase phase);
      super.start_of_simulation_phase(phase);
   endfunction

endclass
