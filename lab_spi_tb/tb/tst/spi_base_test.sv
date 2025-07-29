//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
//***************************************************************************************************************
// This is the base test layer. It instantiates the environment.
//***************************************************************************************************************
class spi_base_test extends uvm_test;

  `uvm_component_utils(spi_base_test)
   
  string my_name = "spi_base_test";
  
  typedef spi_env #(spi_tlm,spi_tlm) env_t;
  env_t   env_h;
	spi_cfg spi_cfg_h;
   
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
   
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_report_info(my_name,"base build phase");

    env_h = env_t::type_id::create("spi_env",this);
    spi_cfg_h = spi_cfg::type_id::create("spi_cfg");
		uvm_config_db#(spi_cfg)::set(null,"*","SPI_CFG",spi_cfg_h);
  endfunction

  function void start_of_simulation_phase(uvm_phase phase);
   	uvm_report_info(my_name,"start of simulation");
    
    //set_global_timeout(`GLB_TIMEOUT);
  endfunction
   
endclass
