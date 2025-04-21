program row_major_to_hilbert
    use utils
    use grid2x2_module
    implicit none

    character(len=:), allocatable :: input_string, output_string
    integer, dimension(:,:), allocatable :: grid

    ! Read input from command line
    if (command_argument_count() /= 1) then
        print *, "Usage: row_major_to_hilbert <input_string>"
        print *, "  input_string: row-major string representation of a 2x2 grid"
        stop
    end if

    ! Get input string
    call get_command_argument(1, input_string)

    ! Convert string to grid and then to Hilbert curve
    grid = convert_string_to_grid(input_string, 2)
    output_string = convert_grid_to_hilbert(grid, 2)

    ! Write output
    print *, trim(output_string)
end program row_major_to_hilbert 