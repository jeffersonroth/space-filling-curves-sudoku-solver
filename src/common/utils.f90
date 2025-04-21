module utils
  implicit none
  private
  
  public :: is_valid_digit, convert_string_to_grid, convert_grid_to_string
  
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
  
end module utils 