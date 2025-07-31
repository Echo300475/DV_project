`uvm_analysis_imp_decl(_drv_to_sb)
`uvm_analysis_imp_decl(_mon_to_sb)

class wb_sb #(type REQ = wb_tlm) extends uvm_scoreboard;

  `uvm_component_param_utils(wb_sb #(REQ))

  localparam DWIDTH = 8;
  localparam AWIDTH = 16;
  uvm_analysis_imp_drv_to_sb #(REQ,wb_sb) wb_drv_to_sb_port;
  uvm_analysis_imp_mon_to_sb #(REQ,wb_sb) wb_mon_to_sb_port;

  string my_name;
  wb_cfg wb_cfg_h;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    my_name = name;
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wb_drv_to_sb_port = new($psprintf("%s_wb_drv_to_sb_port", my_name), this);
    wb_mon_to_sb_port = new($psprintf("%s_wb_mon_to_sb_port", my_name), this);
  endfunction

  function void connect_phase(uvm_phase phase);
    if ( !uvm_config_db #(wb_cfg)::get(this,"","WB_CFG",wb_cfg_h) ) 
    begin
      `uvm_error(my_name, "could not retrieve virtual wb_cfg_h") 
    end
  endfunction

  function void write_drv_to_sb(REQ req_pkt);
    if(req_pkt.we) begin
      wb_cfg_h.ref_ram[req_pkt.addr] = req_pkt.dat_in;
      `uvm_info(my_name,$psprintf("ref_data write: addr=0x%0h dat_in=0x%0h",req_pkt.addr,req_pkt.dat_in),UVM_NONE);
      $display("------------------------------------------------------------------------------------------------------------------------------------------------------------");
    end
  endfunction

  function void write_mon_to_sb(REQ req_pkt);
    if(!req_pkt.we)
    begin
      if(wb_cfg_h.ref_ram.exists(req_pkt.addr))
      begin
        if(req_pkt.dat_out == wb_cfg_h.ref_ram[req_pkt.addr]) 
        begin
          `uvm_info(my_name,$psprintf("matched, addr: %h , ref_data: %h , act_data: %h",req_pkt.addr,wb_cfg_h.ref_ram[req_pkt.addr],req_pkt.dat_out),UVM_NONE);
          $display("------------------------------------------------------------------------------------------------------------------------------------------------------------");
        end
        else 
        begin
          `uvm_error(my_name,$psprintf("mismatched, addr: %h , ref_data: %h , act_data: %h",req_pkt.addr,wb_cfg_h.ref_ram[req_pkt.addr],req_pkt.dat_out));
          $display("------------------------------------------------------------------------------------------------------------------------------------------------------------");
        end
      end
      else `uvm_fatal(my_name,$psprintf("no data in ref_ram at addr: 0x%0h",req_pkt.addr));
    end
  endfunction

  task run_phase(uvm_phase phase);
  endtask

endclass
