class uvm_wb_queue #(type REQ = uvm_sequence_item) extends uvm_subscriber #(REQ);

   `uvm_component_param_utils(uvm_wb_queue #(REQ))

   string my_name;

   REQ q[$];
   event trigger_e;

   function new(string name, uvm_component parent);
      super.new(name,parent);
   endfunction

   function integer get_size;
      return q.size();
   endfunction

   function check_data();
       bit has_data;
       if(q.size() == 0) has_data = 0;
       else has_data = 1; 
   endfunction

   function REQ get_next_tlm();
      if(q.size() == 0) get_next_tlm = null;
      else get_next_tlm = q.pop_back();
   endfunction
   
   function void write(input REQ t);
      q.push_front(t);
      ->trigger_e;
   endfunction

endclass