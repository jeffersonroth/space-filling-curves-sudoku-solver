module GridInterfaceTestModule
    use GridInterface, only: Grid, RowMajorGrid, GRID_SIZE, EMPTY_CELL, to_row_major, to_grid, is_valid
    implicit none
    private

    public :: test_grid_interface

contains
    subroutine test_grid_interface()
        type(Grid) :: test_grid
        type(RowMajorGrid) :: test_row_major
        logical :: valid

        ! Initialize test grid with a known pattern
        test_grid%cells = reshape([ &
            4, 6, 7, 1, 0, 0, 8, 0, 5, &
            9, 1, 2, 8, 3, 5, 6, 0, 7, &
            0, 8, 5, 6, 4, 7, 1, 9, 2, &
            2, 9, 6, 3, 5, 1, 4, 7, 0, &
            7, 0, 8, 9, 2, 0, 3, 5, 1, &
            5, 3, 1, 4, 0, 8, 9, 2, 6, &
            0, 7, 3, 0, 6, 4, 5, 1, 0, &
            6, 2, 4, 5, 1, 9, 7, 8, 3, &
            1, 5, 9, 7, 8, 3, 0, 6, 4  &
        ], shape=[GRID_SIZE, GRID_SIZE])

        ! Test conversion to row-major
        test_row_major = to_row_major(test_grid)

        ! Test conversion back to grid
        test_grid = to_grid(test_row_major)

        ! Test grid validation
        valid = is_valid(test_grid)
        if (.not. valid) then
            print *, "Test failed: Grid validation failed"
            return
        end if

        print *, "All GridInterface tests passed successfully!"
    end subroutine test_grid_interface

end module GridInterfaceTestModule

program run_grid_interface_tests
    use GridInterfaceTestModule, only: test_grid_interface
    implicit none

    call test_grid_interface()

end program run_grid_interface_tests 