# 8-bit-processor
8-bit processor in Verilog with custom ISA and an assembler to convert assembly to hex to work further.
# 8-bit Processor in Verilog

A simple 8-bit processor built in Verilog with a custom assembler and testbenches.

## Project Structure

- `rtl/` - Verilog design files
- `tb/` - Testbench files
- `asm/` - Assembler, assembly program, and hex file

## Files

### RTL
- `alu.v`
- `control_unit.v`
- `dmem.v`
- `imem.v`
- `pc.v`
- `processor_top.v`
- `regfile.v`

### Testbenches
- `alu_tb.v`
- `control_unit_tb.v`
- `dmem_tb.v`
- `imem_tb.v`
- `pc_tb.v`
- `regfile_tb.v`
- `tb_processor_top.v`

### Assembly
- `assembler.py`
- `program.asm`
- `program.hex`

## How to Run

Compile:

```bash
iverilog -o cpu_tb_out tb/tb_processor_top.v rtl/processor_top.v rtl/pc.v rtl/imem.v rtl/regfile.v rtl/alu.v rtl/dmem.v rtl/control_unit.v
```

Run:

```bash
vvp cpu_tb_out
```

Open waveform:

```bash
gtkwave processor_top.vcd
```

## Features

- 8-bit processor datapath
- ALU operations
- Register file
- Instruction memory
- Data memory
- Control unit
- Verilog simulation with GTKWave
