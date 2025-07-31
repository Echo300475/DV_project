class wb_agent #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_agent;

   `uvm_component_param_utils(wb_agent #(REQ,RSP))

   typedef wb_master_driver #(REQ,RSP) wb_driver;
   typedef uvm_sequencer #(REQ,RSP) wb_sequencer;
   typedef wb_slave_monitor #(REQ) wb_monitor;

   string my_name;
   uvm_analysis_port #(REQ) wb_drv_agt_to_sb_port;
   uvm_analysis_port #(REQ) wb_mon_agt_to_sb_port;
   uvm_analysis_port #(REQ) agt_to_cov_port;

   wb_sequencer wb_sequencer_0;
   wb_driver wb_driver_0;
   wb_slave_monitor wb_monitor_0;

   function new(string name, uvm_component parent);
      super.new(name, parent);
      my_name = get_name();
   endfunction

   function void build_phase (uvm_phase phase);
      super.build_phase(phase);
      wb_sequencer_0 = wb_sequencer::type_id::create("wb_sequencer_0", this);
      wb_driver_0 = wb_driver::type_id::create("wb_driver_0", this);
      wb_monitor_0 = wb_monitor::type_id::create("wb_monitor_0",this);
      
      wb_drv_agt_to_sb_port = new($psprintf("%s_wb_drv_agt_to_sb_port", my_name), this);
      wb_mon_agt_to_sb_port = new($psprintf("%s_wb_mon_agt_to_sb_port", my_name), this);
      agt_to_cov_port       = new($psprintf("%s_agt_to_cov_port",my_name),this);
   endfunction

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);

      wb_driver_0.seq_item_port.connect(wb_sequencer_0.seq_item_export);

      `uvm_info(my_name,"connect driver to agent",UVM_NONE);
      $display("------------------------------------------------------------------------------------------------------------------------------------------------------------");
      wb_driver_0.wb_drv_to_agt_port.connect(wb_drv_agt_to_sb_port); // need review

      `uvm_info(my_name,"connect monitor to agent",UVM_NONE);
      $display("------------------------------------------------------------------------------------------------------------------------------------------------------------");
      wb_monitor_0.wb_mon_to_agt_port.connect(wb_mon_agt_to_sb_port);

      `uvm_info(my_name,"connect driver sequence to angent cov port",UVM_NONE);
      $display("------------------------------------------------------------------------------------------------------------------------------------------------------------");
      wb_driver_0.cov_port.connect(agt_to_cov_port);
      
   endfunction

   task run;
   endtask

endclass
