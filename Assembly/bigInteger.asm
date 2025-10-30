# entering a -1 for the second prompt messes up and doesnt work :(
# copilot couldnt save me either :(
#^^^^^^^^

.data
    # Big integer structure: 40 bytes for digits + 1 byte for length
    bigInt1: .space 41      # First big integer
    bigInt2: .space 41      # Second big integer
    result:  .space 41      # Result big integer
    
    prompt1: .asciiz "Enter digits for first number (one at a time, -1 to end): "
    prompt2: .asciiz "Enter digits for second number (one at a time, -1 to end): "
    digit_prompt: .asciiz "Enter digit: "
    add_msg: .asciiz "\nAdd result: "
    sub_msg: .asciiz "\nSubtract result: "
    eq_msg: .asciiz "\nEqual: "
    ne_msg: .asciiz "\nNot Equal: "
    ge_msg: .asciiz "\nGreater or Equal: "
    geq_msg: .asciiz "\nGreater than: "
    le_msg: .asciiz "\nLess or Equal: "
    leq_msg: .asciiz "\nLess than: "
    true_msg: .asciiz "true"
    false_msg: .asciiz "false"
    newline: .asciiz "\n"
    
.text
.globl main

main:
    # Initialize big integers
    la $a0, bigInt1
    la $a1, prompt1
    jal inputBigInt
    
    la $a0, bigInt2
    la $a1, prompt2
    jal inputBigInt
    
    # Test add_main
    la $a0, bigInt1
    la $a1, bigInt2
    la $a2, result
    jal add_main
    la $a0, add_msg
    li $v0, 4
    syscall
    la $a0, result
    jal printBigInt
    
    # Test sub_main
    la $a0, bigInt1
    la $a1, bigInt2
    la $a2, result
    jal sub_main
    la $a0, sub_msg
    li $v0, 4
    syscall
    la $a0, result
    jal printBigInt
    
    # Test Eq
    la $a0, bigInt1
    la $a1, bigInt2
    jal Eq
    la $a0, eq_msg
    li $v0, 4
    syscall
    move $a0, $v0
    jal printBool
    
    # Test Ne
    la $a0, bigInt1
    la $a1, bigInt2
    jal Ne
    la $a0, ne_msg
    li $v0, 4
    syscall
    move $a0, $v0
    jal printBool
    
    # Test Ge
    la $a0, bigInt1
    la $a1, bigInt2
    jal Ge
    la $a0, ge_msg
    li $v0, 4
    syscall
    move $a0, $v0
    jal printBool
    
    # Test Geq
    la $a0, bigInt1
    la $a1, bigInt2
    jal Geq
    la $a0, geq_msg
    li $v0, 4
    syscall
    move $a0, $v0
    jal printBool
    
    # Test Le
    la $a0, bigInt1
    la $a1, bigInt2
    jal Le
    la $a0, le_msg
    li $v0, 4
    syscall
    move $a0, $v0
    jal printBool
    
    # Test Leq
    la $a0, bigInt1
    la $a1, bigInt2
    jal Leq
    la $a0, leq_msg
    li $v0, 4
    syscall
    move $a0, $v0
    jal printBool
    
    # Exit
    li $v0, 10
    syscall

# Input big integer from user
# $a0 = address of bigInt, $a1 = prompt message
inputBigInt:
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    
    move $s0, $a0           # Save bigInt address
    move $s1, $a1           # Save prompt
    
    # Print prompt
    move $a0, $s1
    li $v0, 4
    syscall
    
    li $s2, 0               # Digit counter
input_loop:
    # Prompt for digit
    la $a0, digit_prompt
    li $v0, 4
    syscall
    
    # Read integer
    li $v0, 5
    syscall
    move $t9, $v0           # SAVE THE INPUT VALUE
    
    # Check for -1 (end)
    li $t0, -1
    beq $t9, $t0, input_done
    
    # Check if digit is valid (0-9)
    blt $t9, 0, input_loop
    bgt $t9, 9, input_loop
    
    # Check if we have space
    bge $s2, 40, input_loop
    
    # Store digit
    add $t0, $s0, $s2
    sb $t9, 1($t0)          # Store after length byte (use $t9 not $v0)
    addi $s2, $s2, 1
    j input_loop
    
input_done:
    # Store length
    sb $s2, 0($s0)
    
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    addi $sp, $sp, 16
    jr $ra

