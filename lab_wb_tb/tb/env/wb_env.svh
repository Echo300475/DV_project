class wb_env #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_env;

  `uvm_component_param_utils(wb_env #(REQ,RSP))

  string my_name;

  typedef wb_agent #(REQ,RSP) wb_agent_t;
  wb_agent_t agent;

  typedef wb_sb #(REQ) sb_t;
  sb_t sb;

  typedef wb_cov #(REQ) wb_cov_t;
  wb_cov_t cov;

  function new(string name, uvm_component parent);
    super.new(name,parent);
    my_name = name;
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    my_name = get_name();
    agent = wb_agent_t::type_id::create("agent", this);
    sb = sb_t::type_id::create("sb", this);
    cov = wb_cov_t::type_id::create("cov",this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agent.wb_drv_agt_to_sb_port.connect(sb.wb_drv_to_sb_port);
    agent.wb_mon_agt_to_sb_port.connect(sb.wb_mon_to_sb_port);
    agent.agt_to_cov_port.connect(cov.cov_queue.analysis_export);
  endfunction

  task run_phase(uvm_phase phase);
    `uvm_info(my_name, "Running env ...", UVM_NONE);
    $display("------------------------------------------------------------------------------------------------------------------------------------------------------------");
  endtask

  function void extract_phase(uvm_phase phase);
    `uvm_info(my_name, "extract phase is called",UVM_NONE);
    $display("------------------------------------------------------------------------------------------------------------------------------------------------------------");
  endfunction

  function void check_phase(uvm_phase phase);
    `uvm_info(my_name,"check phase is called",UVM_NONE);
    $display("------------------------------------------------------------------------------------------------------------------------------------------------------------");
  endfunction

endclass
