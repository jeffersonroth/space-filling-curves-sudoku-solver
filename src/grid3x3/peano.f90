module peano
    use grid
    implicit none
    private

    ! Public interface
    public :: solve

contains

    subroutine solve_cell(index, input_matrix, output_matrix)
        implicit none
        integer, intent(in) :: index ! Array's index.
        integer, dimension(81), intent(in) :: input_matrix ! Output Peano array.
        integer, dimension(81), intent(out) :: output_matrix ! Output Peano array.

        output_matrix = input_matrix

        if (output_matrix(index) == 0) then 
            ! logic here
        end if


    end subroutine solve_cell

    subroutine solve(input_string, output_string)
        implicit none
        character(len=81), intent(in) :: input_string ! Assume already in peano format.
        character(len=81), intent(out) :: output_string ! Output also in peano format, with all 0 solved.
        integer, dimension(9, 9) :: transformed_matrix ! Input peano string input in 9x9 format.
        integer i

        call string_to_matrix(input_string, transformed_matrix)

        print *, "Transformed Matrix:"
        do i = 1, 9
            write(*, '(9i1)') transformed_matrix(i, :)
        end do

        call matrix_to_string(transformed_matrix, output_string)

        do i = 1, 81
            call solve_cell(i, transformed_matrix, transformed_matrix)
        end do

        print *, "Output string:", output_string

    end subroutine solve

end module peano