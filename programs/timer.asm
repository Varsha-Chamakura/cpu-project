; =====================================================
; Timer-like example
; Prints '.' 10 times with a software delay loop.
; Uses only: LDAI LDBI LDA LDB STA ADD SUB JMP JZ JNZ HLT
; =====================================================

; Memory layout:
; 0x0300 = DELAY   (counts down to 0)
; 0x0301 = DOT_CNT (how many '.' remain to print)

START:
    ; DOT_CNT = 10
    LDAI #10
    STA 0x0301

MAIN_LOOP:
    ; print '.'
    LDAI #'.'
    STA 0x00FF

    ; DELAY = 80  (arbitrary delay length)
    LDAI #80
    STA 0x0300

DELAY_LOOP:
    ; DELAY = DELAY - 1
    LDA 0x0300
    LDBI #1
    SUB
    STA 0x0300

    ; if DELAY == 0 → exit delay loop
    JZ DELAY_DONE

    ; else continue delaying
    JMP DELAY_LOOP

DELAY_DONE:
    ; DOT_CNT = DOT_CNT - 1
    LDA 0x0301
    LDBI #1
    SUB
    STA 0x0301

    ; if DOT_CNT == 0 → done
    JZ DONE

    ; else print next dot
    JMP MAIN_LOOP

DONE:
    HLT
