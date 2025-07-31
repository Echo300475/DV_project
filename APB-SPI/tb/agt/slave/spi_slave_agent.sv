//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//
//***************************************************************************************************************
class spi_slave_agent #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_agent;

   `uvm_component_param_utils(spi_slave_agent #(REQ,RSP))
   
   typedef spi_slave_monitor #(sb_tlm) spi_slave_monitor_t;
   
   string   my_name;
   
   spi_slave_monitor_t    monitor;
  
   uvm_analysis_port #(sb_tlm) act_spi_ap;  // This port is used to send coverage data
  
   function new(string name, uvm_component parent);
      super.new(name,parent);
      my_name = get_name();
		act_spi_ap = new("act_spi_ap",this);
   endfunction
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      monitor = spi_slave_monitor_t::type_id::create("spi_slave_monitor",this);
   endfunction
   
   function void connect;
	 	monitor.act_spi_ap.connect(act_spi_ap);
   endfunction
   
   task run;
    
   endtask
   
endclass
