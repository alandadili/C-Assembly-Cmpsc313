.data
    prompt:         .asciiz "Enter file path: "
    error_open:     .asciiz "Error: Cannot open file. Please check if the file exists and you have permission to read it.\n"
    error_read:     .asciiz "Error: Failed to read from file.\n"
    error_close:    .asciiz "Error: Failed to close file properly.\n"
    success_msg:    .asciiz "\n--- File Contents ---\n"
    end_msg:        .asciiz "\n--- End of File ---\n"
    newline:        .asciiz "\n"
    
    filepath:       .space 256      
    buffer:         .space 4097     
    
    
    exception_code: .word 0         
.text
.globl main

main:
    
    li $v0, 4
    la $a0, prompt
    syscall
    
    
    li $v0, 8               
    la $a0, filepath        
    li $a1, 256             
    syscall
    
    
    la $t0, filepath
remove_newline:
    lb $t1, 0($t0)
    beqz $t1, open_file     
    li $t2, 10              
    beq $t1, $t2, replace_newline  
    addi $t0, $t0, 1
    j remove_newline
    
replace_newline:
    sb $zero, 0($t0)        
open_file:
    
    li $v0, 13             
    la $a0, filepath        
    li $a1, 0               
    li $a2, 0               
    syscall
    
    move $s0, $v0           
    
    
    bltz $s0, throw_open_exception
    
    
    li $v0, 4
    la $a0, success_msg
    syscall

read_file:
    
    li $v0, 14              
    move $a0, $s0           
    la $a1, buffer          
    li $a2, 4096            
    syscall
    
    move $s1, $v0           
    
    
    bltz $s1, throw_read_exception
    
    
    beqz $s1, close_file
    
    
    la $t0, buffer
    add $t0, $t0, $s1      
    sb $zero, 0($t0)       
    
    
    li $v0, 4
    la $a0, buffer
    syscall
    
    
    jal clear_buffer
    
    
    j read_file

close_file:
    
    li $v0, 4
    la $a0, end_msg
    syscall
    
    
    li $v0, 16              
    move $a0, $s0           
    syscall
    
    
    bltz $v0, throw_close_exception
    
    
    j exit_program

throw_open_exception:
    
    li $t0, 1
    la $t1, exception_code
    sw $t0, 0($t1)
    
    
    li $v0, 17
    li $a0, 1               
    syscall

throw_read_exception:
    
    li $t0, 2
    la $t1, exception_code
    sw $t0, 0($t1)
    
    
    li $v0, 17
    li $a0, 2               
    syscall

throw_close_exception:
   
    li $t0, 3
    la $t1, exception_code
    sw $t0, 0($t1)
    
    
    li $v0, 17
    li $a0, 3               
    syscall

clear_buffer:
    
    addi $sp, $sp, -4
    sw $t0, 0($sp)
    
    la $t0, buffer
    li $t1, 4097            
    
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
    
    li $v0, 10
    syscall


.ktext 0x80000180
    
    la $k0, exception_code
    lw $k0, 0($k0)
    
    
    li $k1, 1
    beq $k0, $k1, handle_open_error
    
    li $k1, 2
    beq $k0, $k1, handle_read_error
    
    li $k1, 3
    beq $k0, $k1, handle_close_error
    
   
    j exception_exit

handle_open_error:
    
    li $v0, 4
    la $a0, error_open
    syscall
    j exception_exit

handle_read_error:
    
    li $v0, 4
    la $a0, error_read
    syscall
    
    
    li $v0, 16
    move $a0, $s0
    syscall
    
    j exception_exit

handle_close_error:
    
    li $v0, 4
    la $a0, error_close
    syscall
    j exception_exit

exception_exit:
   
    la $k0, exit_program
    mtc0 $k0, $14
    eret