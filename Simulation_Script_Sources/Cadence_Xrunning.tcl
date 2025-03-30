
#!/usr/bin/env tclsh

# Configuration parameters
set DEFAULT_ACCESS_MODE "+rwc"
set DEFAULT_COVERAGE "all"
set USE_GUI 1

# Main design files (root directory)
set MAIN_FILES {
    Canny_edge/arc_tan.sv
    Canny_edge/hysteresis.sv
    Canny_edge/chip_top.sv
    Canny_edge/gaussian_filter.sv
    Canny_edge/gradient_calculation.sv
    Canny_edge/pixel_loader.sv
    Canny_edge/non_max_suppression.sv
    Canny_edge/line_buffer.sv
    Canny_edge/definitions_pkg.sv
    Canny_edge/double_thresholding.sv
    Canny_edge/definitions_pkg.sv
    Canny_edge/sqrt_22b.sv
    Canny_edge/canny_edge_top.sv
}

# UART directory files
set UART_FILES {
    uart/baud_gen.sv
    uart/uart_tx.sv
    uart/uart_rx.sv
    uart/uart_top.sv
}

# UART FIFO directory files
set UART_FIFO_FILES {
    uart/fifo/fifo_control.sv
    uart/fifo/fifo_data.sv
    uart/fifo/fifo.sv
}

# Testbench file
set TESTBENCH_FILES {
    testBenches/chip_top_tb.sv
}

# Function to build and execute xrun command
proc run_xrun {{args ""}} {
    global DEFAULT_ACCESS_MODE DEFAULT_COVERAGE USE_GUI
    global MAIN_FILES UART_FILES UART_FIFO_FILES TESTBENCH_FILES
    
    # Process any additional arguments
    if {$args != ""} {
        for {set i 0} {$i < [llength $args]} {incr i} {
            set arg [lindex $args $i]
            
            switch -glob -- $arg {
                "-access" {
                    incr i
                    set DEFAULT_ACCESS_MODE [lindex $args $i]
                }
                "-coverage" {
                    incr i
                    set DEFAULT_COVERAGE [lindex $args $i]
                }
                "-gui" {
                    set USE_GUI 1
                }
                "-nogui" {
                    set USE_GUI 0
                }
            }
        }
    }
    
    # Start building the command
    set cmd "xrun "
    
    # Add all the files to the command
    foreach file $MAIN_FILES {
        append cmd "$file "
    }
    
    foreach file $UART_FILES {
        append cmd "$file "
    }
    
    foreach file $UART_FIFO_FILES {
        append cmd "$file "
    }
    
    foreach file $TESTBENCH_FILES {
        append cmd "$file "
    }
    
    # Add access mode
    append cmd "-access $DEFAULT_ACCESS_MODE "
    
    # Add coverage
    append cmd "-coverage $DEFAULT_COVERAGE "
    
    # Add GUI mode if enabled
    if {$USE_GUI} {
        append cmd "-gui"
    }
    
    # Execute the command
    puts "Executing: $cmd"
    if {[catch {exec {*}[split $cmd]} result]} {
        puts "Error executing xrun command:"
        puts $result
        return 0
    } else {
        puts "xrun command completed successfully"
        return 1
    }
}

# Main execution
if {[info exists argc] && [info exists argv]} {
    # If running as script, execute run_xrun with command-line arguments
    run_xrun $argv
} else {
    # If sourced from another script, just define the procedures
    puts "Script loaded. Use 'run_xrun' command to execute xrun with the predefined files."
    puts "Example: run_xrun {-nogui -coverage functional}"
}

# Print help information
proc print_help {} {
    puts "Usage: tclsh xrun_script.tcl \[options\]"
    puts "Options:"
    puts "  -access mode     : Set access mode (default: +rwc)"
    puts "  -coverage type   : Set coverage type (default: all)"
    puts "  -gui             : Enable GUI mode (default)"
    puts "  -nogui           : Disable GUI mode"
    
    puts "\nPredefined file groups:"
    global MAIN_FILES UART_FILES UART_FIFO_FILES TESTBENCH_FILES
    
    puts "Main files:"
    foreach file $MAIN_FILES {
        puts "  - $file"
    }
    
    puts "UART files:"
    foreach file $UART_FILES {
        puts "  - $file"
    }
    
    puts "UART FIFO files:"
    foreach file $UART_FIFO_FILES {
        puts "  - $file"
    }
    
    puts "Testbench files:"
    foreach file $TESTBENCH_FILES {
        puts "  - $file"
    }
}

# Add help command
if {![info exists argc]} {
    puts "Type 'print_help' for usage information."
}
