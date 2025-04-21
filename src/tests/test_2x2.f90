program test_2x2
    use test_utils
    implicit none
    
    print *, "Testing 2x2 Sudoku Solver and Peano Converter"
    print *, "==========================================="
    
    ! Test the example case
    call run_test("2x2 Example", &
                 "0102004023000003", &
                 "0032001040200003", &
                 2)
    
    print *, "All 2x2 tests completed"
    
end program test_2x2 