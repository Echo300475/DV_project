//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
//***************************************************************************************************************
// A demo test case.
//***************************************************************************************************************
class spi_demo_test extends spi_base_test;

	`uvm_component_utils(spi_demo_test)
	
	string	my_name;
	
  typedef rst_seq #(spi_tlm,spi_tlm) rst_seq_t;
  rst_seq_t rst_seq;
  typedef apb_demo_seq #(spi_tlm,spi_tlm) apb_demo_seq_t;
  apb_demo_seq_t apb_demo_seq;
  typedef spi_demo_seq #(spi_tlm,spi_tlm) spi_demo_seq_t;
  spi_demo_seq_t spi_demo_seq;
  
	function new(string name, uvm_component parent);
		super.new(name,parent);
		my_name = "spi_demo_test";
	endfunction
	
	function void build_phase(uvm_phase phase);
    string      demo_seq_name;
    integer	cmd_num_write;
      
		super.build_phase(phase);
		uvm_report_info(my_name,"demo build phase");
		
		demo_seq_name = "apb_demo_seq_name";
		apb_demo_seq = apb_demo_seq_t::type_id::create(demo_seq_name);
		spi_demo_seq = spi_demo_seq_t::type_id::create("spi_demo_seq");
		rst_seq = rst_seq_t::type_id::create("rst_seq");
		
	endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction
  
  function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
  endfunction
	
	task run_phase(uvm_phase phase);
		uvm_report_info(my_name,"Running ...");

    uvm_test_done.set_drain_time(this,10);
    phase.raise_objection(this,"Objection raised by spi_demo_test");
    
		assert(spi_cfg_h.randomize() with {mode == 0;});
   	rst_seq.start(env_h.apb_agent_0.sequencer,null);
		fork
    	apb_demo_seq.start(env_h.apb_agent_0.sequencer,null);
    	spi_demo_seq.start(env_h.spi_agent_0.sequencer,null);
		join

    phase.drop_objection(this,"Objection dropped by spi_demo_test");
	endtask
	
endclass
