.data

    # data goes here
    inputMessage: .asciiz "Enter a number: "
    newLine: .asciiz "\n"
    ten: .word 10

.text

.globl main
.ent main
main:

    # code goes here    

    # //  ask the user for a number
    # printf("Enter a number: ");
    # scanf("%d", &num);
    li $v0, 4
    la $a0, inputMessage
    syscall
    li $v0, 5
    syscall
    move 	$a0, $v0		# $a0 = $v0

    # print_vertical(num);
    jal print_vertical

    # return 0;

    # done
    li $v0, 10
    syscall

.end main


#
#   print_vertical
#   input: a0 -> number to print
#
.globl print_vertical
.ent print_vertical
print_vertical:

    # move the argument into a saved register
    move 	$s0, $a0		# $s0 = $a0

    # push the RA onto the stack (and the s0)
    subu	$sp, $sp, 8			# $sp = $sp - 4
    sw		$ra, 0($sp)		# 
    sw		$s0, 4($sp)		# 
    

    # if (arg < 10) {
    blt		$s0, 10, baseCase	# if $a0 < 10 then goto baseCase
    j recursiveCase
baseCase:        
    #     printf("%d\n", arg);
        li $v0, 1
        move 	$a0, $s0		# $a0 = $s0
        syscall
        li $v0, 4
        la $a0, newLine
        syscall
        j done
    #     return;
    # }

recursiveCase:   

    lw		$t0, ten		# 
    

    # print_vertical(arg / 10);
    div		$s0, $t0			# $s0 / 10
    mflo	$a0					# $t2 = floor($s0 / 10) 
    jal print_vertical

    # printf("%d \n", arg % 10);
    div		$s0, $t0			# $s0 / 10
    mfhi	$a0					# $t3 = $s0 % 10 
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, newLine
    syscall


done:
    # pop the RA from the stack (restore s0 also)
    lw		$ra, 0($sp)		# 
    lw		$s0, 4($sp)		# 
    addi	$sp, $sp, 8			# $sp = $sp + 4
    

    jr $ra
.end print_vertical




















