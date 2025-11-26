; Very simple Fibonacci printer

START:
    ; Print 0
    LDAI #0
    STA 0x00FF

    ; Print 1
    LDAI #1
    STA 0x00FF

    ; Setup registers A=0, B=1
    LDAI #0
    LDBI #1

LOOP:
    ADD           ; A = A + B
    STA 0x00FF    ; print byte

    ; Swap A and B using TEMP at 0x0200
    STA 0x0200    ; TEMP = A
    LDA 0x0201    ; A = previous B
    LDB 0x0200    ; B = new value

    STA 0x0201    ; store updated B

    JMP LOOP

    HLT
