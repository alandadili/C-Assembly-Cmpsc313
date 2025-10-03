.data

    # data goes here
    aInput:  .word   1
    bInput:  .word   2
    cInput:  .word 3
    dInput: .word 4
    eInput: .word 5
    fInput: .word 6

.text

    # code goes here

.globl main
.ent main
main:

    # calling the function
    lw		$a0, aInput		#
    lw      $a1, bInput
    lw      $a2, cInput
    lw      $a3, dInput
    lw      $t0, eInput
    lw      $t1, fInput 
    
    # push eInput and fInput onto the stack
    subu		$sp, $sp, 8		# $sp = $sp - $t2
    sw		$t0, 0($sp)		# 
    sw		$t1, 4($sp)		# 
    
    # int result = addSix(1, 2, 3, 4, 5, 6);
    jal addSix
    move 	$t0, $v0		# $t0 = $v0

    #  printf("The result is: %dInput\n", result);
    li $v0, 1
    move 	$a0, $t0		# $a0 = $t0
    syscall

    # done
    li $v0, 10
    syscall

.end main


#
#   funcrtion addSix -> adds 6 inputs
#
#   input
#   A: $a0
#   B: $a1
#   C: $a2
#   D: $a3
#   E: stack
#   F: stack
#   Output: 
#       return value $v0
#
.globl addSix
.ent addSix
addSix:

    move 	$t0, $a0		# $t0 = $a0
    move    $t1, $a1
    move 	$t2, $a2		# $t2 = $a2
    move 	$t3, $a3		# $t3 = $a3
    lw		$t4, 0($sp)		# 
    lw		$t5, 4($sp)		# 
    
    # return aInput + bInput + cInput + dInput + eInput + fInput;
    li $v0, 0
    add		$v0, $v0, $t0		# $v0 = $v0 + $t0
    add		$v0, $v0, $t1		# $v0 = $v0 + $t1
    add		$v0, $v0, $t2		# $v0 = $v0 + $t2
    add		$v0, $v0, $t3		# $v0 = $v0 + $t3
    add		$v0, $v0, $t4		# $v0 = $v0 + $t4
    add		$v0, $v0, $t5		# $v0 = $v0 + $t5
    

    jr $ra
.end addSix

