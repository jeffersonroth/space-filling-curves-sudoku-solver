module grid

    implicit none
    private

    ! Public interface
    public :: matrix_to_string

contains

    !> Extracts a 3x3 subgrid from a 9x9 matrix based on the provided label.
    subroutine get_subgrid(input_matrix, output_matrix, subgrid_label)
        implicit none
        integer, dimension(9, 9), intent(in) :: input_matrix
        integer, dimension(3, 3), intent(out) :: output_matrix
        character(len=*), intent(in) :: subgrid_label

        integer :: row_start, col_start
        integer :: i, j

        select case (trim(subgrid_label))
        case ("TL")
            row_start = 1
            col_start = 1
        case ("TM")
            row_start = 1
            col_start = 4
        case ("TR")
            row_start = 1
            col_start = 7
        case ("ML")
            row_start = 4
            col_start = 1
        case ("MM")
            row_start = 4
            col_start = 4
        case ("MR")
            row_start = 4
            col_start = 7
        case ("BL")
            row_start = 7
            col_start = 1
        case ("BM")
            row_start = 7
            col_start = 4
        case ("BR")
            row_start = 7
            col_start = 7
        case default
            print *, "Error: Invalid subgrid label: ", trim(subgrid_label)
            return
        end select

        ! Extract the 3x3 subgrid
        do i = 1, 3
            do j = 1, 3
                output_matrix(i, j) = input_matrix(row_start + i - 1, col_start + j - 1)
            end do
        end do

    end subroutine get_subgrid

    !> Converts a 3x3 subgrid to a 1x9 matrix based on the provided label. The output is already in Peano order.
    subroutine subgrid_to_matrix(input_subgrid, output_matrix, subgrid_label)
        implicit none
        integer, dimension(3, 3), intent(in) :: input_subgrid
        integer, dimension(9), intent(out) :: output_matrix
        character(len=*), intent(in) :: subgrid_label

        integer :: k, i
        integer, dimension(9, 2) :: s1, s2, s3, s4

        ! Define the orderings
        ! Shape 1 Order (s1): (3,1), (2,1), (1,1), (1,2), (2,2), (3,2), (3,3), (2,3), (1,3)
        data s1 / 3, 2, 1, 1, 2, 3, 3, 2, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3 /
        ! Shape 2 Order (s2): (3,3), (2,3), (1,3), (1,2), (2,2), (3,2), (3,1), (2,1), (1,1)
        data s2 / 3, 2, 1, 1, 2, 3, 3, 2, 1, 3, 3, 3, 2, 2, 2, 1, 1, 1 /
        ! Shape 3 Order (s3): (1,1), (2,1), (3,1), (3,2), (2,2), (1,2), (1,3), (2,3), (3,3)
        data s3 / 1, 2, 3, 3, 2, 1, 1, 2, 3, 1, 1, 1, 2, 2, 2, 3, 3, 3 /
        ! Shape 4 Order (s4): (1,3), (2,3), (3,3), (3,2), (2,2), (1,2), (1,1), (2,1), (3,1)
        data s4 / 1, 2, 3, 3, 2, 1, 1, 2, 3, 3, 3, 3, 2, 2, 2, 1, 1, 1 /

        k = 1
        ! print *, "Label:", trim(subgrid_label)
        select case (trim(subgrid_label))
        case ("BL", "TL", "BR", "TR") ! Uses s1
            do i = 1, 9
                output_matrix(k) = input_subgrid(s1(i, 1), s1(i, 2))
                ! print *, "i:", i, "s1(i, 1):", s1(i, 1), "s1(i, 2):", s1(i, 2), "value:", input_subgrid(s1(i, 1), s1(i, 2))
                k = k + 1
            end do
        case ("ML", "MR") ! Uses s2
            do i = 1, 9
                output_matrix(k) = input_subgrid(s2(i, 1), s2(i, 2))
                k = k + 1
            end do
        case ("TM", "BM") ! Uses s3
            do i = 1, 9
                output_matrix(k) = input_subgrid(s3(i, 1), s3(i, 2))
                k = k + 1
            end do
        case ("MM") ! Uses s4
            do i = 1, 9
                output_matrix(k) = input_subgrid(s4(i, 1), s4(i, 2))
                k = k + 1
            end do
        case default
            print *, "Error: Invalid subgrid label for conversion: ", trim(subgrid_label)
        end select

    end subroutine subgrid_to_matrix

    !> Converts a 9x9 integer matrix to an 81-character string representing the subgrids in the order: BL, ML, TL, TM, MM, BM, BR, MR, TR.
    subroutine matrix_to_string(input_matrix, local_output_string) ! Renamed intent(out) variable
        implicit none
        integer, dimension(9, 9), intent(in) :: input_matrix
        character(len=81), intent(out) :: local_output_string ! Renamed intent(out) variable

        integer, dimension(3, 3) :: subgrid_3x3
        integer, dimension(9) :: subgrid_1x9
        character(len=9) :: subgrid_char
        integer :: i, j
        character(len=2), dimension(9) :: labels
        character(len=81) :: output_string ! Local variable for building the string

        labels(1) = "BL"
        labels(2) = "ML"
        labels(3) = "TL"
        labels(4) = "TM"
        labels(5) = "MM"
        labels(6) = "BM"
        labels(7) = "BR"
        labels(8) = "MR"
        labels(9) = "TR"

        output_string = ""
        j = 1

        do i = 1, size(labels)
            ! print *, "Processing label: ", trim(labels(i))
            ! Extract the subgrid
            call get_subgrid(input_matrix, subgrid_3x3, labels(i))
            ! print *, "Extracted subgrid:"
            ! do j = 1, 3
            !     write(*, '(3i1)') subgrid_3x3(j, :)
            ! end do

            ! Convert the subgrid to a 1x9 matrix
            call subgrid_to_matrix(subgrid_3x3, subgrid_1x9, labels(i))
            ! print *, "Subgrid as 1x9 matrix:", subgrid_1x9

            ! Convert the 1x9 integer matrix to a 9-character string
            write(subgrid_char, '(9(I1))') subgrid_1x9
            ! print *, "Subgrid as character string:", subgrid_char

            ! Append the subgrid string to the output string
            output_string = trim(output_string) // trim(subgrid_char) ! Added trim for safety
            ! print *, "Current output_string:", trim(output_string)
        end do

        local_output_string = trim(output_string) ! Assign the built string to the intent(out) variable

    end subroutine matrix_to_string

end module grid