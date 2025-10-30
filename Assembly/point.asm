.data

    # data goes here
    x1Input: .asciiz "x1: "
    y1Input: .asciiz "y1: "
    x2Input: .asciiz "x2: "
    y2Input: .asciiz "y2: "
    newLine: .asciiz "\n"
    slopeMessage: .asciiz "Slope is: "

.text

    # code goes here

.globl main
.ent main
main:

    #     // make two points
    # P *p1 = (P *)malloc(sizeof(P));
    li $v0, 9
    la $a0, 8   # 2 ints
    syscall
    move 	$s0, $v0		# $s0 = $v0
    # P *p2 = (P *)malloc(sizeof(P));
    li $v0, 9
    la $a0, 8   # 2 ints
    syscall
    move 	$s1, $v0		# $s0 = $v0

    # collect all the input we need
    li $v0, 4
    la $a0, x1Input
    syscall
    li $v0, 5
    syscall
    move 	$t0, $v0		# $t0 = $v0

    li $v0, 4
    la $a0, y1Input
    syscall
    li $v0, 5
    syscall
    move 	$t1, $v0		# $t0 = $v0

    li $v0, 4
    la $a0, x2Input
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

    # p1->x = x1;
    sw		$t0, 0($s0)		# 

    # p1->y = y1;
    sw		$t1, 4($s0)		# 

    # p2->x = x2;
    sw		$t2, 0($s1)		# 

    # p2->y = y2;
    sw		$t3, 4($s1)		# 


    # int m = slope(p1, p2);
    move 	$a0, $s0		# $a0 = $s0
    move 	$a1, $s1		# $a1 = $s1
    jal		slope				# jump to slope and save position to $ra
    move 	$t0, $v0		# $t0 = $v0

    # printf("Slope is: %d\n", m);
    li $v0, 4
    la $a0, slopeMessage
    syscall
    li $v0, 1
    move 	$a0, $t0		# $a0 = $t0
    syscall
    li $v0, 4
    la $a0, newLine
    syscall


    # //  free memory
    # free(p1);
    # free(p2);




    # done
    li $v0, 10
    syscall

.end main


# slope function
# input a0, a1 (two points)
.globl slope
.ent slope
slope:

    # preserve s0, s1
    sub	    $sp, $sp, 8			# $sp = $sp - 8
    sw		$s0, 0($sp)		# 
    sw		$s1, 4($sp)		# 
    
    # p1
    move 	$t0, $a0		# $t0 = $a0
    
    # p2
    move 	$t1, $a1		# $t1 = $a1

    # p2->x - p1->x
    lw		$t2, 0($s1)		#   p2.x
    lw		$t3, 0($s0)		#   p1.x
    sub		$t4, $t2, $t3		# $t4 = $t2 - $t3
    beq		$t4, 0, undefinedSlope	# if $t4 >= 0 then goto undefinedSlope
    lw		$t4, 4($s1)		#   p2.y
    lw		$t5, 4($s0)		#   p1.y

    # (p2->y - p1->y)
    sub		$t6, $t4, $t5		# $t6 = $t4 - $t5

    # (p2->x - p1->x)
    sub		$t7, $t2, $t3		# $t7 = $t2 - $t3
    
    # int m = (p2->y - p1->y) / (p2->x - p1->x);
    div     $v0, $t6, $t7

    # // printf("Slope between points (%d, %d) and (%d, %d) is: %d\n", p1->x, p1->y, p2->x, p2->y, m);
    # return m;
    j doneSlope
    
undefinedSlope:
    # if (p2->x - p1->x == 0) {
    #     // printf("Slope is undefined (vertical line).\n");
    #     return 0; // or some other indication of undefined slope
    # }
    li $v0, 0
    j doneSlope




doneSlope:
    # restore s0 and s1
    lw		$s0, 0($sp)		#
    lw		$s1, 4($sp)		# 
    addi	$sp, $sp, 8			# $sp = $sp + 4

    jr $ra
.end slope