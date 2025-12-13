.data
    prompt:         .asciiz "Enter file path: "
    error_open:     .asciiz "Error: Cannot open file. Please check if the file exists and you have permission to read it.\n"
    error_read:     .asciiz "Error: Failed to read from file.\n"
    error_close:    .asciiz "Error: Failed to close file properly.\n"
    success_msg:    .asciiz "\n--- File Contents ---\n"
    end_msg:        .asciiz "\n--- End of File ---\n"
    newline:        .asciiz "\n"
    
    filepath:       .space 256      # Buffer for file path
    buffer:         .space 4097     # Buffer for file contents (4096 + 1 for null terminator)

.text
.globl main

main:
    # Print prompt
    li $v0, 4
    la $a0, prompt
    syscall
    
    # Read file path from user
    li $v0, 8               # Read string syscall
    la $a0, filepath        # Buffer address
    li $a1, 256             # Maximum length
    syscall
    
    # Remove newline character from input
    la $t0, filepath
remove_newline:
    lb $t1, 0($t0)
    beqz $t1, open_file     # End of string
    li $t2, 10              # Load newline character value
    beq $t1, $t2, replace_newline  # Check if '\n'
    addi $t0, $t0, 1
    j remove_newline
    
replace_newline:
    sb $zero, 0($t0)        # Replace '\n' with '\0'

open_file:
    # Open file for reading
    li $v0, 13              # Open file syscall
    la $a0, filepath        # File path
    li $a1, 0               # Flags: 0 = read only
    li $a2, 0               # Mode (ignored for read)
    syscall
    
    move $s0, $v0           # Save file descriptor
    
    # Check if file opened successfully
    bltz $s0, handle_open_error
    
    # Print success message
    li $v0, 4
    la $a0, success_msg
    syscall

read_file:
    # Read from file
    li $v0, 14              # Read file syscall
    move $a0, $s0           # File descriptor
    la $a1, buffer          # Buffer address
    li $a2, 4096            # Maximum bytes to read
    syscall
    
    move $s1, $v0           # Save number of bytes read
    
    # Check for read error
    bltz $s1, handle_read_error
    
    # Check if we've reached end of file
    beqz $s1, close_file
    
    # Null-terminate the buffer at buffer[bytes_read]
    la $t0, buffer
    add $t0, $t0, $s1       # buffer + bytes_read
    sb $zero, 0($t0)        # Write null terminator
    
    # Print the buffer content
    li $v0, 4
    la $a0, buffer
    syscall
    
    # Clear buffer for next read
    jal clear_buffer
    
    # Continue reading
    j read_file

close_file:
    # Print end message
    li $v0, 4
    la $a0, end_msg
    syscall
    
    # Close file
    li $v0, 16              # Close file syscall
    move $a0, $s0           # File descriptor
    syscall
    
    # Check if close was successful
    bltz $v0, handle_close_error
    
    # Exit program successfully
    j exit_program

handle_open_error:
    li $v0, 4
    la $a0, error_open
    syscall
    j exit_program

handle_read_error:
    li $v0, 4
    la $a0, error_read
    syscall
    
    # Try to close file before exiting
    li $v0, 16
    move $a0, $s0
    syscall
    
    j exit_program

handle_close_error:
    li $v0, 4
    la $a0, error_close
    syscall
    j exit_program

clear_buffer:
    # Clear the buffer by writing zeros
    addi $sp, $sp, -4
    sw $t0, 0($sp)
    
    la $t0, buffer
    li $t1, 4097            # Clear entire buffer including null terminator space
    
clear_loop:
    beqz $t1, clear_done
    sb $zero, 0($t0)
    addi $t0, $t0, 1
    addi $t1, $t1, -1
    j clear_loop
    
clear_done:
    lw $t0, 0($sp)
    addi $sp, $sp, 4
    jr $ra

exit_program:
    # Exit
    li $v0, 10
    syscall