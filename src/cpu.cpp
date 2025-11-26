#include "cpu.h"
#include <cstring>
#include <fstream>
#include <iostream>

static const uint16_t IO_CONSOLE_OUT = 0x00FF;

void cpu_reset(CPU &cpu) {
    cpu.A = cpu.B = 0;
    cpu.PC = 0x0100; // program entry
    cpu.SP = 0xFFFE; // arbitrary stack start (unused)
    cpu.Z = cpu.C = false;
    std::memset(cpu.memory, 0, sizeof(cpu.memory));
}

static uint8_t mem_read(const CPU &cpu, uint16_t addr) {
    return cpu.memory[addr];
}

static void mem_write(CPU &cpu, uint16_t addr, uint8_t value) {
    if (addr == IO_CONSOLE_OUT) {
        // Memory-mapped I/O: console output
        std::cout << static_cast<char>(value);
    } else {
        cpu.memory[addr] = value;
    }
}

static uint16_t fetch16(CPU &cpu) {
    uint8_t lo = mem_read(cpu, cpu.PC++);
    uint8_t hi = mem_read(cpu, cpu.PC++);
    return static_cast<uint16_t>(lo | (hi << 8));
}

bool cpu_step(CPU &cpu) {
    uint8_t opcode = mem_read(cpu, cpu.PC++);

    switch (opcode) {
        case NOP:
            // do nothing
            break;

        case LDAI: {
            uint8_t imm = mem_read(cpu, cpu.PC++);
            cpu.A = imm;
            cpu.Z = (cpu.A == 0);
            break;
        }

        case LDBI: {
            uint8_t imm = mem_read(cpu, cpu.PC++);
            cpu.B = imm;
            cpu.Z = (cpu.B == 0);
            break;
        }

        case LDA: {
            uint16_t addr = fetch16(cpu);
            cpu.A = mem_read(cpu, addr);
            cpu.Z = (cpu.A == 0);
            break;
        }

        case LDB: {
            uint16_t addr = fetch16(cpu);
            cpu.B = mem_read(cpu, addr);
            cpu.Z = (cpu.B == 0);
            break;
        }

        case STA: {
            uint16_t addr = fetch16(cpu);
            mem_write(cpu, addr, cpu.A);
            break;
        }

        case ADD: {
            uint16_t result = static_cast<uint16_t>(cpu.A) + cpu.B;
            cpu.C = (result > 0xFF);
            cpu.A = static_cast<uint8_t>(result & 0xFF);
            cpu.Z = (cpu.A == 0);
            break;
        }

        case SUB: {
            int16_t result = static_cast<int16_t>(cpu.A) - cpu.B;
            cpu.C = (result < 0); // simple borrow flag
            cpu.A = static_cast<uint8_t>(result & 0xFF);
            cpu.Z = (cpu.A == 0);
            break;
        }

        case JMP: {
            uint16_t addr = fetch16(cpu);
            cpu.PC = addr;
            break;
        }

        case JZ: {
            uint16_t addr = fetch16(cpu);
            if (cpu.Z) {
                cpu.PC = addr;
            }
            break;
        }

        case JNZ: {
            uint16_t addr = fetch16(cpu);
            if (!cpu.Z) {
                cpu.PC = addr;
            }
            break;
        }

        case HLT:
            return false; // stop

        default:
            std::cerr << "Unknown opcode 0x"
                      << std::hex << static_cast<int>(opcode)
                      << " at PC=0x" << cpu.PC - 1 << std::dec << "\n";
            return false;
    }

    return true;
}

bool load_program(CPU &cpu, const char *filename, uint16_t load_addr) {
    std::ifstream in(filename, std::ios::binary);
    if (!in) {
        std::cerr << "Failed to open program file: " << filename << "\n";
        return false;
    }

    uint16_t addr = load_addr;
    char byte;
    while (in.get(byte)) {
        if (addr == 0xFFFF) break;
        cpu.memory[addr++] = static_cast<uint8_t>(byte);
    }

    return true;
}

void dump_memory(const CPU &cpu, uint16_t start, uint16_t end) {
    for (uint16_t addr = start; addr <= end; ++addr) {
        if ((addr - start) % 16 == 0) {
            std::cout << "\n0x" << std::hex << addr << ": ";
        }
        std::cout << std::hex
                  << static_cast<int>(cpu.memory[addr]) << " ";
    }
    std::cout << std::dec << "\n";
}
