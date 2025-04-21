program row_major_to_peano
    use utils
    use grid3x3_module
    implicit none

    character(len=:), allocatable :: input_string, output_string
    integer, dimension(:,:), allocatable :: grid
    integer :: arg_length, iostat

    ! Read input from command line
    if (command_argument_count() /= 1) then
        print *, "Usage: row_major_to_peano <input_string>"
        print *, "  input_string: row-major string representation of a 3x3 grid"
        stop
    end if

    ! Get length of input string
    call get_command_argument(1, length=arg_length)
    
    ! Allocate and get input string
    allocate(character(len=arg_length) :: input_string)
    call get_command_argument(1, input_string, status=iostat)
    if (iostat /= 0) then
        print *, "Error reading input string"
        stop
    end if

    ! Check input string length
    if (len_trim(input_string) /= 81) then
        print *, "Error: Input string must be exactly 81 characters long"
        print *, "Got string of length:", len_trim(input_string)
        stop
    end if

    ! Convert string to grid
    allocate(grid(9,9))
    grid = convert_string_to_grid(input_string, 3)

    ! Convert grid to Peano curve
    output_string = convert_grid_to_peano(grid, 3)

    ! Write output using formatted print
    print '(A)', trim(output_string)

    deallocate(input_string)
    deallocate(grid)
end program row_major_to_peano