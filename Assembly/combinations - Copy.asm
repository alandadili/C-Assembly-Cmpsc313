.data
prompt_msg: .asciiz "Enter a non-negative, non-zero integer N: "
combo_msg:  .asciiz " "
result_msg: .asciiz "The total number of all combinations is "
newline:    .asciiz "\n"

.text
.globl main

main:
	# Prompt for N
	li $v0, 4
	la $a0, prompt_msg
	syscall
	li $v0, 5
	syscall
	move $t0, $v0        # $t0 = N

	# Initialize counters
	li $t1, 1            # i = 1
	li $t4, 0            # total combinations

outer_loop:
	bgt $t1, $t0, end_combos # if i > N, end
	addi $t2, $t1, 1     # j = i + 1

inner_loop:
	bgt $t2, $t0, next_i # if j > N, next i

	# Print i
	li $v0, 1
	move $a0, $t1
	syscall
	# Print space
	li $v0, 4
	la $a0, combo_msg
	syscall
	# Print j
	li $v0, 1
	move $a0, $t2
	syscall
	# Print newline
	li $v0, 4
	la $a0, newline
	syscall

	addi $t4, $t4, 1     # total++
	addi $t2, $t2, 1     # j++
	j inner_loop

next_i:
	addi $t1, $t1, 1     # i++
	j outer_loop

end_combos:
	# Print result message
	li $v0, 4
	la $a0, result_msg
	syscall
	# Print total combinations
	li $v0, 1
	move $a0, $t4
	syscall
	# Print newline
	li $v0, 4
	la $a0, newline
	syscall

	# Exit
	li $v0, 10
	syscall
