# Guide to Testing and Simulation
Basic Guide to Setup Cadence with all the ability to synchronize 
>[!NOTE]
> These Steps were tested on Unix Shells the Windows directions should be similar but not the same 

The best way to start is to clone the testing github repository and place it in your home directory 


`git clone https://github.com/KennedyMen/edge_runners_chip_testing.git`

type this command into your terminal and make sure you are cd'd into your home directory 

once this is done you'll have this folder structure
```
Home
├──edge_runners_chip_testing/
│   ├── Obsidian Vault/
│   ├── Python_(Post)Proccessing/
│   ├── Simulation_Script_Sources/
│   ├── src/
│   │   ├── testImages/
│   │   │   ├── output_binary/
│   │   │   └── images_binary/
│   │   ├── testbenches/
│   │   │   ├── testbenches.sv
│   │   │   └── chip_top.sv
│   │   ├── uart/
│   │   │   ├── fifo/
|	│   │   │   └─ fifo_files.sv
│   │   │   └── uart_files.sv
│   │   └── Image_Processing/
│   │       └── canny_edge_modules.sv
│   │       └── definitions_pkg.sv
│   └── Cadence_Xrunning.tcl
```
 you'll have to then use a sftp client (i use lftp in the command line and i suggest it but you can use[ FileZilla for a GUI](https://filezilla-project.org/) WARNING IT IS AN UGLY GUI)in order to send over the entirety of the `src/` directory over to cadence 
 ```
lftp -u <cadence_username>,<cadence_password> sftp://ae03ut01.cadence.com:222 -e "
  set sftp:connect-program 'ssh -oHostKeyAlgorithms=+ssh-rsa';
  mirror -R <Path_to_Source>  <Path_to_Cadence_Directory>;
  exit
"
 ``` 
 i suggest keeping everything thing within the project directory with everybody else's files
 `project/howard/edge_runners_chip_backup/<yourname>/src`
 to get here and start code coverage run the following commands
  ```
   cd .. 
   cd ..
   cd projects 
   cd howard 
   cd edge_runners_chip_backup
   cd <your_name>
   tclsh Coverage.tcl
```

