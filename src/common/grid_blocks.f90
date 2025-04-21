module GridBlocks
    use GridInterface, only: Grid, GRID_SIZE, EMPTY_CELL
    use, intrinsic :: iso_fortran_env, only: real32
    implicit none
    private

    ! Calculate block size as square root of grid size
    integer, parameter :: BLOCK_SIZE = nint(sqrt(real(GRID_SIZE, real32)))

    ! Block type definition
    type :: Block
        integer, dimension(BLOCK_SIZE, BLOCK_SIZE) :: cells
    end type Block

    ! Public types and procedures
    public :: Block, get_block, set_block, is_block_valid

contains

    ! Get a block from the grid
    function get_block(grid_in, block_row, block_col) result(block)
        type(Grid), intent(in) :: grid_in
        integer, intent(in) :: block_row, block_col
        integer, dimension(BLOCK_SIZE, BLOCK_SIZE) :: block
        integer :: start_row, start_col, i, j

        ! Calculate starting indices
        start_row = (block_row - 1) * BLOCK_SIZE + 1
        start_col = (block_col - 1) * BLOCK_SIZE + 1

        ! Extract the block
        do i = 1, BLOCK_SIZE
            do j = 1, BLOCK_SIZE
                block(i, j) = grid_in%cells(start_row + i - 1, start_col + j - 1)
            end do
        end do
    end function get_block

    ! Set a block in the grid
    subroutine set_block(grid_out, block, block_row, block_col)
        type(Grid), intent(inout) :: grid_out
        integer, dimension(BLOCK_SIZE, BLOCK_SIZE), intent(in) :: block
        integer, intent(in) :: block_row, block_col
        integer :: start_row, start_col, i, j

        ! Calculate starting indices
        start_row = (block_row - 1) * BLOCK_SIZE + 1
        start_col = (block_col - 1) * BLOCK_SIZE + 1

        ! Set the block
        do i = 1, BLOCK_SIZE
            do j = 1, BLOCK_SIZE
                grid_out%cells(start_row + i - 1, start_col + j - 1) = block(i, j)
            end do
        end do
    end subroutine set_block

    ! Check if a block is valid (contains only numbers 0-9)
    function is_block_valid(block_data) result(valid)
        type(Block), intent(in) :: block_data
        logical :: valid
        integer :: i, j

        valid = .true.
        do i = 1, BLOCK_SIZE
            do j = 1, BLOCK_SIZE
                if (block_data%cells(i, j) < EMPTY_CELL .or. block_data%cells(i, j) > GRID_SIZE) then
                    valid = .false.
                    return
                end if
            end do
        end do
    end function is_block_valid

end module GridBlocks 