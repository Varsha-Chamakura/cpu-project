; Hello World program (safe version, no character literals)

START:
    ; H
    LDAI #72
    STA 0x00FF

    ; e
    LDAI #101
    STA 0x00FF

    ; l
    LDAI #108
    STA 0x00FF

    ; l
    LDAI #108
    STA 0x00FF

    ; o
    LDAI #111
    STA 0x00FF

    ; ,
    LDAI #44
    STA 0x00FF

    ; space
    LDAI #32
    STA 0x00FF

    ; W
    LDAI #87
    STA 0x00FF

    ; o
    LDAI #111
    STA 0x00FF

    ; r
    LDAI #114
    STA 0x00FF

    ; l
    LDAI #108
    STA 0x00FF

    ; d
    LDAI #100
    STA 0x00FF

    ; !
    LDAI #33
    STA 0x00FF

    ; newline
    LDAI #10
    STA 0x00FF

    HLT
