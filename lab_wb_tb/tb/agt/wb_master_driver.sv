class wb_master_driver #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends wb_master_driver_base #(REQ,RSP);

   `uvm_component_param_utils(wb_master_driver #(REQ,RSP))
   
   
   string my_name;
   wb_cfg wb_cfg_h;

   virtual interface wb_if wb_vif;
   virtual interface clk_rst_if clk_rst_vif;

   function new (string name, uvm_component parent);
      super.new(name, parent);
      my_name = name;
   endfunction

   virtual function void connect_phase (uvm_phase phase);
      uvm_object  tmp_obj_hdl;
      
      super.connect_phase(phase);
      my_name = get_name();

      if ( !uvm_config_db #(virtual wb_if)::get(this, "", "WB_VIF", wb_vif) )
      begin
         `uvm_error(my_name, "could not retrieve virtual wb_inf"); 
      end

      assert( uvm_resource_db #(wb_cfg)::read_by_name(get_full_name(), "WB_CFG", wb_cfg_h) );

   endfunction

   virtual task run_phase(uvm_phase phase);
      `uvm_info(my_name,"starting...",UVM_NONE)
      $display("------------------------------------------------------------------------------------------------------------------------------------------------------------");

      if ( !uvm_config_db #( virtual clk_rst_if)::get(this, "", "CLK_RST_VIF", clk_rst_vif) )
      begin
         `uvm_error(my_name, "could not retrieve virtual clk_rst_if");
      end

      if ( !uvm_config_db #(wb_cfg)::get(this, "", "WB_CFG", wb_cfg_h) ) 
      begin 
         `uvm_error(my_name, "could not retrieve virtual wb_cfg_h");
      end

      get_and_drive();
   endtask

   task get_and_drive;
      string msg;
   
      REQ req_pkt;
      RSP rsp_pkt;
      integer rsp_pkt_cnt = 0;

      uvm_report_info(my_name, "starting get_and_drive");
      $display("------------------------------------------------------------------------------------------------------------------------------------------------------------");

      forever @(posedge wb_vif.clk_i)
      begin 
         `uvm_info(my_name,"driver get the tlm from sequencer",UVM_NONE)
         $display("------------------------------------------------------------------------------------------------------------------------------------------------------------");
         
         seq_item_port.get_next_item(req_pkt);
         if (req_pkt.to_reset == 1)
         begin
            clk_rst_vif.do_reset(5);
            uvm_report_info(my_name, "reset assertion");
            $display("------------------------------------------------------------------------------------------------------------------------------------------------------------");
         end 
         else if (req_pkt.do_wait == 1)
         begin 
            clk_rst_vif.do_wait(req_pkt.num_wait);
         end 
         else begin 
            if(req_pkt.we == 1) wb_write(req_pkt);
            else wb_read(req_pkt);
            cov_port.write(req_pkt);   
         end
         rsp_pkt_cnt++;
         rsp_pkt = RSP::type_id::create($psprintf("rsp_pkt_id_%d", rsp_pkt_cnt) );
         $display("------------------------------------------------------------------------------------------------------------------------------------------------------------");
         rsp_pkt.set_id_info(req_pkt);
         rsp_pkt.copy(req_pkt);
         rsp_pkt.addr = wb_vif.adr_i;
         seq_item_port.item_done(rsp_pkt);
      end 
   endtask

   task wb_write(REQ req_pkt);
      `uvm_info(my_name, $psprintf("WB write to addr=0x%h wdata=0x%h",req_pkt.addr,req_pkt.dat_in), UVM_NONE)
      $display("------------------------------------------------------------------------------------------------------------------------------------------------------------");
      fork
         begin 
            @(posedge wb_vif.clk_i);
            wb_vif.stb_i = req_pkt.stb;
            wb_vif.cyc_i = req_pkt.cyc;

            for(int ii=0; ii<(wb_cfg_h.DWIDTH)/8; ii++) begin
               wb_vif.sel_i[ii] = req_pkt.sel[ ( (wb_cfg_h.DWIDTH) /8) -1 - ii];
            end

            wb_vif.we_i  = req_pkt.we;
            wb_vif.adr_i = req_pkt.addr;

            for(int ii=0; ii<req_pkt.sel; ii++) begin
               wb_vif.dat_i[ii*(wb_cfg_h.DWIDTH) +: wb_cfg_h.DWIDTH] = req_pkt.dat_in[(req_pkt.sel - 1 - ii)*(wb_cfg_h.DWIDTH) +: (wb_cfg_h.DWIDTH)];
            end

            do @(posedge wb_vif.clk_i);
            while(!wb_vif.ack_o);
            wb_drv_to_agt_port.write(req_pkt);
            `uvm_info(my_name,"sending ref data to scoreboard",UVM_NONE);
            $display("------------------------------------------------------------------------------------------------------------------------------------------------------------");
         end
         begin
            repeat(10) @(posedge wb_vif.clk_i);
            `uvm_error(my_name, "time out during wishbone write")
            $display("------------------------------------------------------------------------------------------------------------------------------------------------------------");
         end 
      join_any
      disable fork;
   endtask

   task wb_read(REQ req_pkt);
      `uvm_info(my_name, "excuting WB read", UVM_NONE)
      $display("------------------------------------------------------------------------------------------------------------------------------------------------------------");
      fork
         begin
            @(posedge wb_vif.clk_i);
            wb_vif.stb_i = req_pkt.stb;
            wb_vif.cyc_i = req_pkt.cyc;

            for(int ii=0; ii<(wb_cfg_h.DWIDTH)/8; ii++) begin
               wb_vif.sel_i[ii] = req_pkt.sel[ ( (wb_cfg_h.DWIDTH) /8) -1 - ii];
            end

            wb_vif.we_i  = req_pkt.we;
            wb_vif.adr_i = req_pkt.addr;
            req_pkt.dat_out = wb_vif.dat_o;
            do @(posedge wb_vif.clk_i);
            while(wb_vif.ack_o != 1'b1);
            `uvm_info(my_name, $psprintf("WB read from addr=%h  data out=%h",wb_vif.adr_i,wb_vif.dat_o), UVM_NONE)
            $display("------------------------------------------------------------------------------------------------------------------------------------------------------------");
         end 
         begin 
            repeat(10) @(posedge wb_vif.clk);
            `uvm_error(my_name, "time out during read")
            $display("------------------------------------------------------------------------------------------------------------------------------------------------------------");
         end
      join_any
      disable fork;
   endtask

endclass
