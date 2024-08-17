# FPGA RISC-V Single CPU

## Overview

The **FPGA RISC-V Single CPU** project implements a RISC-V CPU core using FPGA with the following features:
- **Harvard Architecture**: Utilizes separate instruction and data memory.
- **FPGA BRAM**: Makes use of FPGA Block RAM (BRAM) for memory storage.
- **Instruction Injection**: Instructions are injected through `instr_writer.v`, which handles disabling the CPU while loading instructions one at a time into memory.

## TODOs

- **Finish Implementing RV32I Instruction Set**: 
  - In progress
  - Basic functionality for ALU math, branching, register file, and memory interaction works.

- **Exception Handling**: 
  - Not started

- **Connect Edge IO**: 
  - Not started
