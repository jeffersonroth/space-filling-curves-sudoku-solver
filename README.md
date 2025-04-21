# Space-Filling Curves Sudoku Solver

A Fortran implementation of a Sudoku solver using space-filling curves for grid traversal.

## Project Structure

```
.
├── src/
│   ├── common/          # Common utilities and interfaces
│   └── test/            # Test programs
├── build/               # Build directory (created during build)
└── docs/                # Documentation
```

## Prerequisites

- CMake (version 3.10 or higher)
- GNU Fortran compiler (gfortran)
- Make

## Building the Project

The project uses CMake for building and includes a Makefile for convenience. To build and run the tests:

```bash
# Build and run tests
make test

# Clean build directory
make clean

# Rebuild everything
make rebuild
```

### Available Make Commands

- `make` - Build the project
- `make test` - Build and run tests
- `make clean` - Remove build directory
- `make rebuild` - Clean and rebuild project
- `make help` - Show available commands

## Running Tests

The test suite includes:

- Grid interface tests
- Space-filling curve traversal tests
- Sudoku solving tests

To run all tests:
```bash
make test
```

## Development

### Code Style

The project follows modern Fortran best practices:
- Uses free-form Fortran (.f90)
- Implements IMPLICIT NONE
- Uses modules for code organization
- Follows consistent naming conventions

### Adding New Features

1. Create new source files in the appropriate directory
2. Update CMakeLists.txt if adding new source files
3. Add tests for new functionality
4. Build and test using `make test`

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Conventions

The character `0` refers to empty cells.

Grid:

* BL - Bottom-left
* ML - Middle-left
* TL - Top-left
* TM - Top-middle
* MM - Middle-middle
* BM - Bottom-middle
* BR - Bottom-right
* MR - Middle-right
* TR - Top-right

Order:

* `raw-major`: TL, TM, TR, ML, MM, MR, BL, BM, BR
* `peano`: BL, ML, TL, TM, MM, BM, BR, MR, TR

A puzzle represented in the standard `row-major` format:

```
467100805912835607085647192296351470708920351531408926073064510624519783159783064
```

Corresponds to the following Sudoku grid:

```
| 4 | 6 | 7 | 1 | 0 | 0 | 8 | 0 | 5 |
| 9 | 1 | 2 | 8 | 3 | 5 | 6 | 0 | 7 |
| 0 | 8 | 5 | 6 | 4 | 7 | 1 | 9 | 2 |
| 2 | 9 | 6 | 3 | 5 | 1 | 4 | 7 | 0 |
| 7 | 0 | 8 | 9 | 2 | 0 | 3 | 5 | 1 |
| 5 | 3 | 1 | 4 | 0 | 8 | 9 | 2 | 6 |
| 0 | 7 | 3 | 0 | 6 | 4 | 5 | 1 | 0 |
| 6 | 2 | 4 | 5 | 1 | 9 | 7 | 8 | 3 |
| 1 | 5 | 9 | 7 | 8 | 3 | 0 | 6 | 4 |
```

This same puzzle is represented in the `peano` as:

```
160725943186903572094618527186430057108025394057816493075186430610752934168009275
```

## Program: Row-Major to Peano Format

Fortran program that converts row-major puzzle format to peano format.

Run:

```bash
    make run_row_major_to_peano INPUT='467100805912835607085647192296351470708920351531408926073064510624519783159783064'
```

Expected result:

```
    160725943186903572094618527186430057108025394057816493075186430610752934168009275
```

## Program: Sudoku Solver

Fortran program that solves sudoku puzzles from peano-formatted input strings.

Run:

```bash
    make run_sudoku_solver INPUT='467100805912835607085647192296351470708920351531408926073064510624519783159783064'
```

Expected result:

```
    168725943186943572394618527186439257168725394257816493275186439618752934168349275
```