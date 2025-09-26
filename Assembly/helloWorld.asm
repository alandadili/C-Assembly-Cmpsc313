.data

    # data goes here
    outputMessage: .asciiz "Hello World! \n"

.text

    # code goes here

.globl main
.ent main
main:

    jal helloWorld



    # done
    li $v0, 10
    syscall

.end main


# 
#   function helloWorld()
#
.globl helloWorld
.ent helloWorld
helloWorld:

    li $v0, 4
    la $a0, outputMessage
    syscall

    jr $ra
.end helloWorld

