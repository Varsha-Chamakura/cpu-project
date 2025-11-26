; =====================================================
; Simple Fibonacci generator for your CPU
; Uses ONLY: LDAI LDBI LDA LDB STA ADD SUB JMP JZ JNZ HLT
; Prints raw 8-bit Fibonacci values to memory-mapped I/O (0x00FF)
; =====================================================

; Memory layout:
; 0x0200 = F0   (current value)
; 0x0201 = F1   (next value)
; 0x0202 = TEMP (sum)
; 0x0203 = COUNT (loop counter)

START:
    ; F0 = 0
    LDAI #0
    STA 0x0200

    ; F1 = 1
    LDAI #1
    STA 0x0201

    ; COUNT = 10  (we will print 10 more values after the first two)
    LDAI #10
    STA 0x0203

    ; --- print initial two values ---

    ; print F0
    LDA 0x0200
    STA 0x00FF

    ; print F1
    LDA 0x0201
    STA 0x00FF

FIB_LOOP:
    ; TEMP = F0 + F1
    LDA 0x0200      ; A = F0
    LDB 0x0201      ; B = F1
    ADD             ; A = F0 + F1
    STA 0x0202      ; TEMP = A

    ; print TEMP
    STA 0x00FF

    ; F0 = F1
    LDA 0x0201
    STA 0x0200

    ; F1 = TEMP
    LDA 0x0202
    STA 0x0201

    ; COUNT = COUNT - 1
    LDA 0x0203
    LDBI #1
    SUB
    STA 0x0203

    ; if COUNT == 0, stop
    JZ DONE

    ; else, loop again
    JMP FIB_LOOP

DONE:
    HLT
