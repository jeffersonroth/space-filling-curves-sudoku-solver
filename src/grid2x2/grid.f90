module grid
    use grid_interface
    use utils
    implicit none
    private

    type, public, extends(AbstractGrid) :: Grid2x2
        integer, dimension(4, 4) :: data
    contains
        procedure :: initialize => initialize_2x2
        procedure :: solve => solve_2x2
        procedure :: print_grid => print_grid_2x2
        procedure :: get_size => get_size_2x2
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

    function solve_2x2(this) result(success)
        class(Grid2x2), intent(inout) :: this
        logical :: success
        integer :: i, j, k, l, m
        logical :: found
        
        success = .true.
        
        ! Check each cell
        do i = 1, 4
            do j = 1, 4
                if (this%data(i,j) == 0) then
                    ! Try each possible value
                    do k = 1, 4
                        found = .false.
                        
                        ! Check row
                        do l = 1, 4
                            if (this%data(i,l) == k) then
                                found = .true.
                                exit
                            end if
                        end do
                        if (found) cycle
                        
                        ! Check column
                        do l = 1, 4
                            if (this%data(l,j) == k) then
                                found = .true.
                                exit
                            end if
                        end do
                        if (found) cycle
                        
                        ! Check 2x2 subgrid
                        block
                            integer :: subgrid_row, subgrid_col
                            subgrid_row = ((i-1)/2)*2 + 1
                            subgrid_col = ((j-1)/2)*2 + 1
                            do l = 0, 1
                                do m = 0, 1
                                    if (this%data(subgrid_row+l, subgrid_col+m) == k) then
                                        found = .true.
                                        exit
                                    end if
                                end do
                                if (found) exit
                            end do
                        end block
                        
                        if (.not. found) then
                            this%data(i,j) = k
                            if (solve_2x2(this)) return
                            this%data(i,j) = 0
                        end if
                    end do
                    success = .false.
                    return
                end if
            end do
        end do
    end function solve_2x2

    subroutine print_grid_2x2(this)
        class(Grid2x2), intent(in) :: this
        integer :: i
        
        do i = 1, 4
            write(*, '(4i2)') this%data(i,:)
        end do
    end subroutine print_grid_2x2

    function get_size_2x2(this) result(size)
        class(Grid2x2), intent(in) :: this
        integer :: size
        size = 2
    end function get_size_2x2

end module grid 