program test_3x3
    use test_utils
    implicit none
    
    print *, "Testing 3x3 Sudoku Solver and Peano Converter"
    print *, "==========================================="
    
    ! Test the example case
    call run_test("3x3 Example", &
                 "467100805912835607085647192296351470708920351531408926073064510624519783159783064", &
                 "160725943186903572094618527186430057108025394057816493075186430610752934168009275", &
                 3)
    
    print *, "All 3x3 tests completed"
    
end program test_3x3 