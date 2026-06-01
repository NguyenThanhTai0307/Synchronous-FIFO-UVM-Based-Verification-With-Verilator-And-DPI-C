# ==============================================================================
# Optimized Makefile for Verilator + UVM + DPI-C Testbench Execution
# ==============================================================================

# --- Variables ---
VERILATOR = verilator
CXX       = ccache g++
RM        = rm -rf

# Directory Paths
UVM_HOME  = /home/thanhtai/Libraries/uvm-verilator
SRC_DIR   = .
BUILD_DIR = obj_dir

# Source Files
UVM_SRC   = $(UVM_HOME)/src/uvm_pkg.sv
FILE_LIST = $(SRC_DIR)/files.f
CPP_SRCS  = $(SRC_DIR)/functional_coverage.cpp \
            $(SRC_DIR)/sim_main.cpp

# Test Suite Definition
# Using ?= allows you to override this variable from the command line
TEST_NAME ?= Base_test
TEST_LIST  = Fill_drain_test Concurrent_rw_test Overflow_underflow_test Randomized_test Reset_stress_test

# --- Verilator Compilation Flags ---
VERILATOR_FLAGS += +incdir+$(SRC_DIR) +incdir+$(UVM_HOME)/src
VERILATOR_FLAGS += +define+UVM_NO_DPI
VERILATOR_FLAGS += --cc --exe --vpi --timing
VERILATOR_FLAGS += --trace
VERILATOR_FLAGS += --coverage --assert                   
VERILATOR_FLAGS += --top-module top --prefix Vtop                      

# [ADDED] Suppress UVM/Verilator warnings and enforce modern SV standard
VERILATOR_FLAGS += --language 1800-2017
VERILATOR_FLAGS += -Wno-fatal -Wno-LITENDIAN -Wno-BLKANDNBLK -Wno-CASTCONST -Wno-WIDTHTRUNC

# Performance optimizations
VERILATOR_FLAGS += --build -j $(shell nproc)
VERILATOR_FLAGS += --threads $(shell nproc)

# C++ Compiler Flags 
CXX_FLAGS = -CFLAGS "-std=c++17 -I$(SRC_DIR)" 

# --- Targets ---
.PHONY: all build run regress wave clean help

# Default Target
all: clean build run                                     

# 1. Verilate and Compile the Testbench
build:
	@echo "================================================================="
	@echo " Preparing Verilator Build Pipeline"
	@echo "================================================================="
	mkdir -p $(BUILD_DIR)
	# Pass the filelist instead of individual SV files
	$(VERILATOR) $(VERILATOR_FLAGS) $(UVM_SRC) -f $(FILE_LIST) $(CPP_SRCS) $(CXX_FLAGS) 

# 2. Run Single Simulation
run:
	@echo "================================================================="
	@echo " Running UVM Test: $(TEST_NAME)"
	@echo "================================================================="
	./$(BUILD_DIR)/Vtop +UVM_TESTNAME=$(TEST_NAME) +uvm_set_verbosity=UVM_MEDIUM

# 3. [ADDED] Run Regression Suite
regress: build
	@echo "================================================================="
	@echo " Running UVM Test Regression Suite"
	@echo "================================================================="
	@for test in $(TEST_LIST); do \
		echo ""; \
		echo "-----------------------------------------------------------------"; \
		echo " EXEC: $$test"; \
		echo "-----------------------------------------------------------------"; \
		./$(BUILD_DIR)/Vtop +UVM_TESTNAME=$$test +uvm_set_verbosity=UVM_LOW; \
	done

# 4. [ADDED] View Waveforms
wave:
	@echo " Opening GTKWave..."
	@gtkwave dump.vcd &

# 5. Clean Build Artifacts
clean:
	@echo " Cleaning previous build artifacts..."
	$(RM) $(BUILD_DIR) *.vcd *.log *.fst coverage.dat

# Help Diagnostic
help:
	@echo "Available targets:"
	@echo "  make build             - Verilate and compile the design, TB, and DPI-C"
	@echo "  make run               - Execute the default test (Base_test)"
	@echo "  make run TEST_NAME=X   - Execute a specific test 'X'"
	@echo "  make regress           - Build and run the entire test regression suite"
	@echo "  make wave              - Open the generated waveform in GTKWave"
	@echo "  make all               - Clean, build, and run the single simulation"
	@echo "  make clean             - Remove all generated artifacts"