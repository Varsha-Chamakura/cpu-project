#pragma once

#include <cstdint>

struct CPU {
    // 8-bit general purpose registers
    uint8_t A;
    uint8_t B;

    // 16-bit registers
    uint16_t PC;
    uint16_t SP;

    // Flags
    bool Z; // Zero
    bool C; // Carry

    // 64 KB memory
    uint8_t memory[65536];
};

// Opcodes
enum Opcode : uint8_t {
    NOP  = 0x00,
    LDAI = 0x01,
    LDBI = 0x02,
    LDA  = 0x03,
    LDB  = 0x04,
    STA  = 0x05,
    ADD  = 0x06,
    SUB  = 0x07,
    JMP  = 0x08,
    JZ   = 0x09,
    JNZ  = 0x0A,
    HLT  = 0x0B
};

// API
void cpu_reset(CPU &cpu);
bool cpu_step(CPU &cpu);  // returns false when HLT executed
bool load_program(CPU &cpu, const char *filename, uint16_t load_addr);
void dump_memory(const CPU &cpu, uint16_t start, uint16_t end);

