.data

    # data goes here

    #     int a[] = {19, 17, 15, 13, 11};
    aInput: .word 19, 17, 15, 13, 11

    # int b[] = {34, 32, 31, 35, 34};
    bInput: .word 34, 32, 31, 35, 34

    # int *c = cSideStats(a, b);
    # cOutput: .word -1, -1, -1, -1, -1
    cOutput: .space 20

    length: .word 5
    whiteSpace: .asciiz " "
    newLine: .asciiz "\n"
    resultMessage: .asciiz "The results are:\n"

.text

    
.globl main
.ent main
main:


    # code goes here

    # int *c = cSideStats(a, b);
    la		$a0, aInput		#
    la		$a1, bInput		#
    jal cSideStats

    # // print the results
    # printf("The results are:\n");
    li $v0, 4
    la $a0, resultMessage
    syscall

    la $t0, cOutput
    li $t1, 0   # int i = 0
    lw		$t2, length
    # for (int i = 0; i < 5; i++) {
mainLoop:
    bge		$t1, $t2, doneMain	# if $t1 >= $t2 then goto doneMain
    
        #     printf("%d ", c[i]);
        # find c[i]
        mul $t3, $t1, 4
        add		$t4, $t3, $t0		# $t4 = $t3 + $t1
        lw		$t5, ($t4)		# 
        li $v0, 1
        move 	$a0, $t5		# $a0 = $t5 
        syscall
        li $v0, 4
        la $a0, whiteSpace
        syscall    

        # i++
        addi $t1, $t1, 1
    
        j mainLoop
    # }


    # printf("\n");
    li $v0, 4
    la $a0, newLine
    syscall 

doneMain:
    # done
    li $v0, 10
    syscall

.end main

.globl cSideStats
.ent cSideStats
cSideStats:

    # since this is a non-leaf function,
    # we need to preserve the $ra
    subu $sp, $sp, 4
    sw		$ra, 0($sp)		# 
    
    # static int c[5];
    la $s0, cOutput
    li $s1, 0   # int i = 0
    lw		$s2, length

    # for (int i = 0; i < 5; i++) {
cSideStatsLoop:
    bge		$s1, $s2, doneCSideStats	# if $t1 >= $t2 then goto doneMain

        #     int aSquared = a[i] * a[i];
        la		$t8, aInput		#
        mul $t3, $s1, 4
        add $t3, $t3, $t8
        lw		$t4, ($t3)		# a[i]
        mul $t4, $t4, $t4       # a[i] * a[i]
        
        
        #     int bSquared = b[i] * b[i];
        la		$t8, bInput		#
        mul $t3, $s1, 4
        add $t3, $t3, $t8
        lw		$t5, ($t3)		# b[i]
        mul $t5, $t5, $t5       # b[i] * b[i]

        #     int cResult = sqrt(aSquared + bSquared);
        add		$a0, $t4, $t5		# $a0 = $t4 + $t5
        
        jal sqrt
        move 	$t6, $v0		# $t6 = $v0 (C result)

        #     c[i] = cResult;
        mul $t7, $s1, 4         
        add $t7, $t7, $s0
        sw		$t6, 0($t7)		# 
        

    # }
    # return c;

        # i++
        addi $s1, $s1, 1
    
        j cSideStatsLoop


doneCSideStats:

    # restore the return address
    lw		$ra, 0($sp)		# 
    addu    $sp, $sp, 4
    

    jr $ra
.end cSideStats


#
#   use the newton method for calc
#
#   idea :
#       x = N
#       iterate 20 times
#           x` = (x + N/x) / 2
#           x = x`

.globl sqrt
.ent sqrt
sqrt:
    move $v0, $a0
    li $t0, 0   # counter
sqrtLoop:
    div $t1, $a0, $v0   # N/x
    add $v0, $t1, $v0   # x + N/x
    div $v0, $v0, 2     # (x + N/x) / 2

    add $t0, $t0, 1     # i++
    blt $t0, 20, sqrtLoop

    jr $ra
.end sqrt