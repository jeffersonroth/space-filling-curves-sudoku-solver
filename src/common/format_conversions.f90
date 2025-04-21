module FormatConversions
    use GridInterface
    implicit none
    private

    ! Public procedures
    public :: row_major_to_grid, string_to_row_major

contains

    ! Convert row-major array to grid
    function row_major_to_grid(row_major_array) result(grid_result)
        integer, dimension(GRID_SIZE * GRID_SIZE), intent(in) :: row_major_array
        type(Grid) :: grid_result
        integer :: i, j, idx

        ! Convert row-major array to grid
        do i = 1, GRID_SIZE
            do j = 1, GRID_SIZE
                idx = (i-1)*GRID_SIZE + j
                grid_result%cells(i, j) = row_major_array(idx)
            end do
        end do
    end function row_major_to_grid

    ! Convert row-major string to array
    function string_to_row_major(input_string) result(row_major_array)
        character(len=*), intent(in) :: input_string
        integer, dimension(GRID_SIZE * GRID_SIZE) :: row_major_array
        integer :: i, char_value

        ! Convert each character to integer
        do i = 1, GRID_SIZE * GRID_SIZE
            ! Convert character to integer (ASCII '0' = 48)
            char_value = ichar(input_string(i:i)) - 48
            row_major_array(i) = char_value
        end do
    end function string_to_row_major

end module FormatConversions 