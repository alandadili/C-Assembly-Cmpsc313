.data
prompt_msg: .asciiz "Enter a non-negative integer: "
result_msg: .asciiz "Integer square root: "
newline:    .asciiz "\n"

.text
.globl main

main:


	# Prompt user for input
	li $v0, 4
	la $a0, prompt_msg
	syscall

	li $v0, 5
	syscall
	move $t0, $v0        # $t0 = x (input)

	# Initialize i = 0
	li $t1, 0            # $t1 = i

	# Loop: while (i * i <= x)
sqrt_loop:
	mul $t2, $t1, $t1    # $t2 = i * i
	bgt $t2, $t0, sqrt_done # if i*i > x, exit loop
	addi $t1, $t1, 1     # i++
	j sqrt_loop

sqrt_done:
	addi $t1, $t1, -1    # i-- (last i where i*i <= x)

	# Print result message
	li $v0, 4
	la $a0, result_msg
	syscall

	# Print integer square root
	li $v0, 1
	move $a0, $t1
	syscall

	# Print newline
	li $v0, 4
	la $a0, newline
	syscall

	# Exit
	li $v0, 10
	syscall
