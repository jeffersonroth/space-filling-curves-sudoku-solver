module grid_interface
  implicit none
  private
  
  type, abstract, public :: AbstractGrid
  contains
    procedure(initialize_interface), deferred :: initialize
    procedure(solve_interface), deferred :: solve
    procedure(print_grid_interface), deferred :: print_grid
    procedure(get_size_interface), deferred :: get_size
    procedure(get_data_interface), deferred :: get_data
  end type AbstractGrid
  
  abstract interface
    subroutine initialize_interface(this, grid_data)
      import :: AbstractGrid
      class(AbstractGrid), intent(inout) :: this
      integer, intent(in) :: grid_data(:,:)
    end subroutine initialize_interface
    
    function solve_interface(this) result(success)
      import :: AbstractGrid
      class(AbstractGrid), intent(inout) :: this
      logical :: success
    end function solve_interface
    
    subroutine print_grid_interface(this)
      import :: AbstractGrid
      class(AbstractGrid), intent(in) :: this
    end subroutine print_grid_interface
    
    function get_size_interface(this) result(size)
      import :: AbstractGrid
      class(AbstractGrid), intent(in) :: this
      integer :: size
    end function get_size_interface

    function get_data_interface(this) result(grid_data)
      import :: AbstractGrid
      class(AbstractGrid), intent(in) :: this
      integer, allocatable :: grid_data(:,:)
    end function get_data_interface
  end interface
  
end module grid_interface 