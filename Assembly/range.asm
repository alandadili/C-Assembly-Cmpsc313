.data
    prompt:         .asciiz "Enter a number between "
    and_msg:        .asciiz " and "
    colon:          .asciiz ": "
    error_msg:      .asciiz "Invalid input! Please try again.\n"
    result_msg:     .asciiz "Successfully read numbers: "
    space:          .asciiz " "
    newline:        .asciiz "\n"
    numbers:        .word 0:10      # Array to store 10 numbers

.text
.globl main

main:
    # Initialize variables
    la $s0, numbers         # Base address of array
    li $s1, 0               # Counter for array index
    li $s2, 2               # Start range for first number (must be > 1)
    
read_loop:
    # Check if we've read 10 numbers
    bge $s1, 10, print_results
    
    # Calculate end range: start + 10
    addi $a1, $s2, 10       # end = start + 10
    
    # Call ReadNumber(start, end)
    move $a0, $s2           # start parameter
    jal ReadNumber
    
    # Store result in array
    sll $t0, $s1, 2         # Multiply index by 4 (word size)
    add $t0, $t0, $s0       # Calculate address
    sw $v0, 0($t0)          # Store number in array
    
    # Update for next iteration
    addi $s2, $v0, 1        # Next start = current number + 1 (strict inequality)
    addi $s1, $s1, 1        # Increment counter
    
    j read_loop

print_results:
    # Print result message
    li $v0, 4
    la $a0, result_msg
    syscall
    
    # Print all numbers
    la $s0, numbers
    li $s1, 0
    
print_loop:
    bge $s1, 10, exit_program
    
    # Load and print number
    sll $t0, $s1, 2
    add $t0, $t0, $s0
    lw $a0, 0($t0)
    li $v0, 1
    syscall
    
    # Print space
    li $v0, 4
    la $a0, space
    syscall
    
    addi $s1, $s1, 1
    j print_loop

exit_program:
    # Print newline
    li $v0, 4
    la $a0, newline
    syscall
    
    # Exit
    li $v0, 10
    syscall

ReadNumber:
    # Save registers
    addi $sp, $sp, -16
    sw $ra, 12($sp)
    sw $s3, 8($sp)
    sw $s4, 4($sp)
    sw $s5, 0($sp)
    
    move $s3, $a0           # Save start
    move $s4, $a1           # Save end
    
read_number_loop:
    # Print prompt
    li $v0, 4
    la $a0, prompt
    syscall
    
    # Print start
    li $v0, 1
    move $a0, $s3
    syscall
    
    # Print " and "
    li $v0, 4
    la $a0, and_msg
    syscall
    
    # Print end
    li $v0, 1
    move $a0, $s4
    syscall
    
    # Print ": "
    li $v0, 4
    la $a0, colon
    syscall
    
    # Read integer
    li $v0, 5
    syscall
    move $s5, $v0           # Save input
    
    # Check for invalid input (syscall returns 0 for non-numeric)
    # Also validate range
    blt $s5, $s3, throw_exception    # if input < start
    bgt $s5, $s4, throw_exception    # if input > end
    
    # Valid input
    move $v0, $s5           # Return value
    
    # Restore registers
    lw $s5, 0($sp)
    lw $s4, 4($sp)
    lw $s3, 8($sp)
    lw $ra, 12($sp)
    addi $sp, $sp, 16
    
    jr $ra

throw_exception:
    # Print error message
    li $v0, 4
    la $a0, error_msg
    syscall
    
    # Try again
    j read_number_loop