class wb_single_wr_rd_test extends wb_base_test;

  `uvm_component_utils(wb_single_wr_rd_test)

  string my_name;
	
  typedef rst_seq #(wb_tlm,wb_tlm) rst_seq_t;
  rst_seq_t rst_seq_v;
  typedef wb_single_wr_rd #(wb_tlm,wb_tlm) wb_single_wr_rd_t;
  wb_single_wr_rd_t v_wb_single_wr_rd;
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
    my_name = "wb_single_wr_rd_test";
  endfunction
	
  function void build_phase(uvm_phase phase);
    string      seq_name;
      
    super.build_phase(phase);
    uvm_report_info(my_name,"build phase");
    $display("-----------------------------------------------------------------------------------------------------------------------------------------------------------------------");
		
    seq_name = "v_wb_single_wr_rd_name";
    v_wb_single_wr_rd = wb_single_wr_rd_t::type_id::create(seq_name);
    rst_seq_v = rst_seq_t::type_id::create("rst_seq_v");		
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction
  
  function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
  endfunction
	
  task run_phase(uvm_phase phase);
    uvm_report_info(my_name,"Running ...");
    $display("-----------------------------------------------------------------------------------------------------------------------------------------------------------------------");

    uvm_test_done.set_drain_time(this,10);
    phase.raise_objection(this,"Objection raised by wb_demo_test");
    
    //assert(wb_cfg_h.randomize());
    rst_seq_v.start(env_h.agent.wb_sequencer_0,null);
    fork
      v_wb_single_wr_rd.start(env_h.agent.wb_sequencer_0,null);
    join
    phase.drop_objection(this,"Objection dropped by wb_single_wr_rd_test");
  endtask

endclass
