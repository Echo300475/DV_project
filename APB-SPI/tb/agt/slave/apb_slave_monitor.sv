//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class apb_slave_monitor #(type PKT = uvm_sequence_item) extends uvm_monitor;

  `uvm_component_param_utils(apb_slave_monitor #(PKT))
  
  string   my_name;
	integer  clk_cnt;
	bit [127:0] rx;
	spi_cfg     spi_cfg_h;
	integer irq_cnt;
  
  virtual interface apb_if       vif;
 
  function new(string name, uvm_component parent);
    super.new(name,parent);
    my_name = name;
		irq_cnt = 0;
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  function void connect_phase(uvm_phase phase);
     
    //
    // Getting the interface handle
    //
    if( !uvm_config_db #(virtual apb_if)::get(this,"","APB_VIF",vif) ) begin
      `uvm_error(my_name, "Could not retrieve virtual apb_if");
    end
    assert(uvm_resource_db #(spi_cfg)::read_by_name(get_full_name(),"SPI_CFG",spi_cfg_h)); 
  endfunction
  
  function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
  endfunction

	function void check_phase(uvm_phase phase);
		// Verify irq_cnt
		if (irq_cnt != spi_cfg_h.max_loop) begin
			`uvm_error(my_name,$psprintf("irq_cnt=%0d, max_loop=%0d",irq_cnt,spi_cfg_h.max_loop))
		end
	endfunction
   
	// Monitor the IRQ
	task monitoring_intr();
		forever begin
			@(vif.IRQ);
			if (vif.IRQ == 1) begin
				`uvm_info(my_name,"IRQ is high",UVM_NONE)
				if (spi_cfg_h.bit_ie == 0) begin
					`uvm_error(my_name,"Not expecting IRQ asserted")
				end
				irq_cnt++; // count the number of IRQ assertions
			end else begin
				`uvm_info(my_name,"IRQ is low",UVM_NONE)
			end
		end
  endtask
   
  task run_phase(uvm_phase phase);
		monitoring_intr();
  endtask
   
endclass
