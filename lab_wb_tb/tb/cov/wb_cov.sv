class wb_cov #(type REQ = uvm_sequence_item) extends uvm_component;

  `uvm_component_param_utils(wb_cov #(REQ))
  
  localparam AWIDTH = 16;
  string my_name;
  bit [AWIDTH-1:0] cov_addr;

  typedef uvm_wb_queue #(REQ) wb_queue;
  wb_queue cov_queue;

  covergroup wb_cov_grp;
    address_cov: coverpoint cov_addr{
      bins mem_range_1   = {[16'h0000:16'h0fff]};
      bins mem_range_2   = {[16'h1000:16'h1fff]};
      bins mem_range_3   = {[16'h2000:16'h2fff]};
      bins mem_range_4   = {[16'h3000:16'h3fff]};
      bins mem_range_5   = {[16'h4000:16'h4fff]};
      bins mem_range_6   = {[16'h5000:16'h5fff]};
      bins mem_range_7   = {[16'h6000:16'h6fff]};
      bins mem_range_8   = {[16'h7000:16'h7fff]};
      bins mem_range_9   = {[16'h8000:16'h8fff]};
      bins mem_range_10  = {[16'h9000:16'h9fff]};
      bins mem_range_11  = {[16'ha000:16'hafff]};
      bins mem_range_12  = {[16'hb000:16'hbfff]};
      bins mem_range_13  = {[16'hc000:16'hcfff]};
      bins mem_range_14  = {[16'hd000:16'hdfff]};
      bins mem_range_15  = {[16'he000:16'hefff]};
      bins mem_range_16  = {[16'hf000:16'hffff]};
    }
  endgroup

  function new(string name, uvm_component parent);
    super.new(name,parent);
    wb_cov_grp = new;
  endfunction

  function void build;
    super.build();
    my_name = get_name();
    cov_queue = wb_queue::type_id::create($psprintf("%s_cov_queue",my_name),this);
  endfunction

  constraint wb_address {
      cov_addr dist {
         [16'h0000:16'h0fff] :/ 1,
         [16'h1000:16'h1fff] :/ 1,
         [16'h2000:16'h2fff] :/ 1,
         [16'h3000:16'h3fff] :/ 1,
         [16'h4000:16'h4fff] :/ 1,
         [16'h5000:16'h5fff] :/ 1,
         [16'h6000:16'h6fff] :/ 1,
         [16'h7000:16'h7fff] :/ 1,
         [16'h8000:16'h8fff] :/ 1,
         [16'h9000:16'h9fff] :/ 1,
         [16'ha000:16'hafff] :/ 1,
         [16'hb000:16'hbfff] :/ 1,
         [16'hc000:16'hcfff] :/ 1,
         [16'hd000:16'hdfff] :/ 1,
         [16'he000:16'hefff] :/ 1,
         [16'hf000:16'hffff] :/ 1
      };
  }

  task run;
    REQ cov_pkt;

    forever @(cov_queue.trigger_e) begin
       $display("-------------------------------------------------------------------------------------------------------------------------------------------");
       `uvm_info(my_name,"packet received for address coverage",UVM_NONE)
       $display("-------------------------------------------------------------------------------------------------------------------------------------------");
       cov_pkt = cov_queue.get_next_tlm();
       $display("-------------------------------------------------------------------------------------------------------------------------------------------");
       uvm_report_info(my_name,$psprintf("address=0x%h",cov_pkt.addr));
       $display("-------------------------------------------------------------------------------------------------------------------------------------------");
       cov_addr = cov_pkt.addr;
       wb_cov_grp.sample();
    end
  endtask

endclass
