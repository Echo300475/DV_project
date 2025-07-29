class wb_cfg extends uvm_object;

  `uvm_object_utils(wb_cfg)

  localparam DWIDTH = 8;
  localparam AWIDTH = 16;
  string my_name;

  bit [DWIDTH-1:0] ref_ram [bit [AWIDTH-1:0]];
  //
  rand bit [AWIDTH-1:0] temp_address;
  rand bit [DWIDTH-1:0] data_in;
  bit is_active;
  bit inject_error;
  bit to_reset;
  bit do_wait;
  integer num_wait;
  integer clk_cnt_ss;
  integer num_loop;
  //
  //event sample_e;
  semaphore sem;
  
  function new(string name="");
    super.new(name);
    my_name = name;
    //
    sem = new();
  endfunction

  function void do_print(uvm_printer printer);
    printer.print_field("address",temp_address,$bits(temp_address));
    printer.print_field("is_active",is_active,$bits(is_active));
    printer.print_field("inject_error",inject_error,$bits(inject_error));
  endfunction

  function void set_loop;
    num_loop = $urandom_range(1,65536);
  endfunction

  constraint default_config {
    inject_error == 0;
  }

endclass
