program sudoku_solver
    use utils
    use grid_interface
    use grid3x3_module
    use grid2x2_module
    implicit none

    character(len=:), allocatable :: input_string, output_string
    integer :: grid_size
    integer, dimension(:,:), allocatable :: grid
    class(AbstractGrid), allocatable :: sudoku_grid

    ! Read input from command line
    if (command_argument_count() /= 2) then
        print *, "Usage: sudoku_solver <grid_size> <input_string>"
        print *, "  grid_size: 2 for 2x2, 3 for 3x3"
        print *, "  input_string: row-major string representation of the grid"
        stop
    end if

    ! Get grid size
    call get_command_argument(1, input_string)
    read(input_string, *) grid_size

    ! Get input string
    call get_command_argument(2, input_string)

    ! Validate grid size
    if (grid_size /= 2 .and. grid_size /= 3) then
        print *, "Error: grid_size must be 2 or 3"
        stop
    end if

    ! Allocate and initialize grid
    if (grid_size == 2) then
        allocate(Grid2x2 :: sudoku_grid)
    else
        allocate(Grid3x3 :: sudoku_grid)
    end if

    ! Initialize grid with input string
    grid = convert_string_to_grid(input_string, grid_size)
    call sudoku_grid%initialize(grid)

    ! Solve Sudoku
    if (sudoku_grid%solve()) then
        ! Convert solution to appropriate curve format
        grid = sudoku_grid%get_data()
        if (grid_size == 2) then
            output_string = convert_grid_to_hilbert(grid, 2)
        else
            output_string = convert_grid_to_peano(grid, 3)
        end if
        
        ! Write output
        print *, trim(output_string)
    else
        print *, "No solution found"
        stop 1
    end if

    ! Cleanup
    deallocate(sudoku_grid)
    if (allocated(output_string)) deallocate(output_string)
end program sudoku_solver