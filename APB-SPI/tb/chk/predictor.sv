
//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
// Predictor responsible for generating a reference packet
//============================================================================================================================
`uvm_analysis_imp_decl(_apb_ap_imp)
`uvm_analysis_imp_decl(_spi_ap_imp)

class predictor extends uvm_component;
  `uvm_component_utils(predictor)

  typedef spi_tlm REQ;
  typedef sb_tlm REQ_SB;
  string  my_name;
  uvm_analysis_imp_apb_ap_imp #(REQ,predictor) apb_ap_imp; // APB writes to Tx regs
  // todo:
  // Outbound: update the packet type to sb_tlm
  uvm_analysis_port #(sb_tlm) ref_apb_ap;
  uvm_analysis_imp_spi_ap_imp #(REQ,predictor) spi_ap_imp; // APB reads of Rx regs
  // todo:
  // Inbound: update the packet type to sb_tlm
  uvm_analysis_port #(sb_tlm) act_spi_ap;
  integer ref_pkt_cnt;
  integer act_pkt_cnt;
  spi_cfg spi_cfg_h;
  bit [127:0] mosi = 0;
  bit [127:0] ref_t = 0;
  bit [127:0] miso = 0;
  bit [127:0] act_t = 0;
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
    my_name = name;
    ref_apb_ap = new("ref_apb_ap",this);
    act_spi_ap = new("act_spi_ap",this);
    reset();
  endfunction

  function void reset;
    `uvm_info(my_name,"Predictor resetting",UVM_NONE)
    ref_pkt_cnt = 0;
    act_pkt_cnt = 0;
    miso = 0;
  endfunction

  function void build_phase(uvm_phase phase);
    apb_ap_imp = new("apb_ap_imp",this);
    spi_ap_imp = new("spi_ap_imp",this);
  endfunction

  function void connect_phase(uvm_phase phase);
    if( !uvm_config_db #(spi_cfg)::get(this,"","SPI_CFG",spi_cfg_h) ) begin
       `uvm_error(my_name, "Could not retrieve virtual spi_cfg_h")
    end
  endfunction

	// ==================================================================================================
	// After performing an APB write to a Tx register, the driver sends the packet here
	// The assumption is the sequence must perform writes to all four Tx registers before starting a
	// new transmission.
	// ==================================================================================================
  function void write_apb_ap_imp(REQ req_pkt);
  // todo:
  // Outbound: update the packet type to sb_tlm
    sb_tlm ref_pkt;

    `uvm_info(my_name,$psprintf("Write to address %0d wdata=%0x",req_pkt.addr,req_pkt.wdata),UVM_NONE)
    case (req_pkt.addr)
      0: mosi[31:0] = req_pkt.wdata;
      4: mosi[63:32] = req_pkt.wdata;
      8: mosi[95:64] = req_pkt.wdata;
      12: mosi[127:96] = req_pkt.wdata; 
    endcase
    ref_pkt_cnt++;
      // todo:
      // Outbound: insert a for loop to write spi_cfg_h.num_dwords out
    
    if (ref_pkt_cnt == 4) begin
       ref_t = mosi & spi_cfg_h.mask[127:0];
       for (int ii=0; ii<spi_cfg_h.num_dwords; ii++) begin
          ref_pkt = sb_tlm::type_id::create($psprintf("ref_pkt_cnt_%d", ii));
          `uvm_info(my_name, $psprintf("assign mosi = %h", ref_t[ii*32 +: 32]),UVM_NONE)
          ref_pkt.mosi = ref_t[ii*32 +: 32];
          ref_apb_ap.write(ref_pkt);
       end
       ref_pkt_cnt = 0;
    end 
  endfunction

	// ==================================================================================================
	// Read num_dwords of Rx regs to generate an actual packet to send to the SB
	// ==================================================================================================
  function void write_spi_ap_imp(REQ req_pkt);
    // todo:
    // Inbound: change transaction type to sb_tlm
    sb_tlm act_pkt;

    `uvm_info(my_name,$psprintf("Read at address %0d rdata=%0x",req_pkt.addr,req_pkt.rdata),UVM_NONE)
    case (req_pkt.addr)
      0: miso[31:0] = req_pkt.rdata;
      4: miso[63:32] = req_pkt.rdata;
      8: miso[95:64] = req_pkt.rdata;
      12: miso[127:96] = req_pkt.rdata;
    endcase
    act_pkt_cnt++;

    if (act_pkt_cnt == spi_cfg_h.num_dwords) begin
      for (int ii=0;ii<spi_cfg_h.num_dwords;ii++) begin
         act_pkt = sb_tlm::type_id::create($psprintf("act_pkt_cnt_%0d", ii));
         `uvm_info(my_name, $psprintf("assign miso = %h",miso[ii*32 +: 32]),UVM_NONE)
         act_pkt.miso = miso[ii*32 +: 32];
         act_spi_ap.write(act_pkt);
      end
      act_pkt_cnt = 0;
    end

  endfunction

	virtual task run_phase(uvm_phase phase);
	endtask

endclass

