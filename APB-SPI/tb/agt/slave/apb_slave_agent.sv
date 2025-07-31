//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//
//***************************************************************************************************************
class apb_slave_agent #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_agent;

   `uvm_component_param_utils(apb_slave_agent #(REQ,RSP))
   
   typedef apb_slave_monitor #(REQ) apb_slave_monitor_t;
   
   string   my_name;
   
   apb_slave_monitor_t    monitor;
  
   //uvm_analysis_port #(REQ) ref_port;  // This port is used to send reference data to the scoreboard
   //uvm_analysis_port #(REQ) act_port;  // This port is used to send actual data to the scoreboard
  
   uvm_analysis_port #(REQ) cov_port;  // This port is used to send coverage data
  
   function new(string name, uvm_component parent);
      super.new(name,parent);
      my_name = get_name();
   endfunction
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      monitor = apb_slave_monitor_t::type_id::create("apb_slave_monitor",this);
   endfunction
   
   function void connect;
   endfunction
   
   task run;
    
   endtask
   
endclass
