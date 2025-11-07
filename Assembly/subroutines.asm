.data

    # data goes here
    msg: .asciiz "hello world!"

.text

    # code goes here

.globl main
.ent main
main:


    # how do we call the subroutine?
    jal print



    # done
    li $v0, 10
    syscall

.end main

#
#   subroutines

.globl print
.ent print
print:

    li $v0, 4
    la $a0, msg
    syscall

    jr $ra

.end print





