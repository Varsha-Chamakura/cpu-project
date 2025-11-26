# From cpu-project/

g++ -std=c++17 -o assembler src/assembler.cpp src/cpu.cpp
g++ -std=c++17 -o emulator src/emulator.cpp src/cpu.cpp

# Assemble programs
./assembler programs/hello.asm     hello.bin
./assembler programs/fibonacci.asm fib.bin

# Run them
./emulator hello.bin
./emulator fib.bin

# Software CPU Emulator in C/C++

This project implements a simple 8-bit **software CPU**, written in C++, along with:

- A CPU **emulator**
- A two-pass **assembler**
- Example **assembly programs**:
  - `hello.asm` – prints "Hello, World!"
  - `fibonacci.asm` – generates Fibonacci numbers (raw 8-bit output)
  - `timer.asm` – simple timer-like loop printing dots with delays

## Project Structure

```text
cpu-project/
  src/
    cpu.h
    cpu.cpp
    emulator.cpp
    assembler.cpp
  programs/
    hello.asm
    fibonacci.asm
    timer.asm
  docs/
    cpu_architecture.txt
    cpu_schematic_description.txt
    report.pdf    (you will add this)
