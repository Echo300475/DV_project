class wb_tlm extends uvm_sequence_item;

  `uvm_object_utils(wb_tlm)

  localparam DWIDTH = 8;
  localparam AWIDTH = 16;
  string my_name;

  bit to_reset;
  integer num_loop;

  // data variable
  bit cyc;
  bit stb;
  bit [( (DWIDTH/8) - 1 ):0] sel;
  bit we;
  bit [AWIDTH-1:0] addr;
  bit [DWIDTH-1:0] dat_in;
  bit [DWIDTH-1:0] dat_out;
  bit ack;
  bit err;
  bit rty;
  //
  integer num_wait;
  bit do_wait;

  function new(string name = "wb_tlm");
    super.new(name);
    my_name = name;
    to_reset = 0;
  endfunction

  function void do_copy(uvm_object rhs);
    wb_tlm der_type;
    super.do_copy(rhs);
    $cast(der_type, rhs);
    cyc = der_type.cyc;
    stb = der_type.stb;
    sel = der_type.sel;
    we = der_type.we;
    addr = der_type.addr;
    dat_in = der_type.dat_in;
    dat_out = der_type.dat_out;
    ack = der_type.ack;
    err = der_type.err;
  endfunction 

  virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    wb_tlm der_type;
    do_compare = super.do_compare(rhs,comparer);
    $cast(der_type,rhs);
    do_compare &= comparer.compare_field_int("cyc",cyc,der_type.cyc,1);
    do_compare &= comparer.compare_field_int("stb",stb,der_type.stb,1);
    do_compare &= comparer.compare_field_int("sel",sel,der_type.sel,1);
    do_compare &= comparer.compare_field_int("we",we,der_type.we,1);
    do_compare &= comparer.compare_field_int("addr",addr,der_type.addr,AWIDTH);
    do_compare &= comparer.compare_field_int("dat_in",dat_in,der_type.dat_in,DWIDTH);
    do_compare &= comparer.compare_field_int("dat_out",dat_out,der_type.dat_out,DWIDTH);
    do_compare &= comparer.compare_field_int("ack",ack,der_type.ack,1);
    do_compare &= comparer.compare_field_int("err",err,der_type.err,1);
    do_compare &= comparer.compare_field_int("rty",rty,der_type.rty,1);
  endfunction

  function void do_print(uvm_printer printer);
    printer.print_field("addr",addr,$bits(addr));
    printer.print_field("dat_in",dat_in,$bits(dat_in));
    printer.print_field("dat_out",dat_out,$bits(dat_out));
  endfunction

  function string convert2string();
    convert2string = $psprintf("addr=%x dat_in=%x dat_out=%x",addr,dat_in,dat_out);
  endfunction

  constraint wb_c {
    to_reset == 0;
  }

endclass
