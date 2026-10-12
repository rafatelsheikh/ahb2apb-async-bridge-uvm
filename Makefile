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
TOP   := ahb2apb_testbench
# list of tests to run
TESTS := ahb2apb_test_same_clk \
		 ahb2apb_test_double_clk \
		 ahb2apb_test_shift_clk \
		 ahb2apb_test_reset_AHB_in_APB_access_phase \
		 ahb2apb_test_req_ack_recovery \
		 ahb2apb_test_apb_pready_idle

SEED  := random

# Per-test targets, logs and coverage databases
RUN_TARGETS := $(addprefix run_,$(TESTS))
TEST_UCDBS  := $(addprefix cov_,$(addsuffix .ucdb,$(TESTS)))

# Log file (transcript) per test, saved in sim/
LOG_PREFIX := run

# Coverage 
UCDB  := cov.ucdb            # merged database
COV   := ../$(DOC_DIR)/coverage
COV_TXT   := ../$(DOC_DIR)/coverage.txt

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


# Run all tests in TESTS (one after another)
run: $(RUN_TARGETS)

# Run a single test: make run_ahb2apb_test_main
$(RUN_TARGETS): run_%: compile
	@echo "Running test $* with seed: $(SEED)"
	cd $(SIM_DIR) && vsim -c \
		-coverage \
		-sv_seed $(SEED) \
		-voptargs="+acc" \
		-l $(LOG_PREFIX)_$*.log \
		-wlf vsim_$*.wlf \
		work.$(TOP) \
		+UVM_TESTNAME=$* \
		-do "do ../scripts/coverage_exclution.tcl; coverage save -onexit cov_$*.ucdb; \
		 do ../scripts/wave.tcl; run -all; quit -f"

# Merge the per-test coverage into one database
merge: run
	cd $(SIM_DIR) && vcover merge -out $(UCDB) $(TEST_UCDBS)

# Coverage reporting (on the merged database)
coverage: merge
	cd $(SIM_DIR) && vcover report \
		-details \
		-html \
		-output $(COV) \
		$(UCDB)

coverage_txt: merge
	cd $(SIM_DIR) && vcover report \
		-details \
		-output $(COV_TXT) \
		$(UCDB)

# Open waveform (pick a test: make wave TEST=ahb2apb_test_main)
TEST ?= $(firstword $(TESTS))
wave:
	cd $(SIM_DIR) && vsim -view vsim_$(TEST).wlf -do ../scripts/wave.tcl

# Clean simulation files
clean:
	@rm -rf $(SIM_DIR)

.PHONY: all dirs compile run merge coverage coverage_txt wave clean $(RUN_TARGETS)