# Compiler settings
FORTRAN_COMPILER=/c/msys64/mingw64/bin/gfortran.exe

# Build directory
BUILD_DIR=build

.PHONY: all clean test test_format test_grid test_blocks rebuild

all: $(BUILD_DIR)
	cd $(BUILD_DIR) && cmake -G "MinGW Makefiles" -DCMAKE_Fortran_COMPILER=$(FORTRAN_COMPILER) .. && make

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

test: test_grid test_format test_blocks

test_grid: all
	./$(BUILD_DIR)/src/test/test_grid_interface.exe

test_format: all
	./$(BUILD_DIR)/src/test/test_format_conversions.exe

test_blocks: all
	./$(BUILD_DIR)/src/test/test_grid_blocks.exe

clean:
	rm -rf $(BUILD_DIR)

rebuild: clean all

# Help target
help:
	@echo "Available targets:"
	@echo "  make           - Build the project"
	@echo "  make test      - Build and run all tests"
	@echo "  make test_grid - Build and run grid interface tests"
	@echo "  make test_format - Build and run format conversion tests"
	@echo "  make test_blocks - Build and run grid blocks tests"
	@echo "  make clean     - Remove build directory"
	@echo "  make rebuild   - Clean and rebuild project"
	@echo "  make help      - Show this help message" 