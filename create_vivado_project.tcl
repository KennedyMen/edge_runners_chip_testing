 
file mkdir ./Vivado/Journals
file mkdir ./Vivado/Logs
file mkdir /Vivado/Sims
# Create a new project in the same directory as this script
create_project -force nms_project Vivado/Sims -part xc7z020clg484-1
 file mkdir ./Vivado/Sims/nms_project.sim/sim_1/behav/xsim/

set script_dir [file dirname [info script]]
# Copy the entire testImages folder to the simulation directory
if {[file exists ./src/testImages/]} {
    file copy -force ./src/testImages/ ./Vivado/Sims/nms_project.sim/sim_1/behav/xsim/
} else {
    error "error: testImages folder does not exist."
}

# Add source files
add_files src/testbenches/chip_top_tb.sv
add_files src/Image_Processing/arc_tan.sv
add_files src/Image_Processing/canny_edge_top.sv
add_files src/Image_Processing/chip_top.sv
add_files src/Image_Processing/definitions_pkg.sv
add_files src/Image_Processing/double_thresholding.sv
add_files src/Image_Processing/gaussian_filter.sv
add_files src/Image_Processing/gradient_calculation.sv
add_files src/Image_Processing/hysteresis.sv
add_files src/Image_Processing/line_buffer.sv
add_files src/Image_Processing/non_max_suppression.sv
add_files src/Image_Processing/pixel_loader.sv
add_files src/Image_Processing/sqrt_22b.sv
add_files src/uart/uart_tx.sv
add_files src/uart/uart_rx.sv
add_files src/uart/uart_top.sv
add_files src/uart/baud_gen.sv
add_files src/uart/fifo/fifo.sv
add_files src/uart/fifo/fifo_control.sv
add_files src/uart/fifo/fifo_data.sv

# Create the target directory for the testImages folder
# Create the target directory for the testImages folder

# Control where the simulation files go 
set_property directory Vivado/Sims [get_filesets sim_1]

# Set the top module
set_property top chip_top_tb [get_filesets sim_1]

# Launch the simulation
launch_simulation

# Run the simulation
run 2000ns

# Move stray backup log and journal files to Vivado folder
move_to_dir [glob -nocomplain *.backup.log] /Vivado/Logs
move_to_dir [glob -nocomplain *.backup.jou] /Vivado/Journals

proc move_to_dir {filenames dirname} {
    foreach filename $filenames {
        file rename $filename [file join $dirname [file tail $filename]]
    }
}

puts "Simulation complete. Results available in Vivado/Sims"
puts "All backup log and journal files have been swept into Vivado/Logs and Vivado/Journals, respectively"
