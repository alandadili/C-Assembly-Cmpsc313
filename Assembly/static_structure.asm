.data

    # data goes here

    # struct OtherPoint {
    #     int x;
    #     int y;
    # };

    # struct OtherPoint p1 = {x1, y1};
    p1: .space 8

    # struct OtherPoint p2 = {x2, y2};
    p2: .space 8

    newLine: .asciiz "\n"
    x1Input: .asciiz "enter x1: "
    x2Input: .asciiz "enter x2: "
    y1Input: .asciiz "enter y1: "
    y2Input: .asciiz "enter y2: "
    openParen: .asciiz "("
    comma: .asciiz ", "
    closeParen: .asciiz ")"


.text

    # code goes here

.globl main
.ent main
main:

    # collect the input
    li $v0, 4
    la $a0, x1Input
    syscall
    li $v0, 5
    syscall
    move 	$t0, $v0		# $t0 = $v0

    li $v0, 4
    la $a0, x2Input
    syscall
    li $v0, 5
    syscall
    move 	$t1, $v0		# $t0 = $v0

    li $v0, 4
    la $a0, y1Input
    syscall
    li $v0, 5
    syscall
    move 	$t2, $v0		# $t0 = $v0

    li $v0, 4
    la $a0, y2Input
    syscall
    li $v0, 5
    syscall
    move 	$t3, $v0		# $t0 = $v0

    # load the two points from memory
    la		$t4, p1		# 
    la      $t5, p2

    # struct OtherPoint p1 = {x1, y1};
    sw		$t0, 0($t4)		# x1
    sw      $t2, 4($t4)         # y1
    
    # struct OtherPoint p2 = {x2, y2};
    sw		$t1, 0($t5)		# x2
    sw      $t3, 4($t5)         # y2

    move 	$a0, $t4		# $a0 = $t4
    jal print_point
    move 	$a0, $t5		# $a0 = $t5
    jal print_point

    # done
    li $v0, 10
    syscall

.end main

# input -> a0
.globl print_point
.ent print_point
print_point:

    # move the argument into t0
    move 	$t0, $a0		# $t0 = $a0

    # printf("(%d, %d)", point.x, point.y);
    li $v0, 4
    la $a0, openParen
    syscall

    # point.x
    li $v0, 1
    lw $a0, 0($t0)   # point.x
    syscall

    li $v0, 4
    la $a0, comma
    syscall

    # point.y
    li $v0, 1
    lw $a0, 4($t0)   # point.y
    syscall

    li $v0, 4
    la $a0, closeParen
    syscall


    jr $ra
.end print_point
