module utils
  implicit none
  private
  
  public :: is_valid_digit, convert_string_to_grid, convert_grid_to_string, convert_grid_to_peano, convert_grid_to_hilbert
  
contains
  
  pure function is_valid_digit(digit, grid_size) result(valid)
    integer, intent(in) :: digit
    integer, intent(in) :: grid_size
    logical :: valid
    
    valid = (digit >= 0 .and. digit <= grid_size**2)
  end function is_valid_digit
  
  function convert_string_to_grid(input_string, grid_size) result(grid)
    character(len=*), intent(in) :: input_string
    integer, intent(in) :: grid_size
    integer, dimension(grid_size**2, grid_size**2) :: grid
    integer :: i, j, pos
    
    do i = 1, grid_size**2
      do j = 1, grid_size**2
        pos = (i-1)*grid_size**2 + j
        read(input_string(pos:pos), '(I1)') grid(i,j)
      end do
    end do
  end function convert_string_to_grid
  
  function convert_grid_to_string(grid, grid_size) result(output_string)
    integer, dimension(grid_size**2, grid_size**2), intent(in) :: grid
    integer, intent(in) :: grid_size
    character(len=grid_size**4) :: output_string
    integer :: i, j, pos
    
    do i = 1, grid_size**2
      do j = 1, grid_size**2
        pos = (i-1)*grid_size**2 + j
        write(output_string(pos:pos), '(I1)') grid(i,j)
      end do
    end do
  end function convert_grid_to_string
  
  function convert_grid_to_hilbert(grid, grid_size) result(hilbert_string)
    integer, intent(in) :: grid(:,:)
    integer, intent(in) :: grid_size
    character(len=:), allocatable :: hilbert_string
    integer :: i
    integer :: total_size
    integer, dimension(16,2) :: hilbert_coords
    
    total_size = grid_size * grid_size * grid_size * grid_size
    allocate(character(len=total_size) :: hilbert_string)
    hilbert_string = repeat(' ', total_size)
    
    if (grid_size == 2) then
        ! Define the Hilbert curve traversal for 2x2 grid
        ! Starting from bottom left, rotated 180 degrees
        ! Format: [row, col] for each point in sequence
        
        ! BL -> BR -> TR -> TL (starting from bottom left)
        hilbert_coords(1:4,:) = reshape([4,1, 4,2, 3,2, 3,1], [4,2])
        
        ! Apply the mapping
        do i = 1, 4
            write(hilbert_string(i:i), '(I1)') grid(hilbert_coords(i,1), hilbert_coords(i,2))
        end do
    else
        ! Hilbert curve is only implemented for 2x2 grids
        hilbert_string = ""
    end if
  end function convert_grid_to_hilbert
  
  function convert_grid_to_peano(grid, grid_size) result(peano_string)
    integer, intent(in) :: grid(:,:)
    integer, intent(in) :: grid_size
    character(len=:), allocatable :: peano_string
    integer :: i, j, k
    integer :: total_size
    integer :: row_start, col_start
    integer :: current_pos
    integer, dimension(9,2) :: s1, s2, s3, s4
    character(len=2), dimension(9) :: labels
    integer, dimension(3,3) :: subgrid
    integer, dimension(9) :: subgrid_1x9
    character(len=9) :: subgrid_char
    
    total_size = grid_size * grid_size * grid_size * grid_size
    allocate(character(len=total_size) :: peano_string)
    peano_string = repeat(' ', total_size)
    
    if (grid_size == 3) then
        ! Define the subgrid traversal patterns exactly as in the original implementation
        ! Shape 1 Order (s1): (3,1), (2,1), (1,1), (1,2), (2,2), (3,2), (3,3), (2,3), (1,3)
        s1 = reshape([3,1, 2,1, 1,1, 1,2, 2,2, 3,2, 3,3, 2,3, 1,3], [9,2])
        ! Shape 2 Order (s2): (3,3), (2,3), (1,3), (1,2), (2,2), (3,2), (3,1), (2,1), (1,1)
        s2 = reshape([3,3, 2,3, 1,3, 1,2, 2,2, 3,2, 3,1, 2,1, 1,1], [9,2])
        ! Shape 3 Order (s3): (1,1), (2,1), (3,1), (3,2), (2,2), (1,2), (1,3), (2,3), (3,3)
        s3 = reshape([1,1, 2,1, 3,1, 3,2, 2,2, 1,2, 1,3, 2,3, 3,3], [9,2])
        ! Shape 4 Order (s4): (1,3), (2,3), (3,3), (3,2), (2,2), (1,2), (1,1), (2,1), (3,1)
        s4 = reshape([1,3, 2,3, 3,3, 3,2, 2,2, 1,2, 1,1, 2,1, 3,1], [9,2])
        
        ! Define subgrid order: BL -> ML -> TL -> TM -> MM -> BM -> BR -> MR -> TR
        labels = ["BL", "ML", "TL", "TM", "MM", "BM", "BR", "MR", "TR"]
        
        current_pos = 1
        do k = 1, 9
            ! Get starting position for current subgrid
            select case (labels(k))
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
            end select
            
            ! Extract the 3x3 subgrid
            do i = 1, 3
                do j = 1, 3
                    subgrid(i,j) = grid(row_start + i - 1, col_start + j - 1)
                end do
            end do
            
            ! Convert subgrid to 1x9 matrix using appropriate traversal pattern
            select case (labels(k))
            case ("BL", "TL", "BR", "TR")
                do i = 1, 9
                    subgrid_1x9(i) = subgrid(s1(i,1), s1(i,2))
                end do
            case ("ML", "MR")
                do i = 1, 9
                    subgrid_1x9(i) = subgrid(s2(i,1), s2(i,2))
                end do
            case ("TM", "BM")
                do i = 1, 9
                    subgrid_1x9(i) = subgrid(s3(i,1), s3(i,2))
                end do
            case ("MM")
                do i = 1, 9
                    subgrid_1x9(i) = subgrid(s4(i,1), s4(i,2))
                end do
            end select
            
            ! Convert 1x9 matrix to string and append to output
            write(subgrid_char, '(9(I1))') subgrid_1x9
            peano_string(current_pos:current_pos+8) = subgrid_char
            current_pos = current_pos + 9
        end do
    else
        ! Peano curve is only implemented for 3x3 grids
        peano_string = ""
    end if
  end function convert_grid_to_peano
  
end module utils 