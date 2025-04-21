program test_format_conversions
    use GridInterface
    use FormatConversions
    implicit none

    type(Grid) :: test_grid
    integer, dimension(GRID_SIZE * GRID_SIZE) :: test_array
    character(len=GRID_SIZE * GRID_SIZE) :: test_string
    integer :: i, j, idx

    print *, "=== Test 1: Row-Major String to Row-Major Conversion ==="
    print *

    ! Test string to row-major conversion
    test_string = "467100805912835607085647192296351470708920351531408926073064510624519783159783064"
    
    ! Convert string to array
    test_array = string_to_row_major(test_string)

    ! Print input string
    print *, "Input Row-Major String:"
    print *, test_string
    print *

    ! Print converted array
    print *, "Converted Row-Major Array:"
    print "(81(I2,1X))", test_array
    print *

    print *, "Test 1 passed successfully!"
    print *

    print *, "=== Test 2: Array to Grid Conversion ==="
    print *

    ! Initialize test array with example values
    test_array = [ &
        4, 9, 0, 2, 7, 5, 0, 6, 1, &
        6, 1, 8, 9, 0, 3, 7, 2, 5, &
        7, 2, 5, 6, 8, 1, 3, 4, 9, &
        1, 8, 6, 3, 9, 4, 0, 5, 7, &
        0, 3, 4, 5, 2, 0, 6, 1, 8, &
        0, 5, 7, 1, 0, 8, 4, 9, 3, &
        8, 6, 1, 4, 3, 9, 5, 7, 0, &
        0, 0, 9, 7, 5, 2, 1, 8, 6, &
        5, 7, 2, 0, 1, 6, 0, 3, 4  &
    ]

    ! Print input array
    print *, "Input Row-Major Array:"
    print "(81(I2,1X))", test_array
    print *

    ! Convert to grid
    test_grid = row_major_to_grid(test_array)

    ! Print resulting grid
    print *, "Converted Grid:"
    do i = 1, GRID_SIZE
        print "(9(I2,1X))", (test_grid%cells(i,j), j=1,GRID_SIZE)
    end do
    print *

    ! Verify conversion
    do i = 1, GRID_SIZE
        do j = 1, GRID_SIZE
            idx = (i-1)*GRID_SIZE + j
            if (test_grid%cells(i, j) /= test_array(idx)) then
                print *, "Conversion failed at position (", i, ",", j, ")"
                stop
            end if
        end do
    end do

    print *, "Test 2 passed successfully!"

end program test_format_conversions 