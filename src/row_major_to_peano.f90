program row_major_to_peano
    use row_major
    use grid
    implicit none
    character(len=81) :: input_string ! Input string in row-major format.
    character(len=81) :: output_string ! Output string in peano format.
    integer, dimension(9, 9) :: transformed_matrix ! Input row-major string input in 9x9 format.
    integer :: iargc, i, j
    character(len=256) :: arg_long
    character(len=81) :: arg

    iargc = command_argument_count()

    if (iargc < 1) then
        print *, "Usage: ./row_major_to_peano <81-digit_sudoku_string>"
        stop 1 ! Use non-zero exit code for error
    end if

    call get_command_argument(1, arg_long)
    arg = trim(arg_long) ! Assign trimmed version to arg

    if (len(arg) /= 81) then ! Use len instead of len_trim after trimming
        print *, "Error: Input string must be exactly 81 digits long."
        print *, "Length of input:", len(arg)
        print *, "Input string:", arg
        stop 2 ! Use non-zero exit code for error
    end if

    input_string = arg

    ! print *, "Input string (row-major): ", trim(input_string)

    call string_to_matrix(input_string, transformed_matrix)

    ! print *, "Transformed Matrix:"
    ! do i = 1, 9
    !     write(*, '(9i1)') transformed_matrix(i, :)
    ! end do

    call matrix_to_string(transformed_matrix, output_string)

    ! print *, "Output string (Peano order): ", trim(output_string)

    ! Use formatted print (A specification)
    print '(A)', trim(output_string)

end program row_major_to_peano