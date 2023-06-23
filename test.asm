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
    change_ptr(4)
    change_value(10)
    change_ptr(4)
    change_value(1)
    change_ptr(4)
    change_value(1)
    # Start Loop 0
    LOOP_0:
    lw      BRK, 0(PTR)
    bnez    BRK, L_OPEN_0
    j       L_CLOSE_0
    L_OPEN_0:
        # Start Loop 1
        LOOP_1:
        lw      BRK, 0(PTR)
        bnez    BRK, L_OPEN_1
        j       L_CLOSE_1
        L_OPEN_1:
            change_value(5)
            # Start Loop 2
            LOOP_2:
            lw      BRK, 0(PTR)
            bnez    BRK, L_OPEN_2
            j       L_CLOSE_2
            L_OPEN_2:
                change_ptr(4)
                change_value(8)
                change_ptr(-4)
                change_value(-1)
            j   LOOP_2
            L_CLOSE_2:
            # End Loop 2
            change_ptr(4)
            print
            change_ptr(-4)
            change_value(6)
            # Start Loop 3
            LOOP_3:
            lw      BRK, 0(PTR)
            bnez    BRK, L_OPEN_3
            j       L_CLOSE_3
            L_OPEN_3:
                change_ptr(4)
                change_value(-8)
                change_ptr(-4)
                change_value(-1)
            j   LOOP_3
            L_CLOSE_3:
            # End Loop 3
            change_value(1)
            change_ptr(-12)
        j   LOOP_1
        L_CLOSE_1:
        # End Loop 1
        change_ptr(4)
        print
        change_ptr(8)
        # Start Loop 4
        LOOP_4:
        lw      BRK, 0(PTR)
        bnez    BRK, L_OPEN_4
        j       L_CLOSE_4
        L_OPEN_4:
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
            # Start Loop 6
            LOOP_6:
            lw      BRK, 0(PTR)
            bnez    BRK, L_OPEN_6
            j       L_CLOSE_6
            L_OPEN_6:
                change_ptr(4)
                change_value(1)
                change_ptr(-4)
                change_value(-1)
            j   LOOP_6
            L_CLOSE_6:
            # End Loop 6
            change_ptr(8)
            # Start Loop 7
            LOOP_7:
            lw      BRK, 0(PTR)
            bnez    BRK, L_OPEN_7
            j       L_CLOSE_7
            L_OPEN_7:
                change_ptr(-8)
                change_value(1)
                change_ptr(4)
                change_value(1)
                change_ptr(4)
                change_value(-1)
            j   LOOP_7
            L_CLOSE_7:
            # End Loop 7
            change_ptr(-4)
            # Start Loop 8
            LOOP_8:
            lw      BRK, 0(PTR)
            bnez    BRK, L_OPEN_8
            j       L_CLOSE_8
            L_OPEN_8:
                change_ptr(4)
                change_value(1)
                change_ptr(-4)
                change_value(-1)
                # Start Loop 9
                LOOP_9:
                lw      BRK, 0(PTR)
                bnez    BRK, L_OPEN_9
                j       L_CLOSE_9
                L_OPEN_9:
                    change_ptr(4)
                    change_value(1)
                    change_ptr(-4)
                    change_value(-1)
                    # Start Loop 10
                    LOOP_10:
                    lw      BRK, 0(PTR)
                    bnez    BRK, L_OPEN_10
                    j       L_CLOSE_10
                    L_OPEN_10:
                        change_ptr(4)
                        change_value(1)
                        change_ptr(-4)
                        change_value(-1)
                        # Start Loop 11
                        LOOP_11:
                        lw      BRK, 0(PTR)
                        bnez    BRK, L_OPEN_11
                        j       L_CLOSE_11
                        L_OPEN_11:
                            change_ptr(4)
                            change_value(1)
                            change_ptr(-4)
                            change_value(-1)
                            # Start Loop 12
                            LOOP_12:
                            lw      BRK, 0(PTR)
                            bnez    BRK, L_OPEN_12
                            j       L_CLOSE_12
                            L_OPEN_12:
                                change_ptr(4)
                                change_value(1)
                                change_ptr(-4)
                                change_value(-1)
                                # Start Loop 13
                                LOOP_13:
                                lw      BRK, 0(PTR)
                                bnez    BRK, L_OPEN_13
                                j       L_CLOSE_13
                                L_OPEN_13:
                                    change_ptr(4)
                                    change_value(1)
                                    change_ptr(-4)
                                    change_value(-1)
                                    # Start Loop 14
                                    LOOP_14:
                                    lw      BRK, 0(PTR)
                                    bnez    BRK, L_OPEN_14
                                    j       L_CLOSE_14
                                    L_OPEN_14:
                                        change_ptr(4)
                                        change_value(1)
                                        change_ptr(-4)
                                        change_value(-1)
                                        # Start Loop 15
                                        LOOP_15:
                                        lw      BRK, 0(PTR)
                                        bnez    BRK, L_OPEN_15
                                        j       L_CLOSE_15
                                        L_OPEN_15:
                                            change_ptr(4)
                                            change_value(1)
                                            change_ptr(-4)
                                            change_value(-1)
                                            # Start Loop 16
                                            LOOP_16:
                                            lw      BRK, 0(PTR)
                                            bnez    BRK, L_OPEN_16
                                            j       L_CLOSE_16
                                            L_OPEN_16:
                                                change_ptr(4)
                                                change_value(1)
                                                change_ptr(-4)
                                                change_value(-1)
                                                # Start Loop 17
                                                LOOP_17:
                                                lw      BRK, 0(PTR)
                                                bnez    BRK, L_OPEN_17
                                                j       L_CLOSE_17
                                                L_OPEN_17:
                                                    change_ptr(4)
                                                    # Start Loop 18
                                                    LOOP_18:
                                                    lw      BRK, 0(PTR)
                                                    bnez    BRK, L_OPEN_18
                                                    j       L_CLOSE_18
                                                    L_OPEN_18:
                                                        change_value(-1)
                                                    j   LOOP_18
                                                    L_CLOSE_18:
                                                    # End Loop 18
                                                    change_ptr(4)
                                                    change_value(1)
                                                    change_ptr(4)
                                                    change_value(1)
                                                    change_ptr(-12)
                                                    change_value(-1)
                                                    # Start Loop 19
                                                    LOOP_19:
                                                    lw      BRK, 0(PTR)
                                                    bnez    BRK, L_OPEN_19
                                                    j       L_CLOSE_19
                                                    L_OPEN_19:
                                                        change_ptr(4)
                                                        change_value(1)
                                                        change_ptr(-4)
                                                        change_value(-1)
                                                    j   LOOP_19
                                                    L_CLOSE_19:
                                                    # End Loop 19
                                                j   LOOP_17
                                                L_CLOSE_17:
                                                # End Loop 17
                                            j   LOOP_16
                                            L_CLOSE_16:
                                            # End Loop 16
                                        j   LOOP_15
                                        L_CLOSE_15:
                                        # End Loop 15
                                    j   LOOP_14
                                    L_CLOSE_14:
                                    # End Loop 14
                                j   LOOP_13
                                L_CLOSE_13:
                                # End Loop 13
                            j   LOOP_12
                            L_CLOSE_12:
                            # End Loop 12
                        j   LOOP_11
                        L_CLOSE_11:
                        # End Loop 11
                    j   LOOP_10
                    L_CLOSE_10:
                    # End Loop 10
                j   LOOP_9
                L_CLOSE_9:
                # End Loop 9
            j   LOOP_8
            L_CLOSE_8:
            # End Loop 8
            change_value(1)
            change_ptr(12)
        j   LOOP_4
        L_CLOSE_4:
        # End Loop 4
        change_ptr(-12)
    j   LOOP_0
    L_CLOSE_0:
    # End Loop 0
    # Start Loop 20
    LOOP_20:
    lw      BRK, 0(PTR)
    bnez    BRK, L_OPEN_20
    j       L_CLOSE_20
    L_OPEN_20:
        print
    j   LOOP_20
    L_CLOSE_20:
    # End Loop 20
