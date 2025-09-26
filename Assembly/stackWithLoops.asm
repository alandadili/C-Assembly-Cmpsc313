.data

    # data goes here
    a: .word 7, 19, 37
    arrayLength: .word 3
    space: .asciiz " "
    newLine: .asciiz "\n"
    debug: .asciiz "debug"

.text

    # code goes here

.globl main
.ent main
main:

    # (1) print the array
    la		$t0, a		# 
    lw		$t1, arrayLength		# 
    li		$t2, 0		# $t2 = 0
outerLoop:
    bge		$t2, $t1, doneOuterLoop	# if $t2 >= $t1 then goto doneOuterLoop

        # find data[i]
        mul $t3, $t2, 4
        add		$t4, $t3, $t0		# $t4 = $t3 + $t0
        lw		$t4, ($t4)		# 

        # print the data
        li $v0, 1
        move 	$a0, $t4		# $a0 = $t4
        syscall
        li $v0, 4
        la $a0, space  
        syscall

        addi	$t2, $t2, 1			# $t2 = $t2 + 1
        j outerLoop
doneOuterLoop:
        li $v0, 4
        la $a0, newLine
        syscall

    # (2) stack operations

    #
    #   PUSH LOOP
    #
    lw $t0, arrayLength
    li $t1, 0   # i=0
    la $t2, a
pushLoop:
    bge		$t1, $t0, endPushLoop	# if $t1 >= $t0 then goto endPushLoop
    
    # get data[i]
    mul $t4, $t1, 4
    add $t5, $t2, $t4
    lw		$t6, 0($t5)		# 
    

    # push data[i] onto the stack
    subu $sp, $sp, 4
    sw  $t6, ($sp)

    addi $t1, $t1, 1    #i++

    # li $v0, 1
    # move $a0, $t1
    # syscall
    # li $v0, 4
    # la $a0, space
    # syscall

    j pushLoop

    # la $t8, a
    # lw $t0, 0($t8) # a[0]
    # lw $t1, 4($t8) # a[1]
    # lw $t2, 8($t8) # a[2]

    # # 2.1 push a[0]
    # subu $sp, $sp, 4
    # sw		$t0, ($sp)		# 
    
    # # 2.2 push a[1]
    # subu $sp, $sp, 4
    # sw		$t1, ($sp)		# 
    
    # # 2.3 push a[2]
    # subu    $sp, $sp, 4
    # sw		$t2, ($sp)		# 

endPushLoop:


# li $v0, 4
# la $a0, debug
# syscall

    #
    #   POP LOOP
    #

    lw $t0, arrayLength
    li $t1, 0   # i=0
    la $t2, a
popLoop:
    bge		$t1, $t0, endPopLoop	# if $t1 >= $t0 then goto endPushLoop   

    # pop off the stack into $t4
    lw $t4, ($sp)
    addi	$sp, $sp, 4			# $sp = $sp + 4
    
    # data[i] = $sp
    mul $t5, $t1, 4
    add		$t6, $t5, $t2		# $t6 = $t5 + $t2
    sw		$t4, 0($t6)		# 
    
    addi $t1, $t1, 1    #i++
    j popLoop

    # # 2.4 pop a[0]
    # lw		$t3, ($sp)		# 
    # addi	$sp, $sp, 4			# $sp = $sp + 4
    # sw		$t3, 0($t8)		# 
    
    # # 2.5 pop a[1]
    # lw  $t3, ($sp)
    # addi	$sp, $sp, 4			# $sp = $sp + 4
    # sw      $t3, 4($t8)

    # # 2.6 pop a[2]
    # lw $t3, ($sp)
    # addi	$sp, $sp, 4			# $sp = $sp + 4
    # sw  $t3, 8($t8)
endPopLoop:    

    # (3) print the array after modifications
    la		$t0, a		# 
    lw		$t1, arrayLength		# 
    li		$t2, 0		# $t2 = 0
outerLoop2:
    bge		$t2, $t1, doneOuterLoop2	# if $t2 >= $t1 then goto doneOuterLoop

        # find data[i]
        mul $t3, $t2, 4
        add		$t4, $t3, $t0		# $t4 = $t3 + $t0
        lw		$t4, ($t4)		# 

        # print the data
        li $v0, 1
        move 	$a0, $t4		# $a0 = $t4
        syscall
        li $v0, 4
        la $a0, space  
        syscall

        addi	$t2, $t2, 1			# $t2 = $t2 + 1
        j outerLoop2
doneOuterLoop2:
        li $v0, 4
        la $a0, newLine
        syscall





    # done
    li $v0, 10
    syscall

.end main