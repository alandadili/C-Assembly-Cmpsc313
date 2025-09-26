.data
principal_msg: .asciiz "Enter principal amount: "
rate_msg:      .asciiz "Enter interest rate (percent): "
years_msg:     .asciiz "Enter number of years: "
result_msg:    .asciiz "Simple interest amount: "
newline:       .asciiz "\n"

.text
.globl main

main:


	# Prompt for principal
	li $v0, 4
	la $a0, principal_msg
	syscall
	li $v0, 5
	syscall
	move $t0, $v0        # $t0 = principal

	# Prompt for interest rate
	li $v0, 4
	la $a0, rate_msg
	syscall
	li $v0, 5
	syscall
	move $t1, $v0        # $t1 = rate

	# Prompt for number of years
	li $v0, 4
	la $a0, years_msg
	syscall
	li $v0, 5
	syscall
	move $t2, $v0        # $t2 = years

	# Calculate interest: (principal * rate * years) / 100
	mul $t3, $t0, $t1    # $t3 = principal * rate
	mul $t3, $t3, $t2    # $t3 = principal * rate * years
	li $t4, 100
	div $t3, $t4
	mflo $t5             # $t5 = interest

	# Print result message
	li $v0, 4
	la $a0, result_msg
	syscall

	# Print interest amount
	li $v0, 1
	move $a0, $t5
	syscall

	# Print newline
	li $v0, 4
	la $a0, newline
	syscall

	# Exit
	li $v0, 10
	syscall

