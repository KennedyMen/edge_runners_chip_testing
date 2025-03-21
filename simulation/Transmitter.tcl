# Create the Vivado/Journals and Vivado/Logs directories if they do not exist
exec mkdir -p Vivado/Journals
exec mkdir -p Vivado/Logs

# Create a new project in the same directory as this script
create_project -force uart_project Vivado/Sims -part xc7z020clg484-1

# Add source files
add_files /home/deck/Documents/Edge_Runner/edge_runners/definitions_pkg.sv
add_files /home/deck/Documents/Edge_Runner/edge_runners/uart/kennedy/baud_gen.sv
add_files /home/deck/Documents/Edge_Runner/edge_runners/uart/kennedy/Divisor.sv
add_files /home/deck/Documents/Edge_Runner/edge_runners/uart/kennedy/FIFO.sv
add_files /home/deck/Documents/Edge_Runner/edge_runners/uart/kennedy/Kennedy_receiver.sv
add_files /home/deck/Documents/Edge_Runner/edge_runners/uart/kennedy/Kennedy_Transmitter.sv
add_files /home/deck/Documents/Edge_Runner/edge_runners/uart/kennedy/Mensah_UART.sv
add_files /home/deck/Documents/Edge_Runner/edge_runners/uart/kennedy/Testing/Kennedy_transmitter_tb.sv

# Create the target directory for the testImages folder
exec mkdir -p Vivado/Sims/uart_project.sim/sim_1/behav/xsim/
exec cp -r /home/deck/Documents/Edge_Runner/edge_runners/uart/kennedy/Testing Vivado/Sims/uart_project.sim/sim_1/behav/xsim/

# Control where the simulation files go 
set_property directory Vivado/Sims [get_filesets sim_1]

# Set the top module
set_property top tb_Kennedy_Transmitter [get_filesets sim_1]

# Launch the simulation
launch_simulation

# Run the simulation for 150000ns
run 150000ns

# Define the backup folder for logs and journal files

# Create the backup folder if it doesn't exist

# Move all backup log and journal files to the backup folder - with error handling

puts "Simulation complete. Results available in Vivado/Sims"
puts "All backup log and journal files have been moved to $backup_folder"

# Prompt user about opening waveform
puts -nonewline "Would you like to open the waveform viewer? (y/n): "
flush stdout
gets stdin response

if {[string tolower $response] == "y" || [string tolower $response] == "yes"} {
    # Open the waveform viewer
    if {[file exists [current_sim]/xsim.wdb]} {
        open_wave_database [current_sim]/xsim.wdb
        display_wave -open_wave_config {}
        puts "Waveform viewer opened successfully."
    } else {
        puts "Error: Waveform database file not found."
    }
}

puts "Script completed. You can now enter additional commands."