program test_grid_interface
    use GridInterface
    implicit none

    type(Grid) :: test_grid
    type(RowMajorGrid) :: test_row_major
    integer :: i, j, idx
    logical :: test_passed

    ! Initialize test grid with example values
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

    ! Print original grid
    print *, "Original Grid:"
    do i = 1, GRID_SIZE
        print "(9(I2,1X))", (test_grid%cells(i,j), j=1,GRID_SIZE)
    end do
    print *

    ! Test 1: Convert grid to row-major and back
    test_row_major = test_grid%to_row_major()
    
    ! Print row-major format (as a single row)
    print *, "Row-Major Format (1 x 81):"
    print "(81(I2,1X))", (test_row_major%cells(i), i=1,GRID_SIZE*GRID_SIZE)
    print *

    test_grid = test_row_major%to_grid()

    ! Print converted back grid
    print *, "Grid after conversion back:"
    do i = 1, GRID_SIZE
        print "(9(I2,1X))", (test_grid%cells(i,j), j=1,GRID_SIZE)
    end do
    print *

    ! Verify the conversion
    test_passed = .true.
    do i = 1, GRID_SIZE
        do j = 1, GRID_SIZE
            idx = (i-1)*GRID_SIZE + j
            if (test_grid%cells(i, j) /= test_row_major%cells(idx)) then
                test_passed = .false.
                print *, "Test failed at position (", i, ",", j, ")"
            end if
        end do
    end do

    if (test_passed) then
        print *, "Test 1: Grid to row-major conversion passed"
    else
        print *, "Test 1: Grid to row-major conversion failed"
    end if

    ! Test 2: Check grid validity
    if (test_grid%is_valid()) then
        print *, "Test 2: Grid validity check passed"
    else
        print *, "Test 2: Grid validity check failed"
    end if

end program test_grid_interface 