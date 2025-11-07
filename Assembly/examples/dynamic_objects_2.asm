.data

    # data goes here
    openParen: .asciiz "("
    comma: .asciiz ","
    closeParen: .asciiz ") \n"
    x1: .word 3
    y1: .word 1
    x2: .word 0
    y2: .word 5

.text

    # code goes here

.globl main
.ent main
main:

    # load the two objects
    # la $s0, point1

    # build the object
    li $v0, 9
    li $a0, 16
    syscall
    sw		$v0, point1		# 
    
    # build the jump table
    lw $t0, x1
    sw		$t0, 0($v0)		# X
    lw $t0, y1
    sw      $t0, 4($v0)     # y
    la $t0, slope
    sw		$t0, 8($v0)		# slope()
    la $t0, print
    sw		$t0, 12($v0)		# print()
    move 	$s0, $v0		# $s0 = $v0

    # la $s1, point2
    li $v0, 9
    li $a0, 16
    syscall
    sw		$v0, point2		# 

    # build the jump table
    lw $t0, x2
    sw		$t0, 0($v0)		# X
    lw $t0, y2
    sw      $t0, 4($v0)     # y
    la $t0, slope
    sw		$t0, 8($v0)		# slope()
    la $t0, print
    sw		$t0, 12($v0)		# print()
    move 	$s1, $v0		# $s0 = $v0

    # point1.print()
    move 	$a0, $s0		    # $a0 = $s0 (arg)
    lw		$s2, 12($s0)		# print() jump table
    jalr $s2
    
    # point2.print()
    move 	$a0, $s1		    # $a0 = $s0 (arg)
    lw		$s2, 12($s1)		# print() jump table
    jalr $s2

    # point1.slope(point2)
    move 	$a0, $s0		# $a0 = $s0
    move 	$a1, $s1		# $a1 = $s1
    lw		$s2, 8($s1)		# slope() jump table
    jalr $s2
    move 	$t0, $v0		# $t0 = $v0 (result)

    # print the slope
    li $v0, 1
    move 	$a0, $t0		# $a0 = $t0
    syscall

    # done
    li $v0, 10
    syscall

.end main

.data

# dynamic
point1: .word 0
point2: .word 0

# point1: (16 bytes)
#     .word 3 # x     # 0
#     .word 1 # y     # 4
#     .word slope     # 8
#     .word print     # 12

# point2:
#     .word 0 # x
#     .word 5 # y
#     .word slope
#     .word print 

# methods

.text

.globl print
.ent print 
print:

    # input: object in $a0
    lw		$t0, 0($a0)		# X
    lw		$t1, 4($a0)		# Y
     
    li $v0, 4
    la $a0, openParen
    syscall

    li $v0, 1
    move 	$a0, $t0		# $a0 = $t0
    syscall

    li $v0, 4
    la $a0, comma
    syscall

    li $v0, 1
    move 	$a0, $t1		# $a0 = $t1
    syscall

    li $v0, 4
    la $a0, closeParen
    syscall


    jr $ra
.end print

.globl slope
.ent slope
slope:

    # point 0 is in a0, point 1 is in a1
    lw		$t0, 0($a0)		# X1
    lw		$t1, 4($a0)		# Y1
    lw		$t2, 0($a1)		# X2
    lw		$t3, 4($a1)		# Y2

    # TODO handle invalid slope!

    # m = (Y2-Y1) / (X2-X1)

    # (Y2-Y1)
    sub		$t4, $t3, $t1		# $t4 = $t3 - $t1
    
    # (X2-X1)
    sub		$t5, $t2, $t0		# $t5 = $t2 - $t0
    
    # m = 
    div $v0, $t4, $t5

    jr $ra
.end slope
