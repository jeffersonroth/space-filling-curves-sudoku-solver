module hilbert
    implicit none
    private

    ! Public interface
    public :: convert_grid_to_hilbert

contains

    function convert_grid_to_hilbert(grid, grid_size) result(hilbert_string)
        integer, intent(in) :: grid(:,:)  ! Input grid
        integer, intent(in) :: grid_size  ! Size of the grid (N for NxN)
        character(len=:), allocatable :: hilbert_string

        ! Validate grid size
        if (grid_size /= 2 .and. mod(grid_size, 4) /= 0) then
            print *, "Error: Grid size must be 2 or a multiple of 4"
            print *, "Got grid size:", grid_size
            hilbert_string = ""
            return
        end if

        ! TODO: Implement Hilbert curve conversion
        hilbert_string = ""
    end function convert_grid_to_hilbert

end module hilbert 