# Add two big integers
# $a0 = bigInt1, $a1 = bigInt2, $a2 = result
add_main:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    lb $t0, 0($a0)          # Length of bigInt1
    lb $t1, 0($a1)          # Length of bigInt2
    
    # Determine max length
    move $t2, $t0
    bge $t0, $t1, add_start
    move $t2, $t1
    
add_start:
    li $t3, 0               # Index (from right)
    li $t4, 0               # Carry
    li $t5, 0               # Result length
    
add_loop:
    bge $t3, $t2, add_check_carry
    
    # Get digit from bigInt1 (or 0 if out of bounds)
    sub $t6, $t0, $t3
    addi $t6, $t6, -1
    bltz $t6, add_digit1_zero
    add $t7, $a0, $t6
    lb $t6, 1($t7)
    j add_digit2
add_digit1_zero:
    li $t6, 0
    
add_digit2:
    # Get digit from bigInt2 (or 0 if out of bounds)
    sub $t7, $t1, $t3
    addi $t7, $t7, -1
    bltz $t7, add_digit2_zero
    add $t8, $a1, $t7
    lb $t7, 1($t8)
    j add_compute
add_digit2_zero:
    li $t7, 0
    
add_compute:
    # Sum = digit1 + digit2 + carry
    add $t8, $t6, $t7
    add $t8, $t8, $t4
    
    # New carry = sum / 10
    li $t9, 10
    div $t8, $t9
    mfhi $t8                # digit = sum % 10
    mflo $t4                # carry = sum / 10
    
    # Store result digit (from right)
    sub $t9, $t2, $t3
    add $t9, $a2, $t9
    sb $t8, 0($t9)
    
    addi $t3, $t3, 1
    addi $t5, $t5, 1
    j add_loop
    
add_check_carry:
    beqz $t4, add_done
    # Store final carry
    addi $t5, $t5, 1
    add $t9, $a2, $t5
    sb $t4, 0($t9)
    
add_done:
    sb $t5, 0($a2)          # Store result length
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Subtract two big integers (assumes bigInt1 >= bigInt2)
# $a0 = bigInt1, $a1 = bigInt2, $a2 = result
sub_main:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    lb $t0, 0($a0)          # Length of bigInt1
    lb $t1, 0($a1)          # Length of bigInt2
    
    li $t3, 0               # Index (from right)
    li $t4, 0               # Borrow
    li $t5, 0               # Result length
    move $t2, $t0           # Use length of bigInt1
    
sub_loop:
    bge $t3, $t2, sub_trim
    
    # Get digit from bigInt1
    sub $t6, $t0, $t3
    addi $t6, $t6, -1
    add $t7, $a0, $t6
    lb $t6, 1($t7)
    
    # Get digit from bigInt2 (or 0 if out of bounds)
    sub $t7, $t1, $t3
    addi $t7, $t7, -1
    bltz $t7, sub_digit2_zero
    add $t8, $a1, $t7
    lb $t7, 1($t8)
    j sub_compute
sub_digit2_zero:
    li $t7, 0
    
sub_compute:
    # diff = digit1 - digit2 - borrow
    sub $t8, $t6, $t7
    sub $t8, $t8, $t4
    
    # Check if we need to borrow
    li $t4, 0
    bgez $t8, sub_store
    addi $t8, $t8, 10
    li $t4, 1
    
sub_store:
    # Store result digit (from right)
    sub $t9, $t2, $t3
    add $t9, $a2, $t9
    sb $t8, 0($t9)
    addi $t5, $t5, 1
    
    addi $t3, $t3, 1
    j sub_loop
    
sub_trim:
    # Remove leading zeros
    li $t3, 1
    move $t4, $t5
trim_loop:
    bgt $t3, $t5, trim_done
    lb $t6, 1($a2)
    bnez $t6, trim_done
    addi $t4, $t4, -1
    # Shift digits left
    move $t7, $t3
shift_loop:
    bge $t7, $t5, shift_done
    add $t8, $a2, $t7
    lb $t9, 1($t8)
    sb $t9, 0($t8)
    addi $t7, $t7, 1
    j shift_loop
shift_done:
    j trim_loop
    
trim_done:
    sb $t4, 0($a2)
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Equal comparison
# $a0 = bigInt1, $a1 = bigInt2
# Returns: $v0 = 1 if equal, 0 otherwise
Eq:
    lb $t0, 0($a0)
    lb $t1, 0($a1)
    
    # Check lengths
    bne $t0, $t1, eq_false
    
    # Compare digits
    li $t2, 0
