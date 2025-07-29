package wb_test_pkg;

  import uvm_pkg::*;
  import wb_env_pkg::*;
  import wb_cfg_pkg::*;
  import wb_tlm_pkg::*;
  import wb_seq_pkg::*;

  `include "uvm_macros.svh"
  `include "wb_base_test.sv"
  // another test
  `include "wb_single_wr_rd_test.sv"
  `include "wb_block_wr_rd_test.sv"

endpackage
