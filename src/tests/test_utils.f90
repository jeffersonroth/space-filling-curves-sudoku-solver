module test_utils
    use grid_interface
    use grid3x3_module
    use grid2x2_module
    use utils
    implicit none
    private
    
    public :: run_test, assert_equal
    
contains
    
    subroutine run_test(test_name, input, expected_output, grid_size)
        character(len=*), intent(in) :: test_name
        character(len=*), intent(in) :: input
        character(len=*), intent(in) :: expected_output
        integer, intent(in) :: grid_size
        integer :: status
        
        print *, "Running test: ", test_name
        print *, "Input: ", input
        
        ! Run test
        call assert_equal(input, expected_output, grid_size, status)
        
        ! Print result
        if (status == 0) then
            print *, "Test passed!"
        else
            print *, "Test failed!"
        end if
    end subroutine run_test
    
    subroutine assert_equal(input, expected_output, grid_size, status)
        ! 260 is Window's MAX_PATH 
        character(len=*), intent(in) :: input
        character(len=*), intent(in) :: expected_output
        integer, intent(in) :: grid_size
        integer, intent(out) :: status
        character(len=260) :: command
        character(len=260) :: solver_output
        character(len=260) :: converter_output
        integer :: exit_status
        integer :: cmdstat
        character(len=260) :: cmdmsg
        character(len=260) :: solver_temp_file
        character(len=260) :: converter_temp_file
        integer :: iunit
        character(len=260) :: current_dir
        character(len=10) :: grid_size_str
        integer :: values(8)
        character(len=20) :: timestamp
        logical :: file_exists
        
        ! Get current directory
        call get_environment_variable("PWD", current_dir)
        
        ! Create test_results directory if it doesn't exist
        call execute_command_line("if not exist test_results mkdir test_results", wait=.true.)
        
        ! Get timestamp for unique filenames
        call date_and_time(values=values)
        write(timestamp, '(I4.4,I2.2,I2.2,I2.2,I2.2,I2.2,I3.3)') &
            values(1), values(2), values(3), values(5), values(6), values(7), values(8)
        
        ! Create unique temporary files in test_results directory
        write(solver_temp_file, '(A,A,A,A,A)') trim(current_dir), "\test_results\solver_output_", trim(timestamp), ".txt"
        write(converter_temp_file, '(A,A,A,A,A)') trim(current_dir), "\test_results\converter_output_", trim(timestamp), ".txt"
        
        ! Convert grid size to string
        write(grid_size_str, '(I1)') grid_size
        
        ! Initialize output strings
        solver_output = ""
        converter_output = ""
        
        ! First, run sudoku solver without redirection to see its output
        print *, "Running sudoku solver without redirection..."
        write(command, '(4A,1X,A,1X,2A)') &
            trim(current_dir), "\build\sudoku_solver.exe", &
            " ", trim(grid_size_str), &
            " ", '"', trim(input), '"'
        call execute_command_line(trim(command), wait=.true., &
                                exitstat=exit_status, &
                                cmdstat=cmdstat, &
                                cmdmsg=cmdmsg)
        if (cmdstat /= 0 .or. exit_status /= 0) then
            print *, "Error running sudoku solver: ", trim(cmdmsg)
            print *, "Exit status: ", exit_status
            print *, "Command: ", trim(command)
            status = 1
            return
        end if
        
        ! Now run with redirection
        print *, "Running sudoku solver with redirection..."
        write(command, '(4A,1X,A,1X,3A,1X,A)') &
            trim(current_dir), "\build\sudoku_solver.exe", &
            " ", trim(grid_size_str), &
            " ", '"', trim(input), '"', &
            ">", trim(solver_temp_file)
        call execute_command_line(trim(command), wait=.true., &
                                exitstat=exit_status, &
                                cmdstat=cmdstat, &
                                cmdmsg=cmdmsg)
        if (cmdstat /= 0 .or. exit_status /= 0) then
            print *, "Error running sudoku solver: ", trim(cmdmsg)
            print *, "Exit status: ", exit_status
            print *, "Command: ", trim(command)
            status = 1
            return
        end if
        
        ! Check if solver output file exists
        inquire(file=solver_temp_file, exist=file_exists)
        if (.not. file_exists) then
            print *, "Error: Solver output file not created"
            print *, "Expected file: ", trim(solver_temp_file)
            status = 1
            return
        end if
        
        ! Read solver output
        open(newunit=iunit, file=solver_temp_file, status='old', action='read', iostat=cmdstat)
        if (cmdstat == 0) then
            read(iunit, '(A)', iostat=cmdstat) solver_output
            if (cmdstat > 0) then
                print *, "Error reading solver output: ", cmdstat
                close(iunit)
                status = 1
                return
            end if
            close(iunit)
            print *, "Solver output: ", trim(solver_output)
        else
            print *, "Error opening solver output file: ", cmdstat
            status = 1
            return
        end if
        
        ! First, run converter without redirection to see its output
        print *, "Running converter without redirection..."
        if (grid_size == 2) then
            write(command, '(4A,1X,2A)') &
                trim(current_dir), "\build\row_major_to_hilbert.exe", &
                " ", '"', trim(input), '"'
        else
            write(command, '(4A,1X,2A)') &
                trim(current_dir), "\build\row_major_to_peano.exe", &
                " ", '"', trim(input), '"'
        end if
        call execute_command_line(trim(command), wait=.true., &
                                exitstat=exit_status, &
                                cmdstat=cmdstat, &
                                cmdmsg=cmdmsg)
        if (cmdstat /= 0 .or. exit_status /= 0) then
            print *, "Error running converter: ", trim(cmdmsg)
            print *, "Exit status: ", exit_status
            print *, "Command: ", trim(command)
            status = 1
            return
        end if
        
        ! Now run with redirection
        print *, "Running converter with redirection..."
        if (grid_size == 2) then
            write(command, '(4A,1X,2A,1X,A,1X,A)') &
                trim(current_dir), "\build\row_major_to_hilbert.exe", &
                " ", '"', trim(input), '"', &
                ">", trim(converter_temp_file)
        else
            write(command, '(4A,1X,2A,1X,A,1X,A)') &
                trim(current_dir), "\build\row_major_to_peano.exe", &
                " ", '"', trim(input), '"', &
                ">", trim(converter_temp_file)
        end if
        call execute_command_line(trim(command), wait=.true., &
                                exitstat=exit_status, &
                                cmdstat=cmdstat, &
                                cmdmsg=cmdmsg)
        if (cmdstat /= 0 .or. exit_status /= 0) then
            print *, "Error running converter: ", trim(cmdmsg)
            print *, "Exit status: ", exit_status
            print *, "Command: ", trim(command)
            status = 1
            return
        end if
        
        ! Check if converter output file exists
        inquire(file=converter_temp_file, exist=file_exists)
        if (.not. file_exists) then
            print *, "Error: Converter output file not created"
            print *, "Expected file: ", trim(converter_temp_file)
            status = 1
            return
        end if
        
        ! Read converter output
        open(newunit=iunit, file=converter_temp_file, status='old', action='read', iostat=cmdstat)
        if (cmdstat == 0) then
            read(iunit, '(A)', iostat=cmdstat) converter_output
            if (cmdstat > 0) then
                print *, "Error reading converter output: ", cmdstat
                close(iunit)
                status = 1
                return
            end if
            close(iunit)
            print *, "Converter output: ", trim(converter_output)
        else
            print *, "Error opening converter output file: ", cmdstat
            status = 1
            return
        end if
        
        ! Compare outputs
        if (trim(converter_output) /= trim(expected_output)) then
            print *, "Expected: ", trim(expected_output)
            print *, "Actual:   ", trim(converter_output)
            status = 1
        else
            status = 0
        end if
        
        ! Cleanup
        call execute_command_line("del " // trim(solver_temp_file), wait=.true.)
        call execute_command_line("del " // trim(converter_temp_file), wait=.true.)
    end subroutine assert_equal
    
end module test_utils 