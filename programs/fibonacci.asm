; =====================================================
; Fibonacci Program — HEX Output (Compatible with Your ISA)
; Supports ONLY:
; LDAI LDBI LDA LDB STA ADD SUB JMP JZ JNZ HLT
; =====================================================

; MEMORY USAGE
; 0x0200 = F0   (current number)
; 0x0201 = F1   (next number)
; 0x0202 = TEMP (A+B)
; 0x0203 = HIGH_NIBBLE
; 0x0204 = LOW_NIBBLE

; -----------------------------------------------------
; UTILITY: Print a single ASCII character in A
; -----------------------------------------------------
PRINT_CHAR:
    STA 0x00FF
    JMP PRINT_CHAR_RET

PRINT_CHAR_RET:
    NOP

; -----------------------------------------------------
; Convert nibble in A (0–15) to ASCII hex digit
; Stores output in A, then jumps to PRINT_CHAR
; -----------------------------------------------------
HEX_NIBBLE:
    ; if A < 10 → '0' + A
    LDBI #10
    SUB
    JZ LESS_THAN_10
    JNZ CHECK_LETTERS

LESS_THAN_10:
    ; A = (A_original) + '0'
    ; restore original nibble = A + 10
    LDBI #10
    ADD
    LDBI #48     ; '0'
    ADD
    JMP PRINT_CHAR

CHECK_LETTERS:
    ; restore original nibble: A + 10
    LDBI #10
    ADD
    ; A = nibble + 'A' - 10
    LDBI #55     ; 'A' = 65 → 65 - 10 = 55
    ADD
    JMP PRINT_CHAR

; -----------------------------------------------------
; Print the byte in A as two hex digits
; -----------------------------------------------------
PRINT_HEX:
    ; Save original A → TEMP
    STA 0x0202

    ; ----------------------------------------
    ; HIGH NIBBLE = A / 16  (via subtract loop)
    ; ----------------------------------------
    ; Load original A
    LDA 0x0202
    LDBI #16

HEX_DIV_LOOP_HIGH:
    SUB
    JZ HIGH_DONE
    JNZ HIGH_NEXT

HIGH_NEXT:
    ; Count how many times we subtracted 16
    LDB 0x0203      ; load counter
    LDBI #1
    ADD
    STA 0x0203      ; store counter
    JMP HEX_DIV_LOOP_HIGH

HIGH_DONE:
    ; A now equals high nibble
    STA 0x0203

    ; Print HIGH nibble
    LDA 0x0203
    JMP HEX_NIBBLE

PRINT_CHAR_RET_HIGHNIBBLE:
    NOP

    ; ----------------------------------------
    ; LOW NIBBLE = original A - (high_nibble * 16)
    ; ----------------------------------------
    ; Load original A
    LDA 0x0202
    LDB 0x0203

LOW_NIBBLE_LOOP:
    SUB
    LDBI #16
    SUB
    JNZ LOW_LOOP_CONT
    JZ LOW_LOOP_END

LOW_LOOP_CONT:
    JMP LOW_NIBBLE_LOOP

LOW_LOOP_END:
    ; now A = low nibble
    STA 0x0204

    ; Print low nibble
    LDA 0x0204
    JMP HEX_NIBBLE

PRINT_CHAR_RET_LOWNIBBLE:
    NOP

    ; Print space separator
    LDAI #' '
    JMP PRINT_CHAR

    NOP

; -----------------------------------------------------
; MAIN PROGRAM
; -----------------------------------------------------
START:
    ; Initialize memory counters
    LDAI #0
    STA 0x0203
    STA 0x0204

    ; F0 = 0
    LDAI #0
    STA 0x0200
    JMP PRINT_HEX

PRINT_CHAR_RET_F0:
    NOP

    ; F1 = 1
    LDAI #1
    STA 0x0201
    JMP PRINT_HEX

PRINT_CHAR_RET_F1:
    NOP

; MAIN LOOP
FIB_LOOP:
    ; TEMP = F0 + F1
    LDA 0x0200
    LDB 0x0201
    ADD
    STA 0x0202      ; TEMP

    ; Print TEMP
    LDA 0x0202
    JMP PRINT_HEX

PRINT_CHAR_RET_TEMP:
    NOP

    ; F0 = F1
    LDA 0x0201
    STA 0x0200

    ; F1 = TEMP
    LDA 0x0202
    STA 0x0201

    JMP FIB_LOOP

    HLT
