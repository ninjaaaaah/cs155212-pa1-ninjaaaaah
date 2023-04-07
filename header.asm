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