eq_loop:
    bge $t2, $t0, eq_true
    add $t3, $a0, $t2
    add $t4, $a1, $t2
    lb $t5, 1($t3)
    lb $t6, 1($t4)
    bne $t5, $t6, eq_false
    addi $t2, $t2, 1
    j eq_loop
    
eq_true:
    li $v0, 1
    jr $ra
eq_false:
    li $v0, 0
    jr $ra

# Not equal comparison
# $a0 = bigInt1, $a1 = bigInt2
# Returns: $v0 = 1 if not equal, 0 otherwise
Ne:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    jal Eq
    xori $v0, $v0, 1        # Invert result
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Greater or equal comparison
# $a0 = bigInt1, $a1 = bigInt2
# Returns: $v0 = 1 if bigInt1 >= bigInt2, 0 otherwise
Ge:
    lb $t0, 0($a0)
    lb $t1, 0($a1)
    
    # Compare lengths first
    bgt $t0, $t1, ge_true
    blt $t0, $t1, ge_false
    
    # Same length, compare digits from left
    li $t2, 0
ge_loop:
    bge $t2, $t0, ge_true   # All equal
    add $t3, $a0, $t2
    add $t4, $a1, $t2
    lb $t5, 1($t3)
    lb $t6, 1($t4)
    bgt $t5, $t6, ge_true
    blt $t5, $t6, ge_false
    addi $t2, $t2, 1
    j ge_loop
    
ge_true:
    li $v0, 1
    jr $ra
ge_false:
    li $v0, 0
    jr $ra

# Greater than comparison
# $a0 = bigInt1, $a1 = bigInt2
# Returns: $v0 = 1 if bigInt1 > bigInt2, 0 otherwise
Geq:
    lb $t0, 0($a0)
    lb $t1, 0($a1)
    
    # Compare lengths first
    bgt $t0, $t1, geq_true
    blt $t0, $t1, geq_false
    
    # Same length, compare digits from left
    li $t2, 0
geq_loop:
    bge $t2, $t0, geq_false # All equal means not greater
    add $t3, $a0, $t2
    add $t4, $a1, $t2
    lb $t5, 1($t3)
    lb $t6, 1($t4)
    bgt $t5, $t6, geq_true
    blt $t5, $t6, geq_false
    addi $t2, $t2, 1
    j geq_loop
    
geq_true:
    li $v0, 1
    jr $ra
geq_false:
    li $v0, 0
    jr $ra

# Less or equal comparison
# $a0 = bigInt1, $a1 = bigInt2
# Returns: $v0 = 1 if bigInt1 <= bigInt2, 0 otherwise
Le:
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    
    # Swap arguments and call Ge
    move $t0, $a0
    move $a0, $a1
    move $a1, $t0
    jal Ge
    
    lw $ra, 0($sp)
    lw $a0, 4($sp)
    addi $sp, $sp, 8
    jr $ra

# Less than comparison
# $a0 = bigInt1, $a1 = bigInt2
# Returns: $v0 = 1 if bigInt1 < bigInt2, 0 otherwise
Leq:
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    
    # Swap arguments and call Geq
    move $t0, $a0
    move $a0, $a1
    move $a1, $t0
    jal Geq
    
    lw $ra, 0($sp)
    lw $a0, 4($sp)
    addi $sp, $sp, 8
    jr $ra

# Print big integer
# $a0 = address of bigInt
printBigInt:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    lb $t0, 0($a0)          # Get length
    beqz $t0, print_zero
    
    li $t1, 0
print_loop:
    bge $t1, $t0, print_newline
    add $t2, $a0, $t1
    lb $t3, 1($t2)
    
    # Print digit
    move $a0, $t3
    li $v0, 1
    syscall
    
    addi $t1, $t1, 1
    j print_loop
    
print_zero:
    li $a0, 0
    li $v0, 1
    syscall
    
print_newline:
    la $a0, newline
    li $v0, 4
    syscall
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Print boolean
# $a0 = boolean value
printBool:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    beqz $a0, print_false
    la $a0, true_msg
    j print_bool_msg
print_false:
    la $a0, false_msg
print_bool_msg:
    li $v0, 4
    syscall
    la $a0, newline
    syscall
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra