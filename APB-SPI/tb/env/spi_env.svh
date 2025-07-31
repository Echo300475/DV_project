//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class spi_env #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item, type REQ_SB = uvm_sequence_item) extends uvm_env;

   `uvm_component_param_utils(spi_env #(REQ,RSP))
   
   string my_name;
   
   typedef apb_agent  #(REQ,RSP) apb_agent_t;
   apb_agent_t apb_agent_0;

   typedef apb_slave_agent  #(REQ) apb_slave_agent_t;
   apb_slave_agent_t apb_slave_agent_0;

   typedef spi_agent  #(REQ,RSP) spi_agent_t;
   spi_agent_t spi_agent_0;

   typedef spi_slave_agent  #(REQ) spi_slave_agent_t;
   spi_slave_agent_t spi_slave_agent_0;
   
   predictor predictor_0;
   
   typedef sb  #(REQ) sb_t;
   sb_t sb_0;
   
   function new(string name, uvm_component parent);
      super.new(name,parent);
   endfunction
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      my_name = get_name();
      apb_agent_0 = apb_agent_t::type_id::create("apb_agent_0",this);
      spi_agent_0 = spi_agent_t::type_id::create("spi_agent_0",this);
      spi_slave_agent_0 = spi_slave_agent_t::type_id::create("spi_slave_agent_0",this);
      apb_slave_agent_0 = apb_slave_agent_t::type_id::create("apb_slave_agent_0",this);
      predictor_0 = predictor::type_id::create("predictor_0",this);
      sb_0 = sb_t::type_id::create("sb_0",this);
   endfunction
   
   function void connect_phase(uvm_phase phase);
      apb_agent_0.apb_write_ap.connect(predictor_0.apb_ap_imp);
      apb_agent_0.apb_read_ap.connect(predictor_0.spi_ap_imp);
      
      predictor_0.ref_apb_ap.connect(sb_0.ref_ap_fifo.analysis_export);
      spi_slave_agent_0.act_spi_ap.connect(sb_0.act_ap_fifo.analysis_export);
      spi_agent_0.ref_spi_ap.connect(sb_0.ref_inb_ap_fifo.analysis_export);
      predictor_0.act_spi_ap.connect(sb_0.act_inb_ap_fifo.analysis_export);
   endfunction
   
   task run_phase(uvm_phase phase);
      `uvm_info(my_name,"Running env ...",UVM_MEDIUM);
   endtask
   
   function void extract_phase(uvm_phase phase);
      `uvm_info(my_name,"Extract phase is called",UVM_NONE);
   endfunction
   
   function void check_phase(uvm_phase phase);
      `uvm_info(my_name,"Check phase is called",UVM_NONE);
   endfunction
   
endclass
