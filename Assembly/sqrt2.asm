.data
    prompt:     .asciiz "Enter an integer: "
    invalid:    .asciiz "Invalid Number"
    goodbye:    .asciiz "Goodbye"
    newline:    .asciiz "\n"

.text
.globl main

main:
    
    li $v0, 4
    la $a0, prompt
    syscall
    
   
    li $v0, 5
    syscall
    move $t0, $v0         
    
    
    bltz $t0, throw_invalid_exception
    
   
    mtc1 $t0, $f0          
    cvt.s.w $f0, $f0       
    sqrt.s $f12, $f0       
    
    
    li $v0, 2              
    syscall
    
    
    li $v0, 4
    la $a0, newline
    syscall
    
    
    j finally_block

throw_invalid_exception:
    
    li $v0, 17             
    li $a0, 1              
    syscall

finally_block:
    
    li $v0, 4
    la $a0, goodbye
    syscall
    
    
    li $v0, 4
    la $a0, newline
    syscall
    
   
    li $v0, 10
    syscall


.ktext 0x80000180
    
    li $v0, 4
    la $a0, invalid
    syscall
    
    
    li $v0, 4
    la $a0, newline
    syscall
    
    
    la $k0, finally_block
    
    
    mtc0 $k0, $14          
    eret                    