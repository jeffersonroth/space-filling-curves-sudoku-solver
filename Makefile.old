# Makefile for compiling and running Fortran programs in the repository

# Compiler
FC = gfortran

# Compiler flags
FFLAGS = -Wall -Wextra -pedantic -fimplicit-none -Jbuild

# Directories
SRCDIR = src
COMMONDIR = $(SRCDIR)/common
GRID3X3DIR = $(SRCDIR)/grid3x3
GRID2X2DIR = $(SRCDIR)/grid2x2
MAINDIR = $(SRCDIR)/main
TESTDIR = $(SRCDIR)/tests
BUILDDIR = build

# Create build directory if it doesn't exist
$(shell mkdir -p $(BUILDDIR))

# Common module sources
COMMON_SOURCES = $(COMMONDIR)/utils.f90 $(COMMONDIR)/grid_interface.f90

# Grid-specific module sources
GRID3X3_SOURCES = $(GRID3X3DIR)/grid.f90
GRID2X2_SOURCES = $(GRID2X2DIR)/grid.f90

# Main program sources
MAIN_SOURCES = $(MAINDIR)/sudoku_solver.f90 $(MAINDIR)/row_major_to_peano.f90 $(MAINDIR)/row_major_to_hilbert.f90

# Test sources
TEST_SOURCES = $(TESTDIR)/test_2x2.f90 $(TESTDIR)/test_3x3.f90 $(TESTDIR)/test_utils.f90

# Object files
COMMON_OBJECTS = $(patsubst $(COMMONDIR)/%.f90,$(BUILDDIR)/%.o,$(COMMON_SOURCES))
GRID3X3_OBJECTS = $(patsubst $(GRID3X3DIR)/%.f90,$(BUILDDIR)/grid3x3.o,$(GRID3X3_SOURCES))
GRID2X2_OBJECTS = $(patsubst $(GRID2X2DIR)/%.f90,$(BUILDDIR)/grid2x2.o,$(GRID2X2_SOURCES))
MAIN_OBJECTS = $(patsubst $(MAINDIR)/%.f90,$(BUILDDIR)/%.o,$(MAIN_SOURCES))
TEST_OBJECTS = $(patsubst $(TESTDIR)/%.f90,$(BUILDDIR)/%.o,$(TEST_SOURCES))

