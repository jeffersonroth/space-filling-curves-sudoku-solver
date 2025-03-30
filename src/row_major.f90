module row_major

    implicit none
    private

    ! Public interface
    public :: string_to_matrix

contains

    !> Converts a row-major string format to a 9x9 matrix.
    subroutine string_to_matrix(input_string, output_matrix)
        implicit none
        character(len=81), intent(in) :: input_string
        integer, dimension(9, 9), intent(out) :: output_matrix
        integer :: i, j, k
      
        k = 1
        do i = 1, 9
          do j = 1, 9
            read(input_string(k:k), '(i1)') output_matrix(i, j)
            k = k + 1
          end do
        end do
      
      end subroutine string_to_matrix

end module row_major