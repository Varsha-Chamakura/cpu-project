#include <cstdint>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <unordered_map>
#include <vector>
#include <cctype>
#include "cpu.h"

struct InstrDef {
    std::string name;
    uint8_t opcode;
    uint8_t size;    // total bytes (1,2,3)
    bool hasOperand;
};

static const uint16_t ORIGIN = 0x0100;

static std::unordered_map<std::string, InstrDef> instrTable = {
    {"NOP",  { "NOP",  NOP,  1, false }},
    {"LDAI", { "LDAI", LDAI, 2, true  }},
    {"LDBI", { "LDBI", LDBI, 2, true  }},
    {"LDA",  { "LDA",  LDA,  3, true  }},
    {"LDB",  { "LDB",  LDB,  3, true  }},
    {"STA",  { "STA",  STA,  3, true  }},
    {"ADD",  { "ADD",  ADD,  1, false }},
    {"SUB",  { "SUB",  SUB,  1, false }},
    {"JMP",  { "JMP",  JMP,  3, true  }},
    {"JZ",   { "JZ",   JZ,   3, true  }},
    {"JNZ",  { "JNZ",  JNZ,  3, true  }},
    {"HLT",  { "HLT",  HLT,  1, false }},
};

static std::string trim(const std::string &s) {
    size_t start = 0;
    while (start < s.size() && std::isspace((unsigned char)s[start])) ++start;
    if (start == s.size()) return "";
    size_t end = s.size() - 1;
    while (end > start && std::isspace((unsigned char)s[end])) --end;
    return s.substr(start, end - start + 1);
}

static int parseNumber(const std::string &tok) {
    std::string t = tok;
    if (!t.empty() && t[0] == '#') {
        t = t.substr(1);
    }
    if (t.size() >= 3 && t.front() == '\'' && t.back() == '\'') {
        if (t.size() == 3) {
            return static_cast<unsigned char>(t[1]);
        }
    }
    if (t.size() > 2 && t[0] == '0' && (t[1] == 'x' || t[1] == 'X')) {
        return std::stoi(t, nullptr, 16);
    }
    return std::stoi(t, nullptr, 10);
}

int main(int argc, char *argv[]) {
    if (argc < 3) {
        std::cerr << "Usage: assembler <input.asm> <output.bin>\n";
        return 1;
    }

    std::string inFile = argv[1];
    std::string outFile = argv[2];

    std::ifstream in(inFile);
    if (!in) {
        std::cerr << "Failed to open " << inFile << "\n";
        return 1;
    }

    std::vector<std::string> lines;
    std::string line;
    while (std::getline(in, line)) {
        lines.push_back(line);
    }

    // PASS 1: build label table
    std::unordered_map<std::string, uint16_t> labels;
    uint16_t loc = ORIGIN;

    for (const auto &rawLine : lines) {
        std::string l = rawLine;
        auto posComment = l.find(';');
        if (posComment != std::string::npos) {
            l = l.substr(0, posComment);
        }
        l = trim(l);
        if (l.empty()) continue;

        std::string label, rest;
        auto colonPos = l.find(':');
        if (colonPos != std::string::npos) {
            label = trim(l.substr(0, colonPos));
            rest  = trim(l.substr(colonPos + 1));
            if (!label.empty()) {
                labels[label] = loc;
            }
        } else {
            rest = l;
        }
        if (rest.empty()) continue;

        std::istringstream iss(rest);
        std::string mnemonic;
        iss >> mnemonic;
        auto it = instrTable.find(mnemonic);
        if (it == instrTable.end()) {
            std::cerr << "Unknown instruction in pass 1: " << mnemonic << "\n";
            return 1;
        }
        loc += it->second.size;
    }

    // PASS 2: generate code
    std::vector<uint8_t> output;
    loc = ORIGIN;

    for (const auto &rawLine : lines) {
        std::string l = rawLine;
        auto posComment = l.find(';');
        if (posComment != std::string::npos) {
            l = l.substr(0, posComment);
        }
        l = trim(l);
        if (l.empty()) continue;

        std::string label, rest;
        auto colonPos = l.find(':');
        if (colonPos != std::string::npos) {
            label = trim(l.substr(0, colonPos));
            rest  = trim(l.substr(colonPos + 1));
        } else {
            rest = l;
        }
        if (rest.empty()) continue;

        std::istringstream iss(rest);
        std::string mnemonic;
        iss >> mnemonic;
        auto it = instrTable.find(mnemonic);
        if (it == instrTable.end()) {
            std::cerr << "Unknown instruction in pass 2: " << mnemonic << "\n";
            return 1;
        }
        InstrDef def = it->second;
        output.push_back(def.opcode);

        if (def.hasOperand) {
            std::string operandToken;
            if (!(iss >> operandToken)) {
                std::cerr << "Missing operand for " << mnemonic << "\n";
                return 1;
            }

            int value = 0;
            // If operand is a label
            if (labels.count(operandToken)) {
                value = labels[operandToken];
            } else {
                value = parseNumber(operandToken);
            }

            if (def.size == 2) {
                // imm8
                output.push_back(static_cast<uint8_t>(value & 0xFF));
            } else if (def.size == 3) {
                // addr16 (little-endian)
                output.push_back(static_cast<uint8_t>(value & 0xFF));
                output.push_back(static_cast<uint8_t>((value >> 8) & 0xFF));
            }
        }
        loc += def.size;
    }

    std::ofstream out(outFile, std::ios::binary);
    if (!out) {
        std::cerr << "Failed to open " << outFile << " for writing\n";
        return 1;
    }

    for (auto b : output) {
        out.put(static_cast<char>(b));
    }

    std::cout << "Assembled " << inFile << " to " << outFile
              << " (" << output.size() << " bytes)\n";

    return 0;
}
