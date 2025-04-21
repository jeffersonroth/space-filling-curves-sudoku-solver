# Add test executables
add_executable(test_grid_interface
    test_grid_interface.f90
)

add_executable(test_grid_blocks
    test_grid_blocks.f90
)

# Link with common library
target_link_libraries(test_grid_interface
    PRIVATE
    common
)

target_link_libraries(test_grid_blocks
    PRIVATE
    common
)

# Add tests
add_test(NAME test_grid_interface
    COMMAND test_grid_interface
)

add_test(NAME test_grid_blocks
    COMMAND test_grid_blocks
)

add_executable(test_format_conversions test_format_conversions.f90)
target_link_libraries(test_format_conversions common) 