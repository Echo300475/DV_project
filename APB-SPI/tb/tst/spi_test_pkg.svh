//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
//***************************************************************************************************************
// The test package provides a test layer between the top module and the environment. More than
// one test can be included here.
//***************************************************************************************************************
package spi_test_pkg;

   import uvm_pkg::*;
   import spi_env_pkg::*;
   import spi_cfg_pkg::*;
   import spi_tlm_pkg::*;
   import apb_seq_pkg::*;
   
   `include "uvm_macros.svh"  
   `include "spi_base_test.sv"
   //
   // All new tests must derive from base_test and must be listed here.
   // Each test is saved as one file
   //
   `include "spi_demo_test.sv"       // single sequence test
endpackage
