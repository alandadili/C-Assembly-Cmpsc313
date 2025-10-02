.data
prompt_msg: .asciiz "Enter an integer (0 to end program): "
result_msg: .asciiz "Largest number: "
count_msg:  .asciiz ", Occurrences: "
none_msg:   .asciiz "no numbers are entered except 0\n"
newline:    .asciiz "\n"

.text
.globl main

main:
	# Initialize largest and count
	li $t0, 0          # largest = 0
	li $t1, 0          # count = 0
	li $t2, 0          # input count

read_loop:
	# Prompt for input
	li $v0, 4
	la $a0, prompt_msg
	syscall

	li $v0, 5
	syscall
	move $t3, $v0      # $t3 = input

	beq $t3, $zero, end_input # if input == 0, end

	addi $t2, $t2, 1   # input count++

	# If first input, set largest and count
	bgtz $t2, check_largest
	move $t0, $t3      # largest = input
	li $t1, 1          # count = 1
	j read_loop

check_largest:
	bgt $t3, $t0, new_largest # if input > largest
	beq $t3, $t0, inc_count   # if input == largest
	j read_loop

new_largest:
	move $t0, $t3      # largest = input
	li $t1, 1          # count = 1
	j read_loop

inc_count:
	addi $t1, $t1, 1   # count++
	j read_loop

end_input:
	beq $t2, $zero, no_numbers # if no input except 0

	# Print result
	li $v0, 4
	la $a0, result_msg
	syscall
	li $v0, 1
	move $a0, $t0
	syscall
	li $v0, 4
	la $a0, count_msg
	syscall
	li $v0, 1
	move $a0, $t1
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	j exit_prog

no_numbers:
	li $v0, 4
	la $a0, none_msg
	syscall

exit_prog:
	li $v0, 10
	syscall
