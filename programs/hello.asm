; Hello World program

START:
    LDAI #'H'
    STA 0x00FF

    LDAI #'e'
    STA 0x00FF

    LDAI #'l'
    STA 0x00FF

    LDAI #'l'
    STA 0x00FF

    LDAI #'o'
    STA 0x00FF

    LDAI #','
    STA 0x00FF

    LDAI #' '
    STA 0x00FF

    LDAI #'W'
    STA 0x00FF

    LDAI #'o'
    STA 0x00FF

    LDAI #'r'
    STA 0x00FF

    LDAI #'l'
    STA 0x00FF

    LDAI #'d'
    STA 0x00FF

    LDAI #'!'
    STA 0x00FF

    LDAI #10    ; newline (NOT #'\n', avoids stoi errors)
    STA 0x00FF

    HLT
