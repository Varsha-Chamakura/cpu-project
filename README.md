# From cpu-project/

g++ -std=c++17 -o assembler src/assembler.cpp src/cpu.cpp
g++ -std=c++17 -o emulator src/emulator.cpp src/cpu.cpp

# Assemble programs
./assembler programs/hello.asm     hello.bin
./assembler programs/fibonacci.asm fib.bin

# Run them
./emulator hello.bin
./emulator fib.bin

