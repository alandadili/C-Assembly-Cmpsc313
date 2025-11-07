.data

    # data goes here

.text

    # code goes here

.globl main
.ent main
main:

    #
    #   make the two objects

    # o1 = new o("hello:)
    # o1.print()

    # jal printHello

    # JALR -> jump and link register

    # get the memory address of the print hello function
    # lw		$t1, printHelloAddr		# 
    lw		$t1, jumpTable		#
    jalr $t1


    # o2 = new o("world")
    # o2.print()

    # jal printWorld

    # lw		$t1, printWorldAddr		# 
    lw		$t1, jumpTable+4		# 
    
    jalr $t1




    # done
    li $v0, 10
    syscall

.end main


#
#
#

.data

    # jump table
    # printHelloAddr: .word printHello
    # printWorldAddr: .word printWorld

    # jump table (take 2)
    jumpTable:
        .word printHello
        .word printWorld


.data
    msg1: .asciiz "hello "

.text

.globl printHello
.ent printHello
printHello:

    li $v0, 4
    la $a0, msg1
    syscall
    jr $ra
.end printHello

.data
    msg2: .asciiz "world!"

.text

.globl printWorld
.ent printWorld
printWorld:

    li $v0, 4
    la $a0, msg2
    syscall

    jr $ra
.end printWorld





