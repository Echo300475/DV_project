//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//
//***************************************************************************************************************
class spi_agent #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_agent;

   `uvm_component_param_utils(spi_agent #(REQ,RSP))
   
   typedef spi_driver #(REQ,RSP) spi_driver_t;
   //typedef apb_monitor #(REQ) apb_monitor_t;
   typedef uvm_sequencer #(REQ,RSP) spi_sequencer_t;
   
   string   my_name;
   
   spi_sequencer_t  sequencer;
   spi_driver_t      driver ;
   //apb_monitor_t    monitor;
  
   uvm_analysis_port #(sb_tlm) ref_spi_ap;
  
   function new(string name, uvm_component parent);
      super.new(name,parent);
      my_name = get_name();
   endfunction
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      sequencer = spi_sequencer_t::type_id::create("spi_sequencer",this);
      driver = spi_driver_t::type_id::create("spi_driver",this);
      //monitor = apb_monitor_t::type_id::create("apb_monitor",this);
      ref_spi_ap = new($psprintf("%s_ref_spi_ap",my_name),this);
   endfunction
   
   function void connect;
      //monitor.ref_port.connect(ref_port);
      driver.ref_spi_ap.connect(ref_spi_ap);
      //
      // Connect the sequencer to the driver
      //
      driver.seq_item_port.connect(sequencer.seq_item_export);
   endfunction
   
   task run;
    
   endtask
   
endclass
