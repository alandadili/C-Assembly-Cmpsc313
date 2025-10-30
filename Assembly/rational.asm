.data
prompt1: .asciiz "Enter numerator for first rational: "
prompt2: .asciiz "Enter denominator for first rational: "
prompt3: .asciiz "Enter numerator for second rational: "
prompt4: .asciiz "Enter denominator for second rational: "
addMsg: .asciiz "\nAddition result: "
subMsg: .asciiz "\nSubtraction result: "
mulMsg: .asciiz "\nMultiplication result: "
divMsg: .asciiz "\nDivision result: "
floatMsg: .asciiz "\nFloat value: "
slash: .asciiz "/"
newline: .asciiz "\n"

.text
.globl main

main:
    # Prompt for first rational number
    li $v0, 4
    la $a0, prompt1
    syscall
    li $v0, 5
    syscall
    move $s0, $v0           # $s0 = numerator1
    
    li $v0, 4
    la $a0, prompt2
    syscall
    li $v0, 5
    syscall
    move $s1, $v0           # $s1 = denominator1
    
    # Prompt for second rational number
    li $v0, 4
    la $a0, prompt3
    syscall
    li $v0, 5
    syscall
    move $s2, $v0           # $s2 = numerator2
    
    li $v0, 4
    la $a0, prompt4
    syscall
    li $v0, 5
    syscall
    move $s3, $v0           # $s3 = denominator2
    
    # Add
    li $v0, 4
    la $a0, addMsg
    syscall
    move $a0, $s0
    move $a1, $s1
    move $a2, $s2
    move $a3, $s3
    jal add_func
    move $a0, $v0
    move $a1, $v1
    jal print
    
    # Subtract
    li $v0, 4
    la $a0, subMsg
    syscall
    move $a0, $s0
    move $a1, $s1
    move $a2, $s2
    move $a3, $s3
    jal subtract_func
    move $a0, $v0
    move $a1, $v1
    jal print
    
    # Multiply
    li $v0, 4
    la $a0, mulMsg
    syscall
    move $a0, $s0
    move $a1, $s1
    move $a2, $s2
    move $a3, $s3
    jal multiply_func
    move $a0, $v0
    move $a1, $v1
    jal print
    
    # Divide
    li $v0, 4
    la $a0, divMsg
    syscall
    move $a0, $s0
    move $a1, $s1
    move $a2, $s2
    move $a3, $s3
    jal divide_func
    move $a0, $v0
    move $a1, $v1
    jal print
    
    # PrintFloat
    li $v0, 4
    la $a0, floatMsg
    syscall
    move $a0, $s0
    move $a1, $s1
    jal printFloat
    
    # Exit
    li $v0, 10
    syscall

# Add: (a0/a1) + (a2/a3) = (v0/v1)
add_func:
    mult $a0, $a3           # num1 * den2
    mflo $t0
    mult $a2, $a1           # num2 * den1
    mflo $t1
    add $t2, $t0, $t1       # numerator result
    mult $a1, $a3           # den1 * den2
    mflo $t3                # denominator result
    
    move $a0, $t2
    move $a1, $t3
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    jal reduce
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Subtract: (a0/a1) - (a2/a3) = (v0/v1)
subtract_func:
    mult $a0, $a3
    mflo $t0
    mult $a2, $a1
    mflo $t1
    sub $t2, $t0, $t1
    mult $a1, $a3
    mflo $t3
    
    move $a0, $t2
    move $a1, $t3
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    jal reduce
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Multiply: (a0/a1) * (a2/a3) = (v0/v1)
multiply_func:
    mult $a0, $a2
    mflo $t0
    mult $a1, $a3
    mflo $t1
    
    move $a0, $t0
    move $a1, $t1
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    jal reduce
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Divide: (a0/a1) / (a2/a3) = (v0/v1)
divide_func:
    mult $a0, $a3
    mflo $t0
    mult $a1, $a2
    mflo $t1
    
    move $a0, $t0
    move $a1, $t1
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    jal reduce
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Reduce fraction (a0/a1) using GCD
reduce:
    move $t0, $a0
    move $t1, $a1
    
    # Handle negative denominator
    bge $t1, $zero, pos_den
    neg $t0, $t0
    neg $t1, $t1
    
pos_den:
    move $a0, $t0
    move $a1, $t1
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $t0, 4($sp)
    sw $t1, 8($sp)
    jal gcd
    lw $t1, 8($sp)
    lw $t0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 12
    
    div $t0, $v0
    mflo $v0
    div $t1, $v0
    mflo $v1
    jr $ra

# GCD of a0 and a1, result in v0
gcd:
    abs $t0, $a0
    abs $t1, $a1
gcd_loop:
    beq $t1, $zero, gcd_done
    div $t0, $t1
    mfhi $t2
    move $t0, $t1
    move $t1, $t2
    j gcd_loop
gcd_done:
    move $v0, $t0
    jr $ra

# Print rational number (a0/a1)
print:
    move $t0, $a0
    move $t1, $a1
    
    li $v0, 1
    move $a0, $t0
    syscall
    
    li $v0, 4
    la $a0, slash
    syscall
    
    li $v0, 1
    move $a0, $t1
    syscall
    jr $ra

# Print float value (a0/a1)
printFloat:
    mtc1 $a0, $f0
    cvt.s.w $f0, $f0
    mtc1 $a1, $f1
    cvt.s.w $f1, $f1
    div.s $f12, $f0, $f1
    
    li $v0, 2
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall
    jr $ra