.data
prompt_msg: .asciiz "Enter number "
mean_msg:   .asciiz "Mean: "
stddev_msg: .asciiz "Standard deviation: "
newline:    .asciiz "\n"
nums:       .space 40      # 10 numbers (4 bytes each)

.text
.globl main

main:
	# Read 10 numbers
	li $t0, 0              # i = 0
	la $t1, nums           # address of nums array
	li $t2, 0              # sum = 0
	li $t3, 0              # sumsq = 0

read_loop:
	bge $t0, 10, calc_mean
	li $v0, 4
	la $a0, prompt_msg
	syscall
	li $v0, 1
	addi $a0, $t0, 1      # print number index
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	li $v0, 5
	syscall
	move $t4, $v0         # $t4 = input number
	sw $t4, 0($t1)        # store number
	add $t2, $t2, $t4     # sum += number
	mul $t5, $t4, $t4
	add $t3, $t3, $t5     # sumsq += number^2
	addi $t1, $t1, 4      # next slot
	addi $t0, $t0, 1      # i++
	j read_loop

calc_mean:
	# Calculate mean = sum / 10
	li $t6, 10
	div $t2, $t6
	mflo $t7              # mean (integer division)

	# Print mean
	li $v0, 4
	la $a0, mean_msg
	syscall
	li $v0, 1
	move $a0, $t7
	syscall
	li $v0, 4
	la $a0, newline
	syscall

	# Calculate stddev
	# stddev = sqrt((sumsq - (sum^2)/n) / (n-1))
	mul $t8, $t2, $t2     # sum^2
	div $t8, $t6
	mflo $t8              # (sum^2)/n
	sub $t9, $t3, $t8     # sumsq - (sum^2)/n
	li $t6, 9
	div $t9, $t6
	mflo $t9              # (sumsq - (sum^2)/n)/(n-1)

	# Integer sqrt (Babylonian method)
	# Initial guess: x = t9 / 2
	srl $t10, $t9, 1
	li $t11, 0
sqrt_loop:
	beq $t11, 10, sqrt_done
	div $t9, $t10
	mflo $t12
	add $t10, $t10, $t12
	srl $t10, $t10, 1
	addi $t11, $t11, 1
	j sqrt_loop
sqrt_done:

	# Print stddev
	li $v0, 4
	la $a0, stddev_msg
	syscall
	li $v0, 1
	move $a0, $t10
	syscall
	li $v0, 4
	la $a0, newline
	syscall

	# Exit
	li $v0, 10
	syscall
