.data
    radius_input: .asciiz "Enter r"
    error_msg: .asciiz "Error Negative Number"
    volume_message: .asciiz "Volume total: "
    pi_value: .word 3.14159
    volume: .word 0
    four_div_3: .word 1.3333333

.text
.globl main

main:
    li $v0, 4
    la $a0, radius_input
    syscall

    li $v0, 5
    syscall
    move $t0,$v0

loop_label:
    bgtz,$t0, body_label
    li $v0, 4
    la $a0, error_msg

    li $v0, 4
    la $a0, radius_input

    li $v0, 5
    syscall
    move $t0,$v0

    j loop_label


body_label:

    mtc1,$t0,$f6
    cvt.d.w,$f6,$f6
    mul.d $f12,$f6,$f6
    mul.d $f12,$f12,$f6
    l.d, $f8, pi_value
    l.d, $f10, four_div_3
    mul.d $f12, $f12, $f8
    mul.d $f12, $f12, $f10
    s.d $f12, volume

    li $v0,4
    la, $a0, volume_message
    syscall

    li $v0,3
    move.d $f12, volume
    syscall

.end main