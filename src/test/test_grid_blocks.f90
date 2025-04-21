module GridBlocksTest
    use GridInterface, only: Grid, GRID_SIZE
    use GridBlocks, only: Block, get_block, set_block, is_block_valid
    implicit none
    private

    public :: test_grid_blocks

contains
    subroutine test_grid_blocks()
        type(Grid) :: test_grid
        type(Block) :: block
        integer :: i, j, block_row, block_col
        logical :: is_valid
        integer, dimension(3,3) :: actual_block
        integer, dimension(3,3,3,3) :: expected_blocks

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

        ! Define expected blocks in 3x3 format
        ! Bottom row
        expected_blocks(3,1,:,:) = reshape([ &  ! BL
            0, 7, 3, &
            6, 2, 4, &
            1, 5, 9  &
        ], [3,3])  ! BL

        expected_blocks(3,2,:,:) = reshape([ &  ! BM
            0, 6, 4, &
            5, 1, 9, &
            7, 8, 3  &
        ], [3,3])  ! BM

        expected_blocks(3,3,:,:) = reshape([ &  ! BR
            5, 1, 0, &
            7, 8, 3, &
            0, 6, 4  &
        ], [3,3])  ! BR

        ! Middle row
        expected_blocks(2,1,:,:) = reshape([ &  ! ML
            2, 9, 6, &
            7, 0, 8, &
            5, 3, 1  &
        ], [3,3])  ! ML

        expected_blocks(2,2,:,:) = reshape([ &  ! MM
            3, 5, 1, &
            9, 2, 0, &
            4, 0, 8  &
        ], [3,3])  ! MM

        expected_blocks(2,3,:,:) = reshape([ &  ! MR
            4, 7, 0, &
            3, 5, 1, &
            9, 2, 6  &
        ], [3,3])  ! MR

        ! Top row
        expected_blocks(1,1,:,:) = reshape([ &  ! TL
            4, 6, 7, &
            9, 1, 2, &
            0, 8, 5  &
        ], [3,3])  ! TL

        expected_blocks(1,2,:,:) = reshape([ &  ! TM
            1, 0, 0, &
            8, 3, 5, &
            6, 4, 7  &
        ], [3,3])  ! TM

        expected_blocks(1,3,:,:) = reshape([ &  ! TR
            8, 0, 5, &
            6, 0, 7, &
            1, 9, 2  &
        ], [3,3])  ! TR

        ! Test 1: Verify all blocks
        do block_row = 1, 3
            do block_col = 1, 3
                actual_block = get_block(test_grid, block_row, block_col)
                do i = 1, 3
                    do j = 1, 3
                        if (actual_block(i,j) /= expected_blocks(block_row,block_col,i,j)) then
                            print *, "Test failed: Block mismatch at position (", block_row, ",", block_col, ")"
                            print *, "Expected:", expected_blocks(block_row,block_col,:,:)
                            print *, "Got:", actual_block
                            return
                        end if
                    end do
                end do
            end do
        end do

        ! Test 2: Test block validation
        block%cells = expected_blocks(1,1,:,:)  ! Valid block (values from puzzle)
        is_valid = is_block_valid(block)
        if (.not. is_valid) then
            print *, "Test failed: Valid block incorrectly marked as invalid"
            return
        end if

        ! Test invalid block (value > 9)
        block%cells(1,1) = 10
        is_valid = is_block_valid(block)
        if (is_valid) then
            print *, "Test failed: Invalid block (value > 9) not detected"
            return
        end if

        ! Test invalid block (negative value)
        block%cells(1,1) = -1
        is_valid = is_block_valid(block)
        if (is_valid) then
            print *, "Test failed: Invalid block (negative value) not detected"
            return
        end if

        print *, "All GridBlocks tests passed successfully!"
    end subroutine test_grid_blocks

end module GridBlocksTest

program run_grid_blocks_tests
    use GridBlocksTest, only: test_grid_blocks
    implicit none

    call test_grid_blocks()

end program run_grid_blocks_tests 