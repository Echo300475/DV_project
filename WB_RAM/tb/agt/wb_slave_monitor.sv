class wb_slave_monitor #(type PKT = wb_tlm) extends uvm_monitor;

  `uvm_component_param_utils(wb_slave_monitor #(PKT))
  
  string my_name;
  wb_cfg wb_cfg_h;

  virtual interface wb_if wb_vif;
  
  uvm_analysis_port #(PKT) wb_mon_to_agt_port;

  function new (string name, uvm_component parent);
     super.new(name,parent);
     my_name = name;
  endfunction 

  function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     wb_mon_to_agt_port = new($psprintf("%s_wb_mon_to_agt_port", my_name), this);
  endfunction

  function void connect_phase(uvm_phase phase);
     if ( !uvm_config_db #(virtual wb_if)::get(this,"","WB_VIF", wb_vif) )
     begin
       `uvm_error(my_name, "could not retrieve virtual wb_if"); 
     end
  endfunction

  function void start_of_simulation_phase(uvm_phase phase);
     super.start_of_simulation_phase(phase);
  endfunction

  task monitor;
     PKT sb_pkt;

     forever begin
       @(posedge wb_vif.clk_i);
       if(wb_vif.stb_i && wb_vif.cyc_i && !wb_vif.we_i && wb_vif.ack_o) begin
         sb_pkt = PKT::type_id::create("packet created");
         sb_pkt.stb = wb_vif.stb_i;
         sb_pkt.cyc = wb_vif.cyc_i;
         sb_pkt.sel = wb_vif.sel_i;
         sb_pkt.we  = wb_vif.we_i;
         sb_pkt.addr = wb_vif.adr_i;
         @(posedge wb_vif.clk_i);
         sb_pkt.dat_out = wb_vif.dat_o;
         `uvm_info(my_name,$psprintf("data captured from wb_vif addr: %h , wb_vif data out: %h",wb_vif.adr_i,wb_vif.dat_o),UVM_NONE)
         $display("------------------------------------------------------------------------------------------------------------------------------------------------------------");
         `uvm_info(my_name,$psprintf("data send to scoreboard addr: %h , data out: %h",sb_pkt.addr,sb_pkt.dat_out),UVM_NONE)
         $display("------------------------------------------------------------------------------------------------------------------------------------------------------------");
         wb_mon_to_agt_port.write(sb_pkt);
       end
     end
  endtask

  task run_phase(uvm_phase phase);
    monitor();
  endtask

endclass
