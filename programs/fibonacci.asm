; Simple Fibonacci that actually works

; Memory layout:
; 0x0200 = F0 (current)
; 0x0201 = F1 (next)
; 0x0202 = TEMP

START:
    ; Initialize F0 = 0
    LDAI #0
    STA 0x0200
    STA 0x00FF    ; print 0

    ; Initialize F1 = 1
    LDAI #1
    STA 0x0201
    STA 0x00FF    ; print 1

LOOP:
    ; TEMP = F0 + F1
    LDA 0x0200    ; A = F0
    LDB 0x0201    ; B = F1
    ADD           ; A = A + B
    STA 0x0202    ; TEMP = A

    ; print TEMP
    STA 0x00FF

    ; F0 = F1
    LDA 0x0201
    STA 0x0200

    ; F1 = TEMP
    LDA 0x0202
    STA 0x0201

    JMP LOOP

    HLT
