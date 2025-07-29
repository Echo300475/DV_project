//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class spi_tlm extends uvm_sequence_item;

 `uvm_object_utils(spi_tlm)
 
  string   my_name;
  
  rand bit [31:0]  rdata;
  rand bit [31:0]  wdata;
  rand bit [31:0]  addr;
  bit to_reset;
  bit do_wait;
  bit wr_rd;
  integer num_wait;
  rand bit [127:0] miso;
  bit [127:0] mosi;

	// Coverage
	integer max_loop;
  
  function new(string name = "spi_tlm");
    super.new(name);
    my_name = name;
  endfunction
  
  function void do_copy(uvm_object rhs);
    spi_tlm  der_type;
    super.do_copy(rhs);
    $cast(der_type,rhs);
    wdata = der_type.wdata;
    rdata = der_type.rdata;
    addr = der_type.addr;
  endfunction
  
  virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    spi_tlm  der_type;
    do_compare = super.do_compare(rhs,comparer);
    $cast(der_type,rhs);
    do_compare &= comparer.compare_field_int("addr",addr,der_type.addr,32); 
    do_compare &= comparer.compare_field_int("rdata",rdata,der_type.rdata,32); 
  endfunction
  
  function void do_print(uvm_printer printer);
    printer.print_field("addr",addr,$bits(addr));
    printer.print_field("wdata",wdata,$bits(wdata));
    printer.print_field("rdata",rdata,$bits(rdata));
  endfunction
  
  // This is needed for the built-in in-order comparator
  function string convert2string();
    convert2string = $psprintf("addr=%x wdata=%x rdata=%x",addr,wdata,rdata);
  endfunction
 
  constraint spi_c {
    to_reset == 0;
 	}
  
endclass
