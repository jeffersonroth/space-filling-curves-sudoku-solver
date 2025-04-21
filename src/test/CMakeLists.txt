# Add test executable
add_executable(test_grid_interface
    test_grid_interface.f90
)

# Link with common library
target_link_libraries(test_grid_interface
    PRIVATE
    common
)

# Add test
add_test(NAME test_grid_interface
    COMMAND test_grid_interface
)

add_executable(test_format_conversions test_format_conversions.f90)
target_link_libraries(test_format_conversions common) 