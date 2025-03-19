# Howard EECE-409 Edge-Detector Tape-Out


| | | |
|:-------------------------:|:-------------------------:|:-------------------------:|
<img width="1604" alt="screen shot 2017-08-07 at 12 18 15 pm" src="https://i.ibb.co/F4J3Pqw7/gaussian-output.png"> Gaussian|<img width="1604" alt="screen shot 2017-08-07 at 12 18 15 pm" src="https://i.ibb.co/wNyT2T5f/sobel-output.png">  Sobel  
| <img width="1604" alt="screen shot 2017-08-07 at 12 18 15 pm" src="https://i.ibb.co/fWhmDmv/Outputting.png">Non-Max Suppression |<img width="1604" alt="screen shot 2017-08-07 at 12 18 15 pm" src="https://i.ibb.co/v4BzRqvt/direction-contour.png"> Direction
|

## Dictionary 
[Convolution](#Convolution)
[Non-Max Suppression](#Non-Max-Suppression)
[Hysteris](#Hysterisis)
[IO](#IO)
[Vivado Simulation in Terminal/VSCode](#Running-Vivado-Simulation)

# Convolution

![Convolution Visualized ](https://upload.wikimedia.org/wikipedia/commons/1/19/2D_Convolution_Animation.gif)

## Gaussian Blur 

![But what is a convolution?](https://i.makeagif.com/media/2-04-2024/qT0syh.gif)
## Sobel Filter
![But what is a convolution?](https://i.makeagif.com/media/3-19-2025/3XEGyp.gif)

# Non-Max Suppresion

![enter image description here](https://i.ibb.co/q36gQ7hv/SLBQ4.png)

# Hysteris

![enter image description here](https://i.ibb.co/1GhMzX0b/Screenshot-20250318-213241.png)

# IO
![enter image description here](https://www.parlezvoustech.com/wp-content/uploads/2023/12/i2c.gif)



## Running Vivado Simulation



# Running Vivado In Terminal Guide

In order to use Vivado in the terminal it first needs to be downloaded from [here](https://www.xilinx.com/support/download.html) 

once its downloaded you need to find the installation directory for it which will include the bin for it

**Windows Directory normally**
`C:\Xilinx\Vivado\<version>\bin`

**Linux**
`User/xlinx/Vivado/<version>/bin`

once you've gotten a hold of the paths you have to follow the following steps  to setup your Environment Variables
**Windows**
1.  **Search for “Environment Variables** in the Windows search bar and select “Edit the system environment variables.”
2.  In the **System Properties** window, click on **Environment Variables**.
3.  Under **System Variables**, find and select the `Path` variable, then click **Edit**.
4.  Click **New** and add the path to the Vivado `bin` directory. 
5. Click **OK** to close all windows.
6. Click `Windows + R` type `cmd` then **Enter**
7. Test with `vivado -version`

**Linux**

1. Open Your **Konsole** or **Terminal** 
2. run `vim ~/.bashrc`  or `vim ~/.zsh` 
3. add the following lines
 ```
 export VIVADO_PATH=/home/deck/xlinx/Vivado/2024.2/bin
 export VIVADO_SETTINGS=/home/deck/xlinx/Vivado/2024.2
 source $VIVADO_SETTINGS/settings64.sh
 ```
4. type in  `source ~/.bashrc`or `source ~/.zsh`
5. `cd` into the bin directory if not already there    
6. type in`chmod +x vivado` then **Enter**
7. test with `vivado -version`
    

# How to run the TCL File 

Simply type in the following command 
```
vivado -mode batch -source simulation/create_vivado_project.tcl -journal Vivado/Journals/vivado.jou -log Vivado/Logs/vivado.log
```

# Modifying the TCL 




**To add more Source Files for Further Testing**
```
# Add source files
add_files home/deck/Documents/Edge_Runner/edge_runners/testBench/<testbench>
add_files /home/deck/Documents/Edge_Runner/edge_runners/<module files>
...
add_files /home/deck/Documents/Edge_Runner/edge_runners/<module files>
```
**Setup a new top module**
```
# Set the top module
set_property top <top modules. [get_filesets sim_1]
```
**Change the simulation time (might be neccesary when adding new modules)**
```
# Run the simulation
run 2000ns
```
This should be all you need to change but there are comments on any other aspects and There will be guides on running bitstreams and making waveforms
