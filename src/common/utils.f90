module Utils
    implicit none
    private

    ! Public procedures
    public :: print_grid

contains

    ! Print a grid in a readable format
    subroutine print_grid(grid)
        integer, dimension(:,:), intent(in) :: grid
        integer :: i, j, n

        n = size(grid, 1)
        do i = 1, n
            do j = 1, n
                write(*, '(A, I1, A)', advance='no') '| ', grid(i,j), ' '
            end do
            write(*, '(A)') '|'
        end do
    end subroutine print_grid

end module Utils 