class base_seq #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_sequence #(REQ,RSP);

   `uvm_object_param_utils(base_seq #(REQ, RSP) )

   string my_name;
   wb_cfg wb_cfg_h;

   function new(string name="");
      super.new(name);
   endfunction

   task body;
      my_name = get_name();
      assert(uvm_resource_db #(wb_cfg)::read_by_name(get_full_name(), "WB_CFG", wb_cfg_h) );
   endtask

endclass
