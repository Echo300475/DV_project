//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class apb_driver #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends apb_driver_base #(REQ,RSP);

  `uvm_component_param_utils(apb_driver #(REQ,RSP))

  string   my_name;
  spi_cfg  spi_cfg_h;
  
  virtual interface apb_if vif;
  virtual interface clk_rst_if clk_rst_vif;
 
  function new(string name, uvm_component parent);
     super.new(name,parent);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    uvm_object           tmp_obj_hdl;
 
    super.connect_phase(phase);
    my_name = get_name();
    //
    // Getting the interface handle via get_config_object call
    //
    if( !uvm_config_db #(virtual apb_if)::get(this,"","APB_VIF",vif) ) begin
       `uvm_error(my_name, "Could not retrieve virtual apb_if");
    end
		assert(uvm_resource_db #(spi_cfg)::read_by_name(get_full_name(),"SPI_CFG",spi_cfg_h));

  endfunction
 
  virtual task run_phase(uvm_phase phase);
    uvm_report_info(my_name,"Running ...",UVM_MEDIUM);
    if( !uvm_config_db #(virtual clk_rst_if)::get(this,"","CLK_RST_VIF",clk_rst_vif) ) begin
      `uvm_error(my_name, "Could not retrieve virtual clk_rst_if");
    end     
    if( !uvm_config_db #(spi_cfg)::get(this,"","SPI_CFG",spi_cfg_h) ) begin
      `uvm_error(my_name, "Could not retrieve virtual spi_cfg_h");
    end     
    get_and_drive();
  endtask

	task deselect;
		vif.PENABLE = 1'b0;
		vif.PSEL = 1'b0;
	endtask
  
	// Perform writes and reads to APB regs
  task get_and_drive;
    string   msg;
    REQ req_pkt;
    RSP rsp_pkt;
    
    uvm_report_info(my_name,"Starting get_and_drive");
    forever @(posedge vif.clk) begin
      //
      // seq_item_port object is part of the uvm_driver class
      // get_next_item method is part of the interface api between uvm_driver and uvm_sequencer
      //
      seq_item_port.get_next_item(req_pkt); // blocking call
      if (req_pkt.to_reset == 1) begin
      	clk_rst_vif.do_reset(5);
        uvm_report_info(my_name,"I saw reset assertion");
				deselect();
				#1us;
			end else if (req_pkt.do_wait == 1) begin
				clk_rst_vif.do_wait(req_pkt.num_wait);
			end else begin
				if (req_pkt.wr_rd == 1) begin
					apb_write(req_pkt);
				end else begin
					apb_read(req_pkt);
				end
		  end
      
      rsp_pkt_cnt++;
      rsp_pkt = RSP::type_id::create($psprintf("rsp_pkt_id_%d",rsp_pkt_cnt));
      rsp_pkt.set_id_info(req_pkt);
      rsp_pkt.copy(req_pkt);
		rsp_pkt.addr = vif.PADDR;
      seq_item_port.item_done(rsp_pkt);
    end
  endtask

	// Write to APB regs
	task apb_write(REQ req_pkt);
		`uvm_info(my_name,$psprintf("APB write to addr=%0x wdata=%0x",req_pkt.addr,req_pkt.wdata),UVM_NONE)
		fork
			begin
				@(negedge vif.clk);
				vif.PADDR = req_pkt.addr;
				vif.PWDATA = req_pkt.wdata;
				vif.PWRITE = 1'b1;
				vif.PENABLE = 1'b1;
				vif.PSEL = 1'b1;
				do @(posedge vif.clk); 
				while (vif.PREADY != 1'b1);
				deselect();
      	apb_write_ap.write(req_pkt); // Send write packet to predictor
			end
			begin
				repeat (10) @(posedge vif.clk);
				`uvm_error(my_name,"Timeout during apb_write")
			end
		join_any
		disable fork;
	endtask

	// Read to APB regs
	task apb_read(REQ req_pkt);
		integer addr_ind;

		`uvm_info(my_name,"Executing apb_read",UVM_NONE)
		fork
			begin
				@(negedge vif.clk);
				vif.PADDR = req_pkt.addr;
				vif.PWRITE = 1'b0;
				vif.PENABLE = 1'b1;
				vif.PSEL = 1'b1;
				do @(posedge vif.clk); 
				while (vif.PREADY != 1'b1);
				addr_ind = req_pkt.addr >> 2;
				req_pkt.rdata = vif.PRDATA & spi_cfg_h.mask_arr[addr_ind];
				`uvm_info(my_name,$psprintf("APB Read addr=%0x rdata=%0x",vif.PADDR,req_pkt.rdata),UVM_NONE)
				deselect();
      	apb_read_ap.write(req_pkt); // Send read packet to predictor
			end
			begin
				repeat (10) @(posedge vif.clk);
				`uvm_error(my_name,"Timeout during apb_read")
			end
		join_any
		disable fork;
	endtask
  
endclass
  
