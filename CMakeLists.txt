cmake_minimum_required(VERSION 3.10)
project(SpaceFillingCurvesSudokuSolver Fortran)

# Set Fortran compiler flags
set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -Wall -Wextra -pedantic")
set(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -g -fcheck=all")
set(CMAKE_Fortran_FLAGS_RELEASE "${CMAKE_Fortran_FLAGS_RELEASE} -O3")

# Add source directories
add_subdirectory(src/common)
add_subdirectory(src/test)

# Enable testing
enable_testing() 