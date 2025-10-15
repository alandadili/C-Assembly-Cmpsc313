.data

    # data goes here
    inputMessage: .asciiz "Enter a positive integer: "
    outputMessage: .asciiz "Factorial -> "

.text

    # code goes here

.globl main
.ent main
main:

    # // collect input
    # int n;
    # printf("Enter a positive integer: ");
    li $v0, 4
    la $a0, inputMessage
    syscall

    # scanf("%d", &n);
    li $v0, 5
    syscall

    # int result = factorial(n);
    move 	$a0, $v0		# $a0 = $v0
    jal factorial
    move 	$t0, $v0		# $t0 = $v0

    # printf("Factorial of %d is %d\n", n, result);
    li $v0, 4
    la $a0, outputMessage
    syscall
    li $v0, 1
    move 	$a0, $t0		# $a0 = $t0 
    syscall

    # done
    li $v0, 10
    syscall

.end main

#
#   factorial 
#   input: num (a0)
#   output: num! (v0)

.globl factorial
.ent factorial
factorial: 

    # this is a non-leaf function
    # push the $ra onto the stack
    subu $sp, $sp, 8
    sw		$ra, 0($sp)		# 
    sw		$s0, 4($sp)		# 
    
    # preserve the original input
    move 	$s0, $a0		# $s0 = $a0

    # if (n == 1) {
        # return 1; // Base case: 0! = 1 and 1! = 1
    li $v0, 1
    beq		$a0, 1, donFact	# if $a0 == $t1 then goto target
    
    # return n * factorial(n - 1); // Recursive case
    addi $a0, $a0, -1
    jal factorial
    mul $v0, $v0, $s0

donFact:

    # pop the return address of the stack
    lw		$ra, 0($sp)		# 
    lw		$s0, 4($sp)		# 
    addi	$sp, $sp, 8			# $sp   = $sp 4 0

    jr $ra
.end factorial