//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************

//============================================================================================================================
// Scoreboard responsible for data checking
//============================================================================================================================
class sb #(type REQ = uvm_sequence_item) extends uvm_scoreboard;

  `uvm_component_param_utils(sb #(REQ) )
  
  // todo:
  // Outbound: Change transaction type to sb_tlm
  uvm_tlm_analysis_fifo #(sb_tlm) ref_ap_fifo; // reference data for outbound APB -> SPI
  uvm_tlm_analysis_fifo #(sb_tlm) act_ap_fifo; // actual data for outbound APB -> SPI
  // todo:
  // Inbound: Change transaction type to sb_tlm
  uvm_tlm_analysis_fifo #(sb_tlm) ref_inb_ap_fifo; // reference data for inbound APB <- SPI
  uvm_tlm_analysis_fifo #(sb_tlm) act_inb_ap_fifo; // actual data for inbound APB <- SPI

  string  my_name;
  spi_cfg spi_cfg_h;
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
    my_name = name;
  endfunction
		
  function void build_phase(uvm_phase phase);
    ref_ap_fifo = new("ref_ap_fifo",this);
    act_ap_fifo = new("act_ap_fifo",this);
    ref_inb_ap_fifo = new("ref_inb_ap_fifo",this);
    act_inb_ap_fifo = new("act_inb_ap_fifo",this);
  endfunction

  function void connect_phase(uvm_phase phase);
    if( !uvm_config_db #(spi_cfg)::get(this,"","SPI_CFG",spi_cfg_h) ) begin
       `uvm_error(my_name, "Could not retrieve virtual spi_cfg_h")
    end
  endfunction

  //
  // This task verifies the outbound data.
  // This task monitors the act_ap_fifo to look for an incoming act_pkt by
  // calling act_ap_fifo.get. When an act_pkt is present, the task gets
  // a ref_pkt by calling ref_ap_fifo.get. It then performs a comparison
  // between act_pkt and ref_pkt. If there is a mismatch, it prints
  // a UVM_ERROR message
  //
  task monitor_outbound;
    // todo:
    // update transaction type to sb_tlm
    sb_tlm ref_pkt;
    sb_tlm act_pkt;
    // todo:
    // if you decide to use intermediate variables then change the size to 32
    // otherwise, use pck.data
    bit [31:0] ref_mosi=32'b0;
    bit [31:0] act_mosi=32'b0;

    forever begin
      act_ap_fifo.get(act_pkt);
      `uvm_info(my_name,$psprintf("Received act_pkt mosi = %0x",act_pkt.mosi),UVM_NONE)
      if (ref_ap_fifo.is_empty()) begin
        `uvm_fatal(my_name,"ref_ap_fifo is empty")
      end else begin
	      ref_ap_fifo.get(ref_pkt);
	      ref_mosi = ref_pkt.mosi & spi_cfg_h.mask[31:0];
	      act_mosi = act_pkt.mosi & spi_cfg_h.mask[31:0];
	      if (ref_mosi == act_mosi) begin
	        `uvm_info(my_name,$psprintf("Matched mosi = %0x",ref_mosi),UVM_NONE)
	      end else begin
          `uvm_error(my_name,$psprintf("Mismatched ref mosi = %0x, act mosi = %0x",ref_mosi,act_mosi))
	      end
      end
     end
  endtask

  //
  // This task verifies the inbound data.
  // This task monitors the act_inb_ap_fifo to look for an incoming act_pkt by
  // calling act_inb_ap_fifo.get. When an act_pkt is present, the task gets
  // a ref_pkt by calling ref_inb_ap_fifo.get. It then performs a comparison
  // between act_pkt and ref_pkt. If there is a mismatch, it prints
  // a UVM_ERROR message
  //
  task monitor_inbound;
    // todo:
    // update transaction type to sb_tlm
    sb_tlm ref_pkt;
    sb_tlm act_pkt;
    // todo:
    // if you decide to use intermediate variables then change the size to 32
    // otherwise, use pck.data
    bit [31:0] ref_miso=32'b0;
    bit [31:0] act_miso=32'b0;

    forever begin
      act_inb_ap_fifo.get(act_pkt);
      `uvm_info(my_name,$psprintf("Received act_pkt miso = %x",act_pkt.miso),UVM_NONE)
      if (ref_inb_ap_fifo.is_empty()) begin
         `uvm_fatal(my_name,"ref_ap_fifo is empty")
      end else begin
	       ref_inb_ap_fifo.get(ref_pkt);
	       ref_miso = ref_pkt.miso; // & spi_cfg_h.mask[31:0];
	       act_miso = act_pkt.miso & spi_cfg_h.mask[31:0];
	       if (ref_miso == act_miso) begin
	         `uvm_info(my_name,$psprintf("Matched miso = %0x",ref_miso),UVM_NONE)
	       end else begin
	         `uvm_error(my_name,$psprintf("Mismatched ref miso = %x, act miso = %x",ref_miso,act_miso))
	       end
      end
    end
  endtask

  task run_phase(uvm_phase phase);
    fork
      monitor_outbound();
      monitor_inbound();
    join
  endtask

endclass
