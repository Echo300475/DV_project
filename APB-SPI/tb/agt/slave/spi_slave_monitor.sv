//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class spi_slave_monitor #(type PKT = uvm_sequence_item) extends uvm_monitor;

  `uvm_component_param_utils(spi_slave_monitor #(PKT))
  
  string   my_name;
  integer  clk_cnt;
  bit [127:0] rx;
  integer act_pkt_cnt;
  spi_cfg     spi_cfg_h;
  
  virtual interface spi_if       vif;
  virtual interface clk_rst_if clk_rst_vif;
  // todo:
  // change transaction type to sb_tlm
  uvm_analysis_port #(sb_tlm) act_spi_ap;
 
  function new(string name, uvm_component parent);
    super.new(name,parent);
    my_name = name;
    act_spi_ap = new("act_spi_ap",this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  function void connect_phase(uvm_phase phase);
     
    //
    // Getting the interface handle
    //
    if( !uvm_config_db #(virtual spi_if)::get(this,"","SPI_VIF",vif) ) begin
      `uvm_error(my_name, "Could not retrieve virtual spi_if");
    end
    if( !uvm_config_db #(virtual clk_rst_if)::get(this,"","CLK_RST_VIF",clk_rst_vif) ) begin
      `uvm_error(my_name, "Could not retrieve virtual clk_rst_if");
    end
    assert(uvm_resource_db #(spi_cfg)::read_by_name(get_full_name(),"SPI_CFG",spi_cfg_h)); 
  endfunction
  
  function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
  endfunction

  function void check_phase(uvm_phase phase);
  endfunction
   
	// Monitor and capture SPI data
  task monitoring_data;
    // todo:
    // change transaction type to sb_tlm
    integer ii;
    sb_tlm act_pkt;

    clk_cnt = 0;
    rx = 0;
    act_pkt_cnt = 0;
    @(clk_rst_vif.rst);
    `uvm_info(my_name,"Reset is complete",UVM_NONE)
    forever begin
      if (spi_cfg_h.bit_txneg == 0) begin
    	@(negedge vif.sclk_pad_o);
      end else begin
    	@(posedge vif.sclk_pad_o);
      end
      if (spi_cfg_h.bit_lsb == 1) begin
	     rx[clk_cnt] = vif.mosi_pad_o;
      end else begin
	     rx[spi_cfg_h.num_chars-1-clk_cnt] = vif.mosi_pad_o;
      end

      if (clk_cnt == spi_cfg_h.num_chars-1) begin
        `uvm_info(my_name, $psprintf("spi clk_cnt = %0d, rx = %0x", clk_cnt+1, rx), UVM_NONE)
        for (ii=0; ii<spi_cfg_h.num_dwords; ii++) begin
          act_pkt = sb_tlm::type_id::create($psprintf("act_pkt_0%d", act_pkt_cnt));
          act_pkt.mosi = rx[ii*32 +: 32];
          act_spi_ap.write(act_pkt);
          act_pkt_cnt++;
        end 
        clk_cnt = 0;
        act_pkt_cnt = 0;
        rx = 0;
      end 
      else begin
        clk_cnt++;
      end
    end
  endtask

	// Clear variables when reset is active
  task monitoring_rst;
    forever begin
      @(clk_rst_vif.rst);
      clk_cnt = 0;
      rx = 0;
      act_pkt_cnt = 0;
    end
  endtask

	// Verify that the DUT does not drive any extra SPI clock cycle
  task monitoring_clk_cnt_ss;
    forever begin
      @(posedge vif.sclk_pad_o);
      if (spi_cfg_h.tx_done == 0) begin
        spi_cfg_h.clk_cnt_ss++;
        if (spi_cfg_h.clk_cnt_ss > spi_cfg_h.num_chars) begin
          `uvm_error(my_name,$psprintf("clk_cnt_ss = %0d",spi_cfg_h.clk_cnt_ss))
	end
      end
    end
  endtask

  task run_phase(uvm_phase phase);
    fork
      monitoring_rst();
      monitoring_data();
      monitoring_clk_cnt_ss();
    join
  endtask
   
endclass
