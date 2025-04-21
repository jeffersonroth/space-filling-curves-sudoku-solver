# Create library for common modules
add_library(common
    utils.f90
    grid_interface.f90
    format_conversions.f90
)

# Set include directories
target_include_directories(common
    PUBLIC
    ${CMAKE_CURRENT_BINARY_DIR}  # For .mod files
) 