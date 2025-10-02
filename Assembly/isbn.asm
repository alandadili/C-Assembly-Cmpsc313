.data
prompt_msg: .asciiz "Enter digit "
isbn_msg:   .asciiz "ISBN-13: "
invalid_msg:.asciiz "invalid input\n"
newline:    .asciiz "\n"
digits:     .space 48      # 12 digits (4 bytes each)

.text
.globl main

main:
	# Read 12 digits
	li $t0, 0              # i = 0
	la $t1, digits         # address of digits array

read_loop:
	bge $t0, 12, validate_digits
	li $v0, 4
	la $a0, prompt_msg
	syscall
	li $v0, 1
	addi $a0, $t0, 1      # print digit number
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	li $v0, 5
	syscall
	move $t2, $v0         # $t2 = input digit
	blt $t2, 0, invalid   # digit < 0
	bgt $t2, 9, invalid   # digit > 9
	sw $t2, 0($t1)        # store digit
	addi $t1, $t1, 4      # next slot
	addi $t0, $t0, 1      # i++
	j read_loop

validate_digits:
	# Calculate checksum
	la $t1, digits
	li $t0, 0             # i = 0
	li $t3, 0             # sum = 0

checksum_loop:
	bge $t0, 12, finish_checksum
	lw $t2, 0($t1)
	# Odd positions: add digit
	andi $t4, $t0, 1
	beqz $t4, add_digit
	# Even positions: add 3*digit
	mul $t2, $t2, 3
add_digit:
	add $t3, $t3, $t2
	addi $t1, $t1, 4
	addi $t0, $t0, 1
	j checksum_loop

finish_checksum:
	rem $t5, $t3, 10      # sum % 10
	sub $t5, $zero, $t5   # 0 - (sum % 10)
	addi $t5, $t5, 10     # 10 - (sum % 10)
	rem $t5, $t5, 10      # checksum

	# Print ISBN-13
	li $v0, 4
	la $a0, isbn_msg
	syscall
	la $t1, digits
	li $t0, 0
print_digits:
	bge $t0, 12, print_checksum
	lw $t2, 0($t1)
	li $v0, 1
	move $a0, $t2
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	addi $t1, $t1, 4
	addi $t0, $t0, 1
	j print_digits

print_checksum:
	li $v0, 1
	move $a0, $t5
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	j exit_prog

invalid:
	li $v0, 4
	la $a0, invalid_msg
	syscall

exit_prog:
	li $v0, 10
	syscall
