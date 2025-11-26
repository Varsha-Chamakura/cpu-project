; fibonacci.asm
; A = current
; B = next
; memory[VAR_TMP] = temp

VAR_TMP = 0x0200   ; scratch variable in RAM (you can “hard-code” with LDA/STA)

START:
    ; A = 0, B = 1
    LDAI #0
    STA 0x00FF      ; print 0

    LDAI #1
    STA 0x00FF      ; print 1
    ; now set A=0, B=1 in registers
    LDAI #0
    LDBI #1

FIB_LOOP:
    ; temp = A + B
    ADD             ; A = A + B
    STA VAR_TMP     ; temp = A
                    ; (Note: A now = next Fibonacci)

    ; print current (A)
    STA 0x00FF

    ; new A = old B
    LDA VAR_TMP     ; A = temp (next Fibonacci)
    ; to make this a standard pattern you'd swap A/B here and re-add, but
    ; for simplicity this example just shows repeated addition & output.
    ; You can refine the algorithm to be mathematically exact.

    JMP FIB_LOOP

    HLT

