.data
lethal_od_msg:    .asciiz "Scientists estimate that 10 grams (10000 mg) of caffeine is the lethal overdose.\n"
prompt_msg:   .asciiz "Enter the number of mg of caffeine per drink: "
result_msg:   .asciiz "Number of drinks to reach the lethal overdose: "
newline:      .asciiz "\n"

.text
.globl main

main:


	# Print the lethal overdose message
	li $v0, 4
	la $a0, lethal_od_msg
	syscall

	# Prompt user for caffeine per drink
	li $v0, 4
	la $a0, prompt_msg
	syscall

	li $v0, 5
	syscall
	move $t0, $v0        # $t0 = mg per drink

	# Set lethal overdose limit (10,000 mg)
	li $t1, 10000        # $t1 = lethal overdose limit

	# Calculate number of drinks: lethal overdose / mg per drink
	div $t1, $t0
	mflo $t2             # $t2 = number of drinks

	# Print result message
	li $v0, 4
	la $a0, result_msg
	syscall

	# Print number of drinks
	li $v0, 1
	move $a0, $t2
	syscall

	# Print newline
	li $v0, 4
	la $a0, newline
	syscall

	# Exit
	li $v0, 10
	syscall
