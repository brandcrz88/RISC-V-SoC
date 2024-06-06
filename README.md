# RISC-V SoC
<<<<<<< HEAD

This project incorporates a RISC-V processor, a memory module, a UART IP, and various registers, among other modules. The purpose is to showcase the embedding process of a software program into a RISC-V architecture processor, to observe how memory interacts with the system on chip (SoC). To do so, a hexadecimal file is generated from simple C and Assembly programs. Finally, the design is simulated using open source tools, and tested into an iCEBreaker V1.0e FPGA.

Here are some important points to take from this project:

- The firmware folder contains different files, which objective is to generate a hex file that contains the rv32i tailored machine code that will be embedded into memory through the synthesis tools like the riscv32-gcc compiler. This file contains the instructions that the processor will be fetching and executing within the SoC.
- On the software side, the program is generated with Assembly and high-level language C. The sections.lds file contains the pertain memory mapping. This boils down to the fact that Software can access hardware through memory mapping. 
- The main.c program can access the memory mapped sections through header files. More specifically, a pointer is created to access the different register data types that map on hardware.
- The processor interacts with the SoC modules through a modularization process that consists of creating registers for each module, which communicate with the standard bus interface of the processor. This registers consist of Data, Control, and Status. Also, they control the logic of the specific IP. Corsair was used to generate the verilog code for these registers. It requires two configuration files, the csrconfig and regs.yaml.
- The processor performs a five stage pipeline: fetch -> decode -> execute -> memory ops -> write back.

## Architecture

The program's Assembly code boils down to generate a blinking pattern of 5 LEDs, it is achieve by sending an address to a general purpose input output IP (GPIO), which is connected to the external world. The blinking patterns is achieved by adding a delay between both "instructions". On the main.c the code is used to send a string to a UART IP that connects to the host PC, this string can be observed on a terminal emulator called PuTTY. 

The design consists of different modules (including the top module), which are the following:

- RISC-V 32-bit integer core (rv32i), it is an open source version "The Quark", which is the most elementary version of FemtoRV32.
- Memory module, 6Kb of RAM in total.
- GPIO IP.
- UART IP.
- Registers for bus communication.
- A device select module, which defines the address to access the SoC IP modules.
- Phase-locked loop module, which generates a 30 MHz clock signal.

### Overview

GPIO: Controls LEDs.

UART: Enables data transfer between host PC and FPGA.

The following diagram shows how the UART registers link the rv32i and the UART IP.

diagram.jpg


## Waveform Simulation

waveform.jpg

Explanation 

## The Makefile

The Makefile automates the compilation process that tests the behavior of each module, including the top module. It takes care of the simulation and verification processes. 

The firmware directory contains a Makefile, this links the source and targets to generate a hex file that contains the program's instructions. It also generates a dumpfile, which is a readable version of the hex file. This is useful to compare the waveform simulation with the expected behavior. 

The fpga directory contains another Makefile, this one automates the synthesis process that programs the FPGA with the hex code. The design is tailored to the iCEBreaker V1.0e FPGA pin configuration. 

## Testing on a FPGA

The process of testing the design on an FPGA consists of:

- Design: The first step is to write the design's functionality using HDL.

- Synthesis: The HDL is converted into a gate-level representation by a synthesis tool such as open source `Yosys`. 

- Mapping: The logic gates and flip-flops can be placed into the FPGA's specific blocks and routing resources.

- Place and route: The mapped design is physically placed into the FPGA's chip space and creates the interconnections.
  
- Bitstream: It generates a bitstream file that contains the configuration data that is loaded into the FPGA, which sets the internal circuit.

- Programming: The bitstream is loaded into the FPGA, more often through a USB or JTAG interface.

The "fpga" directory contains its own Makefile that automates the synthesis process to program the design on an icebreaker FPGA.

=======
>>>>>>> 2142a82ee35116e9b309c3cb73252eabc4c7ff6e
