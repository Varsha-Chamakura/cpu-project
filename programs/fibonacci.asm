; Fibonacci with readable HEX output
; Uses memory-mapped output at 0x00FF

; Memory:
; 0x0200 = F0 (current)
; 0x0201 = F1 (next)
; 0x0202 = TEMP (sum)
; 0x0203 = HIGH NIBBLE TEMP
; 0x0204 = LOW NIBBLE TEMP

; Convert a nibble (0-15) in A to ASCII hex char and print
PRINT_HEX_NIBBLE:
    ; If A < 10, add '0'
    LDBI #10
    SUB
    JZ PRINT_LETTERS
    JC PRINT_DIGIT

PRINT_LETTERS:
    ; A = A + 'A' - 10
    LDBI #10
    ADD
    LDBI #55       ; 'A' = 65, 65 - 10 = 55
    ADD
    STA 0x00FF
    JMP PRINT_HEX_END

PRINT_DIGIT:
    ; A = A + '0'
    LDBI #48       ; ASCII '0'
    ADD
    STA 0x00FF

PRINT_HEX_END:
    RET


; Print byte in A as two hex characters
PRINT_HEX_BYTE:
    ; HIGH nibble = A >> 4
    STA 0x0204      ; store original A
    LDA 0x0204
    LDBI #16
    DIV             ; A = A / 16  (HIGH nibble)    <-- If DIV unsupported, use SHIFT
    STA 0x0203      ; store HIGH nibble

    ; LOW nibble = original A % 16
    LDA 0x0204
    LDBI #16
    MOD             ; A % 16 (LOW nibble)
    STA 0x0204      ; store LOW nibble

    ; Print HIGH nibble
    LDA 0x0203
    JSR PRINT_HEX_NIBBLE

    ; Print LOW nibble
    LDA 0x0204
    JSR PRINT_HEX_NIBBLE

    ; Print a space
    LDAI #' '
    STA 0x00FF

    RET


; MAIN PROGRAM
START:
    ; F0 = 0
    LDAI #0
    STA 0x0200

    ; F1 = 1
    LDAI #1
    STA 0x0201

    ; Print F0
    LDA 0x0200
    JSR PRINT_HEX_BYTE

    ; Print F1
    LDA 0x0201
    JSR PRINT_HEX_BYTE

FIB_LOOP:
    ; TEMP = F0 + F1
    LDA 0x0200
    LDB 0x0201
    ADD
    STA 0x0202     ; TEMP

    ; Print TEMP
    LDA 0x0202
    JSR PRINT_HEX_BYTE

    ; F0 = F1
    LDA 0x0201
    STA 0x0200

    ; F1 = TEMP
    LDA 0x0202
    STA 0x0201

    JMP FIB_LOOP

    HLT
