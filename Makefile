# Makefile for compiling and running Fortran programs in the repository

# Compiler
FC = gfortran

# Compiler flags (optional, but good practice)
FFLAGS = -Wall -Wextra -pedantic -fimplicit-none

# Source directory
SRCDIR = src

# Executable for row_major_to_peano
ROW_MAJOR_TO_PEANO_EXECUTABLE = row_major_to_peano
ROW_MAJOR_TO_PEANO_PROGRAM_SOURCE = $(SRCDIR)/row_major_to_peano.f90
ROW_MAJOR_TO_PEANO_PROGRAM_OBJECT = $(ROW_MAJOR_TO_PEANO_PROGRAM_SOURCE:.f90=.o)

# Executable for sudoku_solver
SUDOKU_SOLVER_EXECUTABLE = sudoku_solver
SUDOKU_SOLVER_PROGRAM_SOURCE = $(SRCDIR)/sudoku_solver.f90
SUDOKU_SOLVER_PROGRAM_OBJECT = $(SUDOKU_SOLVER_PROGRAM_SOURCE:.f90=.o)

# Module source files
MODULE_SOURCES = $(SRCDIR)/grid.f90 $(SRCDIR)/peano.f90

# Module object files (automatically generated)
MODULE_OBJECTS = $(MODULE_SOURCES:.f90=.o)

# Module files (for cleaning)
MODULE_FILES = $(MODULE_SOURCES:.f90=.mod)

all: $(ROW_MAJOR_TO_PEANO_EXECUTABLE) $(SUDOKU_SOLVER_EXECUTABLE) 

# Rule to compile module source files
%.o: %.f90
	$(FC) $(FFLAGS) -c $< -o $@

# Rule to compile the main program for row_major_to_peano
$(ROW_MAJOR_TO_PEANO_PROGRAM_OBJECT): $(ROW_MAJOR_TO_PEANO_PROGRAM_SOURCE) $(MODULE_OBJECTS)
	$(FC) $(FFLAGS) -c $(ROW_MAJOR_TO_PEANO_PROGRAM_SOURCE) -o $@

# Rule to link the row_major_to_peano executable
$(ROW_MAJOR_TO_PEANO_EXECUTABLE): $(ROW_MAJOR_TO_PEANO_PROGRAM_OBJECT) $(MODULE_OBJECTS)
	$(FC) $(FFLAGS) $(ROW_MAJOR_TO_PEANO_PROGRAM_OBJECT) $(MODULE_OBJECTS) -o $@

# Rule to compile the main program for sudoku_solver
$(SUDOKU_SOLVER_PROGRAM_OBJECT): $(SUDOKU_SOLVER_PROGRAM_SOURCE) $(MODULE_OBJECTS)
	$(FC) $(FFLAGS) -c $(SUDOKU_SOLVER_PROGRAM_SOURCE) -o $@

# Rule to link the sudoku_solver executable
$(SUDOKU_SOLVER_EXECUTABLE): $(SUDOKU_SOLVER_PROGRAM_OBJECT) $(MODULE_OBJECTS)
	$(FC) $(FFLAGS) $(SUDOKU_SOLVER_PROGRAM_OBJECT) $(MODULE_OBJECTS) -o $@

run_row_major_to_peano: $(ROW_MAJOR_TO_PEANO_EXECUTABLE)
	@echo "Running the row_major_to_peano program:"
	@echo "Usage: make run_row_major_to_peano INPUT='<81-digit_sudoku_string>'"
	@echo "Example: make run_row_major_to_peano INPUT='467100805912835607085647192296351470708920351531408926073064510624519783159783064'"
	@echo "Example answer: '160725943186903572094618527186430057108025394057816493075186430610752934168009275'"
	@if [ -n "$(INPUT)" ]; then \
		./$(ROW_MAJOR_TO_PEANO_EXECUTABLE) "$(INPUT)"; \
	else \
		echo "Error: Please provide an 81-digit Sudoku string using INPUT='<string>'"; \
	fi

run_sudoku_solver: $(SUDOKU_SOLVER_EXECUTABLE)
	@echo "Running the sudoku_solver program:"
	@echo "Usage: make sudoku_solver INPUT='<81-digit_sudoku_string>'"
	@echo "Example: make run_sudoku_solver INPUT='467100805912835607085647192296351470708920351531408926073064510624519783159783064'"
	@echo "Example answer: '168725943186943572394618527186439257168725394257816493275186439618752934168349275'"
	@if [ -n "$(INPUT)" ]; then \
		./$(SUDOKU_SOLVER_EXECUTABLE) "$(INPUT)"; \
	else \
		echo "Error: Please provide an 81-digit Sudoku string using INPUT='<string>'"; \
	fi

clean:
	rm -f $(ROW_MAJOR_TO_PEANO_EXECUTABLE) $(SUDOKU_SOLVER_EXECUTABLE) $(MODULE_FILES) $(MODULE_OBJECTS) $(ROW_MAJOR_TO_PEANO_PROGRAM_OBJECT) *.o *.mod *.exe

.PHONY: all clean run_row_major_to_peano run_sudoku_solver