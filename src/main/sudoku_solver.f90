program sudoku_solver
    use grid_interface
    use grid3x3, only: Grid3x3
    use grid2x2, only: Grid2x2
    use utils
    implicit none
    
    character(len=:), allocatable :: input_string
    character(len=:), allocatable :: output_string
    integer :: grid_size
    integer :: iargc
    character(len=256) :: arg_long
    character(len=:), allocatable :: arg
    class(AbstractGrid), allocatable :: grid

    iargc = command_argument_count()

    if (iargc < 2) then
        print *, "Usage: ./sudoku_solver <sudoku_string> <grid_size>"
        print *, "  grid_size: 2 for 2x2, 3 for 3x3"
        stop 1
    end if

    ! Get grid size
    call get_command_argument(2, arg_long)
    read(arg_long, *) grid_size
    
    if (grid_size /= 2 .and. grid_size /= 3) then
        print *, "Error: Grid size must be 2 or 3"
        stop 2
    end if

    ! Get input string
    call get_command_argument(1, arg_long)
    arg = trim(arg_long)

    ! Validate input string length
    if (grid_size == 2 .and. len(arg) /= 16) then
        print *, "Error: For 2x2 grid, input string must be exactly 16 digits long."
        print *, "Length of input:", len(arg)
        stop 3
    else if (grid_size == 3 .and. len(arg) /= 81) then
        print *, "Error: For 3x3 grid, input string must be exactly 81 digits long."
        print *, "Length of input:", len(arg)
        stop 3
    end if

    ! Allocate strings based on grid size
    if (grid_size == 2) then
        allocate(character(len=16) :: input_string)
        allocate(character(len=16) :: output_string)
        allocate(Grid2x2 :: grid)
    else
        allocate(character(len=81) :: input_string)
        allocate(character(len=81) :: output_string)
        allocate(Grid3x3 :: grid)
    end if

    input_string = arg

    ! Convert string to grid and solve
    select type(grid)
        type is (Grid2x2)
            call grid%initialize(convert_string_to_grid(input_string, 2))
        type is (Grid3x3)
            call grid%initialize(convert_string_to_grid(input_string, 3))
    end select

    if (.not. grid%solve()) then
        print *, "Error: Failed to solve the Sudoku puzzle"
        stop 4
    end if

    ! Convert back to string
    output_string = convert_grid_to_string(grid%data, grid_size)

    ! Print result
    print '(A)', trim(output_string)

    ! Clean up
    deallocate(input_string)
    deallocate(output_string)
    deallocate(grid)

end program sudoku_solver