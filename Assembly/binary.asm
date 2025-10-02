.data
short_msg: .asciiz "Enter a short value: "
bits_msg:   .asciiz "The bits are "
newline:    .asciiz "\n"
bitstr:     .space 17         # 16 bits + 1
short_val:  .half 0           # 16-bit variable

.text
.globl main

main:
	# Prompt user for short value short_msg
	li $v0, 4
	la $a0, short_msg
	syscall

	li $v0, 5
	syscall
	move $t0, $v0         # $t0 = input integer

	# Store input as halfword (short)
	sh $t0, short_val

	# Load back as signed halfword
	lh $t0, short_val     # $t0 = sign-extended 16-bit value

	# Prepare to convert to binary string
	la $a1, bitstr        # $a1 = address of bitstr
	li $t1, 15            # bit position (15 downto 0)

bin_loop:
	srl $t2, $t0, $t1     # shift right by bit position
	andi $t2, $t2, 1      # isolate the bit
	addi $t2, $t2, 48     # convert 0/1 to ASCII ('0'/'1')
	sb $t2, 0($a1)        # store ASCII char in bitstr
	addi $a1, $a1, 1      # move to next char
	addi $t1, $t1, -1     # decrement bit position
	bgez $t1, bin_loop    # repeat until t1 < 0

	# Null-terminate the string
	sb $zero, 0($a1)

	# Print bits_msg
	li $v0, 4
	la $a0, bits_msg
	syscall

	# Print bitstr
	li $v0, 4
	la $a0, bitstr
	syscall

	# Print newline
	li $v0, 4
	la $a0, newline
	syscall

	# Exit
	li $v0, 10
	syscall
