SIM_DIR  := sim
DOC_DIR  := docs
SRC_DIR  := rtl
TB_DIR   := tb

# Include directories
INCDIRS := +incdir+../agents/ahb_agent \
           +incdir+../agents/apb_agent \
           +incdir+../tb \
		   +incdir+../tests

# Simulation
TOP  := ahb2apb_testbench
TEST := ahb2apb_test_simple

# Log file (transcript), saved in sim/
LOG  := run.log

# Coverage 
UCDB  := cov.ucdb
COV   := ../$(DOC_DIR)/coverage

# Default target
all: clean run coverage

# Create simulation directory
dirs:
	@mkdir -p $(SIM_DIR)
	@mkdir -p $(DOC_DIR)

# Compile
compile: dirs
	cd $(SIM_DIR) && vlib work
	cd $(SIM_DIR) && vmap work work

	cd $(SIM_DIR) && vlog -sv -work work -cover sbceft ../$(SRC_DIR)/*.v

	cd $(SIM_DIR) && vlog -sv -work work $(INCDIRS) ../agents/ahb_agent/ahb2apb_ahb_pkg.sv
	cd $(SIM_DIR) && vlog -sv -work work $(INCDIRS) ../agents/apb_agent/ahb2apb_apb_pkg.sv

	cd $(SIM_DIR) && vlog -sv -work work $(INCDIRS) ../$(TB_DIR)/ahb2apb_pkg.sv

	cd $(SIM_DIR) && vlog -sv -work work $(INCDIRS) ../tb/$(TOP).sv


# Run simulation
run: compile
	cd $(SIM_DIR) && vsim -c \
		-coverage \
		-voptargs="+acc" \
		-l $(LOG) \
		work.$(TOP) \
		+UVM_TESTNAME=$(TEST) \
		-do "coverage save -onexit $(UCDB); do ../scripts/wave.tcl; run -all; quit -f"


# Coverage reporting
coverage: run
	cd $(SIM_DIR) && vcover report \
		-details \
		-html \
		-output $(COV) \
		$(UCDB)

# Open wavefor
wave:
	cd $(SIM_DIR) && vsim -view vsim.wlf -do ../scripts/wave.tcl

# Clean simulation files
clean:
	@rm -rf $(SIM_DIR)

.PHONY: all dirs compile run coverage wave clean