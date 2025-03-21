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
add_files /home/deck/Documents/Edge_Runner/edge_runners/uart/kennedy/Testing/Kennedy_receiver_tb.sv

# Create the target directory for the testImages folder
exec mkdir -p Vivado/Sims/uart_project.sim/sim_1/behav/xsim/
exec cp -r /home/deck/Documents/Edge_Runner/edge_runners/uart/kennedy/Testing Vivado/Sims/uart_project.sim/sim_1/behav/xsim/

# Control where the simulation files go 
set_property directory Vivado/Sims [get_filesets sim_1]

# Set the top module
set_property top tb_Kennedy_Receiver [get_filesets sim_1]

# Launch the simulation
launch_simulation

# Run the simulation for 10000ns
run 10000ns

# Define the backup folder for logs and journal files
set backup_folder "/home/deck/Documents/Edge_Runner/edge_runners/Backups_logs_journals"

# Create the backup folder if it doesn't exist
exec mkdir -p $backup_folder

# Move all backup log and journal files to the backup folder - with error handling
exec bash -c "find . -name \"*.backup.log\" | xargs -r mv -t $backup_folder"
exec bash -c "find . -name \"*.backup.jou\" | xargs -r mv -t $backup_folder"

puts "Simulation complete. Results available in Vivado/Sims"
puts "All backup log and journal files have been moved to $backup_folder"

# Open the waveform viewer if a waveform file exists
# The waveform database file is typically named 'xsim.wdb'
# Check if the .wdb file exists and then open it
set waveform_file "Vivado/Sims/uart_project.sim/sim_1/behav/xsim/xsim.wdb"

if {[file exists $waveform_file]} {
    puts "Opening waveform..."
    open_wave -file $waveform_file

    # Add all signals from the Kennedy_Receiver module to the waveform
    add_wave -position end -radix hexadecimal [get_objects -filter {name =~ "uut/*"}]

    # Run the simulation again to capture the waveform
    restart
    run 10000ns
} else {
    puts "No waveform file found. Please check if the simulation generated the waveform."
}