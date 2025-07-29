#==========================================================================================
# Author: Van Le
# 
# To run simulation in a sim directory, must set the following:
#   setenv SPI_TB_DIR $home/projects_intel/uvm_tb
#
# To compile for the mux TB:
#   make compile_mux
#
# To run mux demo test:
#    vsim -c top +UVM_TESTNAME=spi_demo_test -do sim.do
#
#==========================================================================================
#
# make must be run where in the same directory as Makefile
#
#
# To override the test name, use the command line argument: test_name=<test_name>
#
test_name = demo_test
cmd_args ?= 
# To run the mux_demo_test with a value of 6 for NUM_WRITE (default value is 4), use
# cmd_args="NUM_WRITE=6"
defines = DEFAULT
TOP = top
VOPT_TOP = vopt_top
VSIM_CMD = vsim -sv_lib uvm_dpi 
VOPT_CMD = vopt +acc ${TOP} -o ${VOPT_TOP} +designfile

#
# To override default values in `define, specify a file name with: 
#         make defines=<file name>
#
ifeq (${defines},DEFAULT)
	VLOG_CMD = vlog 
else
	VLOG_CMD = vlog -f ${defines}
endif

DUT_DIR = $(SPI_TB_DIR)/dut
IF_DIR = $(SPI_TB_DIR)/inf
SPI_IF_DIR = $(SPI_TB_DIR)/inf
TB_DIR  = $(SPI_TB_DIR)/tb
SIM_DIR = $(SPI_TB_DIR)/sim
AGT_MASTER  = $(TB_DIR)/agt/master
AGT_SLAVE  = $(TB_DIR)/agt/slave
TLM_DIR = $(TB_DIR)/tlm
CFG_DIR = $(TB_DIR)/cfg
CHK_DIR = $(TB_DIR)/chk
COV_DIR = $(TB_DIR)/cov
ENV_DIR = $(TB_DIR)/env
TST_DIR = $(TB_DIR)/tst

#compile_spi: udf spi_if dut tlm seq agt chk cov env tst top vopt
compile_spi: spi_if dut tlm cfg seq agt chk env tst top vopt

top:
	${VLOG_CMD} -sv $(ENV_DIR)/top.sv
udf:
	${VLOG_CMD} +incdir+$(ENV_DIR) $(ENV_DIR)/udf_pkg.svh
dut:
	${VLOG_CMD} +incdir+$(DUT_DIR) $(DUT_DIR)/*.v
spi_if:
	${VLOG_CMD} +incdir+$(ENV_DIR) $(SPI_IF_DIR)/clk_rst_if.sv
	${VLOG_CMD} +incdir+$(ENV_DIR) $(SPI_IF_DIR)/apb_if.sv
	${VLOG_CMD} +incdir+$(ENV_DIR) $(SPI_IF_DIR)/spi_if.sv
tlm:
	${VLOG_CMD} +incdir+$(TLM_DIR) +incdir+$(ENV_DIR) $(TLM_DIR)/spi_tlm_pkg.svh
cfg:
	${VLOG_CMD} +incdir+$(CFG_DIR) $(CFG_DIR)/spi_cfg_pkg.svh
seq:
	${VLOG_CMD} +incdir+$(AGT_MASTER)/seq +incdir+$(ENV_DIR) $(AGT_MASTER)/seq/apb_seq_pkg.svh
agt:
	${VLOG_CMD} +incdir+$(AGT_MASTER) +incdir+$(ENV_DIR) $(AGT_MASTER)/apb_agent_pkg.svh
	${VLOG_CMD} +incdir+$(AGT_SLAVE) +incdir+$(ENV_DIR) $(AGT_SLAVE)/apb_slave_agent_pkg.svh
	${VLOG_CMD} +incdir+$(AGT_MASTER) +incdir+$(ENV_DIR) $(AGT_MASTER)/spi_agent_pkg.svh
	${VLOG_CMD} +incdir+$(AGT_SLAVE) +incdir+$(ENV_DIR) $(AGT_SLAVE)/spi_slave_agent_pkg.svh
chk:
	${VLOG_CMD} +incdir+$(TLM_DIR) +incdir+$(ENV_DIR) +incdir+$(CHK_DIR) $(CHK_DIR)/spi_chk_pkg.svh
cov:
	${VLOG_CMD} +incdir+$(COV_DIR) $(COV_DIR)/risc_v_cov_pkg.svh
env:
	${VLOG_CMD} +incdir+$(ENV_DIR) $(ENV_DIR)/spi_env_pkg.svh
tst:
	${VLOG_CMD} +incdir+$(ENV_DIR) +incdir+$(TST_DIR) $(TST_DIR)/spi_test_pkg.svh
vopt:
	${VOPT_CMD}
vopt_run:
	${VSIM_CMD} -c ${VOPT_TOP} -do sim.do +UVM_TESTNAME=${test_name} ${cmd_args}
vopt_random:
	${VSIM_CMD} -sv_seed random -c ${VOPT_TOP} -do sim.do +UVM_TESTNAME=${test_name} ${cmd_args}
vopt_gui:
	${VSIM_CMD} ${VOPT_TOP} +UVM_TESTNAME=${test_name} 
run:
	${VSIM_CMD} -c $(TOP} -do sim.do +UVM_TESTNAME=${test_name}
	
run_override:
	${VSIM_CMD} -c $(TOP} +UVM_TESTNAME=type_override_test
	
coverage:
	${VSIM_CMD} -c -sv_seed random -coverage ${VOPT_TOP} -do cov.do +UVM_TESTNAME=${test_name}
	
wave:
	${VSIM_CMD} -voptargs="+acc" $(TOP} +UVM_TESTNAME=${test_name}

vis_run:
	${VSIM_CMD} -c ${VOPT_TOP} -do sim.do +UVM_TESTNAME=${test_name} +NUM_WRITE=${cmd_args} -qwavedb=+signal+class

clean:
	rm -rf  *.wlf *.ucdb transcript work design.*

tar:
	rm -rf  *.wlf log transcript work
	tar cvf ../uvm_tb.tar ../*
	
