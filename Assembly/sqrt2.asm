.data
    prompt:     .asciiz "Enter an integer: "
    invalid:    .asciiz "Invalid Number"
    goodbye:    .asciiz "Goodbye"
    newline:    .asciiz "\n"

.text
.globl main

main:
    # Print prompt
    li $v0, 4
    la $a0, prompt
    syscall
    
    # Read integer from user
    li $v0, 5
    syscall
    move $t0, $v0          # Store input in $t0
    
    # Check if number is negative
    bltz $t0, error_handler
    
    # Valid number - calculate square root
    mtc1 $t0, $f0          # Move integer to FP register
    cvt.s.w $f0, $f0       # Convert to float
    sqrt.s $f12, $f0       # Calculate square root
    
    # Print the square root
    li $v0, 2              # Print float syscall
    syscall
    
    # Print newline
    li $v0, 4
    la $a0, newline
    syscall
    
    # Jump to exit
    j exit_program

error_handler:
    # Print "Invalid Number"
    li $v0, 4
    la $a0, invalid
    syscall
    
    # Print newline
    li $v0, 4
    la $a0, newline
    syscall
    
    # Fall through to exit

exit_program:
    # Print "Goodbye"
    li $v0, 4
    la $a0, goodbye
    syscall
    
    # Print newline
    li $v0, 4
    la $a0, newline
    syscall
    
    # Exit program
    li $v0, 10
    syscall