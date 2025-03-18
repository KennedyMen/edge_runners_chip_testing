# Create a new project in the same directory as this script
create_project -force nms_project ./nms_project -part xc7z020clg484-1

# Add source files
add_files /home/deck/Desktop/edge_runners/testBench/non_max_suppresion_tb.sv
add_files /home/deck/Desktop/edge_runners/non_max_suppression.sv
add_files /home/deck/Desktop/edge_runners/pixel_loader.sv
add_files /home/deck/Desktop/edge_runners/gaussian_filter.sv
add_files /home/deck/Desktop/edge_runners/gradient_calculation.sv
add_files /home/deck/Desktop/edge_runners/definitions_pkg.sv
add_files /home/deck/Desktop/edge_runners/line_buffer.sv
add_files /home/deck/Desktop/edge_runners/sqrt_22b.sv
add_files /home/deck/Desktop/edge_runners/arc_tan.sv

# Create the target directory for the testImages folder
exec mkdir -p ./nms_project/nms_project.sim/sim_1/behav/xsim/

# Copy the entire testImages folder to the simulation directory
exec cp -r /home/deck/Desktop/edge_runners/testImages ./nms_project/nms_project.sim/sim_1/behav/xsim/

# Set the top module
set_property top nms_tb [get_filesets sim_1]

# Launch the simulation
launch_simulation

# Run the simulation
run all