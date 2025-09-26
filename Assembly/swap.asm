.data

    # data goes here
    a: .word 5
    bVal: .word 6
    space: .asciiz " "
    newline: .asciiz "\n"

.text

    # code goes here

.globl main
.ent main
main:


    # //  swapping two integers
    # int a = 5;
    # li $t0, 5
    lw $t0, a

    # int b = 6;
    lw $t1, bVal

    # int temp;
    # temp = a;
    move $t2, $t0

    # a = b;
    move $t0, $t1
    sw $t0, a

    # b = temp;
    move $t1, $t2
    sw		$t1, bVal 
    

    # printf("a = %d, b = %d\n", a, b); // 6 5
    li $v0, 1
    move $a0, $t0
    syscall

    li $v0, 4
    la $a0, space
    syscall

    li $v0, 1
    move $a0, $t1
    syscall

    li $v0, 4
    la $a0, newline
    syscall




    # done
    li $v0, 10
    syscall

.end main