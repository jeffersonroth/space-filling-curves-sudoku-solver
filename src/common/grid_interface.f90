module GridInterface
    implicit none
    private

    ! Public types and procedures
    public :: Grid, RowMajorGrid, GRID_SIZE, EMPTY_CELL

    ! Constants
    integer, parameter :: GRID_SIZE = 9
    integer, parameter :: EMPTY_CELL = 0

    ! Grid type definition
    type :: Grid
        integer, dimension(GRID_SIZE, GRID_SIZE) :: cells
    contains
        procedure :: to_row_major
        procedure :: is_valid
    end type Grid

    ! Row-major grid type definition
    type :: RowMajorGrid
        integer, dimension(GRID_SIZE * GRID_SIZE) :: cells
    contains
        procedure :: to_grid
    end type RowMajorGrid

contains

    ! Convert grid to row-major representation
    function to_row_major(this) result(row_major)
        class(Grid), intent(in) :: this
        type(RowMajorGrid) :: row_major
        integer :: i, j, idx

        idx = 1
        do i = 1, GRID_SIZE
            do j = 1, GRID_SIZE
                row_major%cells(idx) = this%cells(i, j)
                idx = idx + 1
            end do
        end do
    end function to_row_major

    ! Convert row-major representation to grid
    function to_grid(this) result(grid_result)
        class(RowMajorGrid), intent(in) :: this
        type(Grid) :: grid_result
        integer :: i, j, idx

        idx = 1
        do i = 1, GRID_SIZE
            do j = 1, GRID_SIZE
                grid_result%cells(i, j) = this%cells(idx)
                idx = idx + 1
            end do
        end do
    end function to_grid

    ! Check if grid is valid (basic checks)
    function is_valid(this) result(valid)
        class(Grid), intent(in) :: this
        logical :: valid
        integer :: i, j

        valid = .true.
        
        ! Check if all values are between 0 and 9
        do i = 1, GRID_SIZE
            do j = 1, GRID_SIZE
                if (this%cells(i, j) < 0 .or. this%cells(i, j) > 9) then
                    valid = .false.
                    return
                end if
            end do
        end do
    end function is_valid

end module GridInterface 