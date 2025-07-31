//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
// This class provides coverage for the REQ transactions. 
// To view coverage data, use the command
//    vsim -viewcov <filename>.ucdb
//***************************************************************************************************************
class spi_cov #(type REQ = uvm_sequence_item) extends uvm_component;

  `uvm_component_param_utils(spi_cov #(REQ))

  string   my_name;

  uvm_analysis_imp #(REQ,spi_cov) ap_imp;

  bit outbound_chk;
 
  //
  // covergroup is a user-defined construct. It can be declared outside or inside a class declaration.
  // Declaring it inside a class makes the code easier to read.
  // Here we are interested in monitoring coverage of the address and transaction types for all tlm transactions.
  //
  covergroup spi_cov_grp;
    //
    // Declare coverpoint for address. Coverage is divided into bins where each bin represents a range 
    // of values that the address falls into.
    //
    outbound_cov: coverpoint outbound_chk {
      bins out_chk = {1};
    }
  endgroup
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
    spi_cov_grp = new;  // can't do this in build
  endfunction
 
  function void build;
    super.build();
    my_name = get_name();
    ap_imp = new("ap_imp",this);
  endfunction

  function void write(REQ cov_pkt);
  endfunction
  
  task run;
  endtask
  
endclass
