module grid2x2_module
    use grid_interface
    implicit none
    private
    public :: Grid2x2

    type, extends(AbstractGrid) :: Grid2x2
        integer :: data(4,4)
    contains
        procedure :: initialize => initialize_2x2
        procedure :: solve => solve_2x2
        procedure :: print_grid => print_2x2
        procedure :: get_size => get_size_2x2
        procedure :: get_data => get_data_2x2
    end type Grid2x2

contains
    subroutine initialize_2x2(this, grid_data)
        class(Grid2x2), intent(inout) :: this
        integer, intent(in) :: grid_data(:,:)
        
        if (size(grid_data, 1) /= 4 .or. size(grid_data, 2) /= 4) then
            error stop "Invalid grid size for 2x2 Sudoku"
        end if
        this%data = grid_data
    end subroutine initialize_2x2

    recursive function solve_2x2(this) result(success)
        class(Grid2x2), intent(inout) :: this
        logical :: success
        integer :: i, j, k
        integer :: row, col
        logical :: found_empty

        success = .true.
        found_empty = .false.

        ! Find empty cell
        do i = 1, 4
            do j = 1, 4
                if (this%data(i,j) == 0) then
                    row = i
                    col = j
                    found_empty = .true.
                    exit
                end if
            end do
            if (found_empty) exit
        end do

        ! If no empty cell found, puzzle is solved
        if (.not. found_empty) return

        ! Try numbers 1-4
        do k = 1, 4
            ! Check if number is valid
            if (is_valid_2x2(this, row, col, k)) then
                this%data(row,col) = k
                if (solve_2x2(this)) then
                    return
                end if
                this%data(row,col) = 0
            end if
        end do

        success = .false.
    end function solve_2x2

    function is_valid_2x2(this, row, col, num) result(valid)
        class(Grid2x2), intent(in) :: this
        integer, intent(in) :: row, col, num
        logical :: valid
        integer :: i, j
        integer :: box_row, box_col

        ! Check row
        do i = 1, 4
            if (this%data(row,i) == num .and. i /= col) then
                valid = .false.
                return
            end if
        end do

        ! Check column
        do i = 1, 4
            if (this%data(i,col) == num .and. i /= row) then
                valid = .false.
                return
            end if
        end do

        ! Check 2x2 box
        box_row = 2 * ((row-1)/2) + 1
        box_col = 2 * ((col-1)/2) + 1
        do i = box_row, box_row+1
            do j = box_col, box_col+1
                if (this%data(i,j) == num .and. (i /= row .or. j /= col)) then
                    valid = .false.
                    return
                end if
            end do
        end do

        valid = .true.
    end function is_valid_2x2

    subroutine print_2x2(this)
        class(Grid2x2), intent(in) :: this
        integer :: i, j

        do i = 1, 4
            do j = 1, 4
                write(*, '(I1, " ")', advance='no') this%data(i,j)
            end do
            write(*,*)
        end do
    end subroutine print_2x2

    function get_size_2x2(this) result(size)
        class(Grid2x2), intent(in) :: this
        integer :: size
        size = 2
        ! Use this to avoid unused dummy argument warning
        associate(dummy => this%data(1,1))
            ! Do nothing, just use the dummy argument
        end associate
    end function get_size_2x2

    function get_data_2x2(this) result(grid_data)
        class(Grid2x2), intent(in) :: this
        integer, allocatable :: grid_data(:,:)
        allocate(grid_data(4,4))
        grid_data = this%data
    end function get_data_2x2

end module grid2x2_module 