# Makefile for compiling and running Fortran programs in the repository

# Compiler
FC = gfortran

# Compiler flags
FFLAGS = -Wall -Wextra -pedantic -fimplicit-none

# Directories
SRCDIR = src
COMMONDIR = $(SRCDIR)/common
GRID3X3DIR = $(SRCDIR)/grid3x3
GRID2X2DIR = $(SRCDIR)/grid2x2
MAINDIR = $(SRCDIR)/main
BUILDDIR = build

# Create build directory if it doesn't exist
$(shell mkdir -p $(BUILDDIR))

# Common module sources
COMMON_SOURCES = $(COMMONDIR)/grid_interface.f90 $(COMMONDIR)/utils.f90

# Grid-specific module sources
GRID3X3_SOURCES = $(GRID3X3DIR)/grid.f90 $(GRID3X3DIR)/peano.f90
GRID2X2_SOURCES = $(GRID2X2DIR)/grid.f90 $(GRID2X2DIR)/peano.f90

# Main program sources
MAIN_SOURCES = $(MAINDIR)/sudoku_solver.f90 $(MAINDIR)/row_major_to_peano.f90

# Object files
COMMON_OBJECTS = $(patsubst $(COMMONDIR)/%.f90,$(BUILDDIR)/%.o,$(COMMON_SOURCES))
GRID3X3_OBJECTS = $(patsubst $(GRID3X3DIR)/%.f90,$(BUILDDIR)/%.o,$(GRID3X3_SOURCES))
GRID2X2_OBJECTS = $(patsubst $(GRID2X2DIR)/%.f90,$(BUILDDIR)/%.o,$(GRID2X2_SOURCES))
MAIN_OBJECTS = $(patsubst $(MAINDIR)/%.f90,$(BUILDDIR)/%.o,$(MAIN_SOURCES))

# Module files
MODULE_FILES = $(BUILDDIR)/*.mod

# Executables
EXECUTABLES = sudoku_solver row_major_to_peano

# Default target
all: $(EXECUTABLES)

# Rule to compile common modules
$(BUILDDIR)/%.o: $(COMMONDIR)/%.f90
	$(FC) $(FFLAGS) -J$(BUILDDIR) -c $< -o $@

# Rule to compile 3x3 grid modules
$(BUILDDIR)/%.o: $(GRID3X3DIR)/%.f90 $(COMMON_OBJECTS)
	$(FC) $(FFLAGS) -J$(BUILDDIR) -c $< -o $@

# Rule to compile 2x2 grid modules
$(BUILDDIR)/%.o: $(GRID2X2DIR)/%.f90 $(COMMON_OBJECTS)
	$(FC) $(FFLAGS) -J$(BUILDDIR) -c $< -o $@

# Rule to compile main programs
$(BUILDDIR)/%.o: $(MAINDIR)/%.f90 $(COMMON_OBJECTS) $(GRID3X3_OBJECTS) $(GRID2X2_OBJECTS)
	$(FC) $(FFLAGS) -J$(BUILDDIR) -c $< -o $@

# Rule to link executables
sudoku_solver: $(BUILDDIR)/sudoku_solver.o $(COMMON_OBJECTS) $(GRID3X3_OBJECTS) $(GRID2X2_OBJECTS)
	$(FC) $(FFLAGS) $^ -o $@

row_major_to_peano: $(BUILDDIR)/row_major_to_peano.o $(COMMON_OBJECTS) $(GRID3X3_OBJECTS) $(GRID2X2_OBJECTS)
	$(FC) $(FFLAGS) $^ -o $@

# Run targets
run_row_major_to_peano: row_major_to_peano
	@echo "Running the row_major_to_peano program:"
	@echo "Usage: make run_row_major_to_peano INPUT='<sudoku_string>' GRID_SIZE=<2|3>"
	@if [ -n "$(INPUT)" ] && [ -n "$(GRID_SIZE)" ]; then \
		./row_major_to_peano "$(INPUT)" "$(GRID_SIZE)"; \
	else \
		echo "Error: Please provide INPUT and GRID_SIZE (2 or 3)"; \
	fi

run_sudoku_solver: sudoku_solver
	@echo "Running the sudoku_solver program:"
	@echo "Usage: make run_sudoku_solver INPUT='<sudoku_string>' GRID_SIZE=<2|3>"
	@if [ -n "$(INPUT)" ] && [ -n "$(GRID_SIZE)" ]; then \
		./sudoku_solver "$(INPUT)" "$(GRID_SIZE)"; \
	else \
		echo "Error: Please provide INPUT and GRID_SIZE (2 or 3)"; \
	fi

# Clean target
clean:
	rm -f $(EXECUTABLES) $(MODULE_FILES) $(BUILDDIR)/*.o

.PHONY: all clean run_row_major_to_peano run_sudoku_solver