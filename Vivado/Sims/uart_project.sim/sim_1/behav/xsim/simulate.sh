#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2024.2 (64-bit)
#
# Filename    : simulate.sh
# Simulator   : AMD Vivado Simulator
# Description : Script for simulating the design by launching the simulator
#
# Generated by Vivado on Fri Mar 21 16:53:28 EDT 2025
# SW Build 5239630 on Fri Nov 08 22:34:34 MST 2024
#
# Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
# Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
#
# usage: simulate.sh
#
# ****************************************************************************
set -Eeuo pipefail
# simulate design
echo "xsim tb_Kennedy_Transmitter_behav -key {Behavioral:sim_1:Functional:tb_Kennedy_Transmitter} -tclbatch tb_Kennedy_Transmitter.tcl -log simulate.log"
xsim tb_Kennedy_Transmitter_behav -key {Behavioral:sim_1:Functional:tb_Kennedy_Transmitter} -tclbatch tb_Kennedy_Transmitter.tcl -log simulate.log

