#include "cpu.h"
#include <iostream>

int main(int argc, char *argv[]) {
    if (argc < 2) {
        std::cerr << "Usage: emulator <program.bin>\n";
        return 1;
    }

    CPU cpu;
    cpu_reset(cpu);

    if (!load_program(cpu, argv[1], 0x0100)) {
        return 1;
    }

    bool running = true;
    while (running) {
        running = cpu_step(cpu);
    }

    std::cout << "\n[Program finished]\n";
    return 0;
}
