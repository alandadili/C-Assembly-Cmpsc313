.data

    # data goes here
array: .word 1, 3, 5, 7, 9, 11, 13, 15, 17, 19
        .word 21, 23, 25, 27, 29, 31, 33, 35, 37, 39
        .word 41, 43, 45, 47, 49, 51, 53, 55, 57, 59
arraySize: .word 30

.text

    # code goes here

.globl main
.ent main
main:

    # get the memory address of the array
    la $t0, array
    lw $t1, arraySize

    # find A= array[len/2]
    li $t2, 2
    div $t3, $t1, $t2
    mul $t3, $t3, 4
    add $t4, $t0, $t3
    lw $t5, ($t4)

    # find B= array[len/2-1]
    div $t3, $t1, $t2
    sub $t3, $t3, 1
    mul $t3, $t3, 4
    add $t4, $t0, $t3
    lw $t6, ($t4)

    # sum C=A+B
    add $t7, $t5, $t6

    # med = C/2
    div $t7, $t7, 2

    # output the median
    li $v0, 1
    move $a0, $t7
    syscall


    # done
    li $v0, 10
    syscall

.end main