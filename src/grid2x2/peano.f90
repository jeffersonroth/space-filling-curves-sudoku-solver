module peano
    use grid
    use utils
    implicit none
    private

    public :: solve

contains

    !> Converts a 2x2 subgrid to a 1x4 matrix in Peano order
    subroutine subgrid_to_peano(input_subgrid, output_array, subgrid_label)
        implicit none
        integer, dimension(2, 2), intent(in) :: input_subgrid
        integer, dimension(4), intent(out) :: output_array
        character(len=*), intent(in) :: subgrid_label

        select case (trim(subgrid_label))
        case ("TL")
            ! Top-left subgrid: (1,1), (1,2), (2,2), (2,1)
            output_array(1) = input_subgrid(1,1)
            output_array(2) = input_subgrid(1,2)
            output_array(3) = input_subgrid(2,2)
            output_array(4) = input_subgrid(2,1)
        case ("TR")
            ! Top-right subgrid: (1,1), (2,1), (2,2), (1,2)
            output_array(1) = input_subgrid(1,1)
            output_array(2) = input_subgrid(2,1)
            output_array(3) = input_subgrid(2,2)
            output_array(4) = input_subgrid(1,2)
        case ("BL")
            ! Bottom-left subgrid: (1,1), (1,2), (2,2), (2,1)
            output_array(1) = input_subgrid(1,1)
            output_array(2) = input_subgrid(1,2)
            output_array(3) = input_subgrid(2,2)
            output_array(4) = input_subgrid(2,1)
        case ("BR")
            ! Bottom-right subgrid: (1,1), (2,1), (2,2), (1,2)
            output_array(1) = input_subgrid(1,1)
            output_array(2) = input_subgrid(2,1)
            output_array(3) = input_subgrid(2,2)
            output_array(4) = input_subgrid(1,2)
        case default
            error stop "Invalid subgrid label for 2x2 Peano conversion"
        end select
    end subroutine subgrid_to_peano

    !> Converts a 4x4 matrix to a 16-character string in Peano order
    subroutine matrix_to_peano(input_matrix, output_string)
        implicit none
        integer, dimension(4, 4), intent(in) :: input_matrix
        character(len=16), intent(out) :: output_string

        integer, dimension(2, 2) :: subgrid
        integer, dimension(4) :: peano_array
        character(len=4) :: subgrid_string
        character(len=2), dimension(4) :: labels
        integer :: i

        labels(1) = "TL"
        labels(2) = "TR"
        labels(3) = "BL"
        labels(4) = "BR"

        output_string = ""

        do i = 1, 4
            ! Extract the 2x2 subgrid
            select case (trim(labels(i)))
            case ("TL")
                subgrid = input_matrix(1:2, 1:2)
            case ("TR")
                subgrid = input_matrix(1:2, 3:4)
            case ("BL")
                subgrid = input_matrix(3:4, 1:2)
            case ("BR")
                subgrid = input_matrix(3:4, 3:4)
            end select

            ! Convert to Peano order
            call subgrid_to_peano(subgrid, peano_array, labels(i))

            ! Convert to string
            write(subgrid_string, '(4(I1))') peano_array

            ! Append to output
            output_string = trim(output_string) // trim(subgrid_string)
        end do
    end subroutine matrix_to_peano

    !> Converts a Peano-ordered string to a 4x4 matrix
    subroutine peano_to_matrix(input_string, output_matrix)
        implicit none
        character(len=16), intent(in) :: input_string
        integer, dimension(4, 4), intent(out) :: output_matrix

        integer :: i, j, k
        character(len=2), dimension(4) :: labels
        integer, dimension(4) :: peano_array
        integer, dimension(2, 2) :: subgrid

        labels(1) = "TL"
        labels(2) = "TR"
        labels(3) = "BL"
        labels(4) = "BR"

        k = 1
        do i = 1, 4
            ! Read 4 characters into peano_array
            do j = 1, 4
                read(input_string(k:k), '(I1)') peano_array(j)
                k = k + 1
            end do

            ! Convert Peano array to subgrid
            select case (trim(labels(i)))
            case ("TL")
                output_matrix(1,1) = peano_array(1)
                output_matrix(1,2) = peano_array(2)
                output_matrix(2,2) = peano_array(3)
                output_matrix(2,1) = peano_array(4)
            case ("TR")
                output_matrix(1,3) = peano_array(1)
                output_matrix(2,3) = peano_array(2)
                output_matrix(2,4) = peano_array(3)
                output_matrix(1,4) = peano_array(4)
            case ("BL")
                output_matrix(3,1) = peano_array(1)
                output_matrix(3,2) = peano_array(2)
                output_matrix(4,2) = peano_array(3)
                output_matrix(4,1) = peano_array(4)
            case ("BR")
                output_matrix(3,3) = peano_array(1)
                output_matrix(4,3) = peano_array(2)
                output_matrix(4,4) = peano_array(3)
                output_matrix(3,4) = peano_array(4)
            end select
        end do
    end subroutine peano_to_matrix

    !> Solves a 2x2 Sudoku puzzle using Peano curve ordering
    subroutine solve(input_string, output_string)
        implicit none
        character(len=16), intent(in) :: input_string
        character(len=16), intent(out) :: output_string

        integer, dimension(4, 4) :: matrix
        type(Grid2x2) :: grid
        logical :: success

        ! Convert input string to matrix
        call peano_to_matrix(input_string, matrix)

        ! Initialize and solve the grid
        call grid%initialize(matrix)
        success = grid%solve()

        if (.not. success) then
            error stop "Failed to solve the 2x2 Sudoku puzzle"
        end if

        ! Convert back to Peano-ordered string
        call matrix_to_peano(grid%data, output_string)
    end subroutine solve

end module peano 