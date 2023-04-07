.eqv    PTR $s0
.eqv    BRK $t1

.macro change_ptr(%val)
    addi PTR, PTR, %val
.end_macro

.macro change_value(%val)
    lbu $t0, 0(PTR)
    addiu $t0, $t0, %val
    sb $t0, 0(PTR)
.end_macro

.macro read()
    li $v0, 12
    syscall
    sb $v0, 0(PTR)
.end_macro

.macro print()
    li $v0, 11
    lb $a0, 0(PTR)
    syscall
.end_macro

.macro exit()
    li $v0, 10
    syscall
.end_macro

.text
main:
    li $s0, 0x10010020
    read
    # Start Loop 0
    LOOP_0:
    lw      BRK, 0(PTR)
    bnez    BRK, L_OPEN_0
    j       L_CLOSE_0
    L_OPEN_0:
        change_ptr(4)
        read
        change_value(-10)
    j   LOOP_0
    L_CLOSE_0:
    # End Loop 0
    change_value(2)
    change_ptr(-4)
    # Start Loop 1
    LOOP_1:
    lw      BRK, 0(PTR)
    bnez    BRK, L_OPEN_1
    j       L_CLOSE_1
    L_OPEN_1:
        change_value(-1)
        change_ptr(4)
        change_value(-1)
        # Start Loop 2
        LOOP_2:
        lw      BRK, 0(PTR)
        bnez    BRK, L_OPEN_2
        j       L_CLOSE_2
        L_OPEN_2:
            change_ptr(4)
            change_value(1)
            change_ptr(8)
        j   LOOP_2
        L_CLOSE_2:
        # End Loop 2
        change_ptr(4)
        # Start Loop 3
        LOOP_3:
        lw      BRK, 0(PTR)
        bnez    BRK, L_OPEN_3
        j       L_CLOSE_3
        L_OPEN_3:
            change_value(1)
            # Start Loop 4
            LOOP_4:
            lw      BRK, 0(PTR)
            bnez    BRK, L_OPEN_4
            j       L_CLOSE_4
            L_OPEN_4:
                change_value(-1)
                change_ptr(-4)
                change_value(1)
                change_ptr(4)
            j   LOOP_4
            L_CLOSE_4:
            # End Loop 4
            change_ptr(4)
            change_value(1)
            change_ptr(8)
        j   LOOP_3
        L_CLOSE_3:
        # End Loop 3
        change_ptr(-20)
    j   LOOP_1
    L_CLOSE_1:
    # End Loop 1
    change_ptr(4)
    # Start Loop 5
    LOOP_5:
    lw      BRK, 0(PTR)
    bnez    BRK, L_OPEN_5
    j       L_CLOSE_5
    L_OPEN_5:
        change_value(-1)
    j   LOOP_5
    L_CLOSE_5:
    # End Loop 5
    change_ptr(-4)
    change_value(8)
    # Start Loop 6
    LOOP_6:
    lw      BRK, 0(PTR)
    bnez    BRK, L_OPEN_6
    j       L_CLOSE_6
    L_OPEN_6:
        change_ptr(4)
        change_value(6)
        change_ptr(-4)
        change_value(-1)
    j   LOOP_6
    L_CLOSE_6:
    # End Loop 6
    change_ptr(4)
    # Start Loop 7
    LOOP_7:
    lw      BRK, 0(PTR)
    bnez    BRK, L_OPEN_7
    j       L_CLOSE_7
    L_OPEN_7:
        change_ptr(4)
        change_value(1)
        change_ptr(-4)
        change_value(-1)
    j   LOOP_7
    L_CLOSE_7:
    # End Loop 7
    change_ptr(4)
    print