# Module files
MODULE_FILES = $(BUILDDIR)/*.mod

# Executables
EXECUTABLES = $(BUILDDIR)/sudoku_solver.exe $(BUILDDIR)/row_major_to_peano.exe $(BUILDDIR)/row_major_to_hilbert.exe
TEST_EXECUTABLES = $(BUILDDIR)/test_2x2.exe $(BUILDDIR)/test_3x3.exe

# Default target
all: $(EXECUTABLES) $(TEST_EXECUTABLES)

# Compile common modules first
$(BUILDDIR)/utils.o: $(COMMONDIR)/utils.f90 | $(BUILDDIR)
	$(FC) $(FFLAGS) -c $< -o $@

$(BUILDDIR)/grid_interface.o: $(COMMONDIR)/grid_interface.f90 $(BUILDDIR)/utils.o | $(BUILDDIR)
	$(FC) $(FFLAGS) -c $< -o $@

# Compile grid modules
$(BUILDDIR)/grid3x3.o: $(GRID3X3DIR)/grid.f90 $(COMMON_OBJECTS) | $(BUILDDIR)
	$(FC) $(FFLAGS) -c $< -o $@

$(BUILDDIR)/grid2x2.o: $(GRID2X2DIR)/grid.f90 $(COMMON_OBJECTS) | $(BUILDDIR)
	$(FC) $(FFLAGS) -c $< -o $@

# Compile main programs
$(BUILDDIR)/sudoku_solver.o: $(MAINDIR)/sudoku_solver.f90 $(COMMON_OBJECTS) $(GRID3X3_OBJECTS) $(GRID2X2_OBJECTS) | $(BUILDDIR)
	$(FC) $(FFLAGS) -c $< -o $@

$(BUILDDIR)/row_major_to_peano.o: $(MAINDIR)/row_major_to_peano.f90 $(COMMON_OBJECTS) $(GRID3X3_OBJECTS) | $(BUILDDIR)
	$(FC) $(FFLAGS) -c $< -o $@

$(BUILDDIR)/row_major_to_hilbert.o: $(MAINDIR)/row_major_to_hilbert.f90 $(COMMON_OBJECTS) $(GRID2X2_OBJECTS) | $(BUILDDIR)
	$(FC) $(FFLAGS) -c $< -o $@

# Compile test programs
$(BUILDDIR)/test_utils.o: $(TESTDIR)/test_utils.f90 $(COMMON_OBJECTS) $(GRID3X3_OBJECTS) $(GRID2X2_OBJECTS) | $(BUILDDIR)
	$(FC) $(FFLAGS) -c $< -o $@

$(BUILDDIR)/test_2x2.o: $(TESTDIR)/test_2x2.f90 $(BUILDDIR)/test_utils.o | $(BUILDDIR)
	$(FC) $(FFLAGS) -c $< -o $@

$(BUILDDIR)/test_3x3.o: $(TESTDIR)/test_3x3.f90 $(BUILDDIR)/test_utils.o | $(BUILDDIR)
	$(FC) $(FFLAGS) -c $< -o $@

# Link executables
$(BUILDDIR)/sudoku_solver.exe: $(BUILDDIR)/sudoku_solver.o $(COMMON_OBJECTS) $(GRID3X3_OBJECTS) $(GRID2X2_OBJECTS)
	$(FC) $(FFLAGS) $^ -o $@

$(BUILDDIR)/row_major_to_peano.exe: $(BUILDDIR)/row_major_to_peano.o $(COMMON_OBJECTS) $(GRID3X3_OBJECTS)
	$(FC) $(FFLAGS) $^ -o $@

$(BUILDDIR)/row_major_to_hilbert.exe: $(BUILDDIR)/row_major_to_hilbert.o $(COMMON_OBJECTS) $(GRID2X2_OBJECTS)
	$(FC) $(FFLAGS) $^ -o $@

$(BUILDDIR)/test_2x2.exe: $(BUILDDIR)/test_2x2.o $(BUILDDIR)/test_utils.o $(COMMON_OBJECTS) $(GRID3X3_OBJECTS) $(GRID2X2_OBJECTS)
	$(FC) $(FFLAGS) $^ -o $@

$(BUILDDIR)/test_3x3.exe: $(BUILDDIR)/test_3x3.o $(BUILDDIR)/test_utils.o $(COMMON_OBJECTS) $(GRID3X3_OBJECTS) $(GRID2X2_OBJECTS)
	$(FC) $(FFLAGS) $^ -o $@

# Run targets
run_row_major_to_peano: $(BUILDDIR)/row_major_to_peano.exe
	@echo "Running the row_major_to_peano program (for 3x3 grids):"
	@echo "Usage: make run_row_major_to_peano INPUT='<sudoku_string>'"
	@if [ -n "$(INPUT)" ]; then \
		$(BUILDDIR)/row_major_to_peano.exe "$(INPUT)"; \
	else \
		echo "Error: Please provide INPUT (81 characters for 3x3 grid)"; \
	fi

run_row_major_to_hilbert: $(BUILDDIR)/row_major_to_hilbert.exe
	@echo "Running the row_major_to_hilbert program (for 2x2 grids):"
	@echo "Usage: make run_row_major_to_hilbert INPUT='<sudoku_string>'"
	@if [ -n "$(INPUT)" ]; then \
		$(BUILDDIR)/row_major_to_hilbert.exe "$(INPUT)"; \
	else \
		echo "Error: Please provide INPUT (16 characters for 2x2 grid)"; \
	fi

run_sudoku_solver: $(BUILDDIR)/sudoku_solver.exe
	@echo "Running the sudoku_solver program:"
	@echo "Usage: make run_sudoku_solver INPUT='<sudoku_string>' GRID_SIZE=<2|3>"
	@if [ -n "$(INPUT)" ] && [ -n "$(GRID_SIZE)" ]; then \
		$(BUILDDIR)/sudoku_solver.exe "$(GRID_SIZE)" "$(INPUT)"; \
	else \
		echo "Error: Please provide INPUT and GRID_SIZE (2 or 3)"; \
	fi

# Test targets
test: $(TEST_EXECUTABLES)
	@echo "Running all tests..."
	@echo " Testing 2x2 Sudoku Solver and Hilbert Converter"
	@echo " ==========================================="
	@$(BUILDDIR)/test_2x2.exe
	@echo " All 2x2 tests completed"
	@echo " Testing 3x3 Sudoku Solver and Peano Converter"
	@echo " ==========================================="
	@$(BUILDDIR)/test_3x3.exe
	@echo " All 3x3 tests completed"

test_2x2_only: $(BUILDDIR)/test_2x2.exe
	@echo "Running 2x2 tests..."
	@$(BUILDDIR)/test_2x2.exe

test_3x3_only: $(BUILDDIR)/test_3x3.exe
	@echo "Running 3x3 tests..."
	@$(BUILDDIR)/test_3x3.exe

# Clean target
clean:
	rm -rf $(BUILDDIR)

.PHONY: all clean test test_2x2_only test_3x3_only run_row_major_to_peano run_row_major_to_hilbert run_sudoku_solver