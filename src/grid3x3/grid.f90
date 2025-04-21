module grid3x3_module
    use grid_interface
    implicit none
    private
    public :: Grid3x3

    type, extends(AbstractGrid) :: Grid3x3
        integer :: data(9,9)
    contains
        procedure :: initialize => initialize_3x3
        procedure :: solve => solve_3x3
        procedure :: print_grid => print_3x3
        procedure :: get_size => get_size_3x3
        procedure :: get_data => get_data_3x3
    end type Grid3x3

contains
    subroutine initialize_3x3(this, grid_data)
        class(Grid3x3), intent(inout) :: this
        integer, intent(in) :: grid_data(:,:)
        
        if (size(grid_data, 1) /= 9 .or. size(grid_data, 2) /= 9) then
            error stop "Invalid grid size for 3x3 Sudoku"
        end if
        this%data = grid_data
    end subroutine initialize_3x3

    recursive function solve_3x3(this) result(success)
        class(Grid3x3), intent(inout) :: this
        logical :: success
        integer :: i, j, k
        integer :: row, col
        logical :: found_empty

        success = .true.
        found_empty = .false.

        ! Find empty cell
        do i = 1, 9
            do j = 1, 9
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

        ! Try numbers 1-9
        do k = 1, 9
            ! Check if number is valid
            if (is_valid_3x3(this, row, col, k)) then
                this%data(row,col) = k
                if (solve_3x3(this)) then
                    return
                end if
                this%data(row,col) = 0
            end if
        end do

        success = .false.
    end function solve_3x3

    function is_valid_3x3(this, row, col, num) result(valid)
        class(Grid3x3), intent(in) :: this
        integer, intent(in) :: row, col, num
        logical :: valid
        integer :: i, j
        integer :: box_row, box_col

        ! Check row
        do i = 1, 9
            if (this%data(row,i) == num .and. i /= col) then
                valid = .false.
                return
            end if
        end do

        ! Check column
        do i = 1, 9
            if (this%data(i,col) == num .and. i /= row) then
                valid = .false.
                return
            end if
        end do

        ! Check 3x3 box
        box_row = 3 * ((row-1)/3) + 1
        box_col = 3 * ((col-1)/3) + 1
        do i = box_row, box_row+2
            do j = box_col, box_col+2
                if (this%data(i,j) == num .and. (i /= row .or. j /= col)) then
                    valid = .false.
                    return
                end if
            end do
        end do

        valid = .true.
    end function is_valid_3x3

    subroutine print_3x3(this)
        class(Grid3x3), intent(in) :: this
        integer :: i, j

        do i = 1, 9
            do j = 1, 9
                write(*, '(I1, " ")', advance='no') this%data(i,j)
            end do
            write(*,*)
        end do
    end subroutine print_3x3

    function get_size_3x3(this) result(size)
        class(Grid3x3), intent(in) :: this
        integer :: size
        size = 3
        ! Use this to avoid unused dummy argument warning
        associate(dummy => this%data(1,1))
            ! Do nothing, just use the dummy argument
        end associate
    end function get_size_3x3

    function get_data_3x3(this) result(grid_data)
        class(Grid3x3), intent(in) :: this
        integer, allocatable :: grid_data(:,:)
        allocate(grid_data(9,9))
        grid_data = this%data
    end function get_data_3x3

end module grid3x3_module