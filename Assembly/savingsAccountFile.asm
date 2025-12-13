.data
# File names
balance_file: .asciiz "balances.txt"
transaction_file: .asciiz "transactions.txt"

# Account array (max 100 accounts)
# Each account: accountNumber(4), rate(4), balance(4) = 12 bytes
accounts: .space 1200
account_count: .word 0

# Buffers
buffer: .space 256
line_buffer: .space 128

# Constants
rate_3percent: .float 0.03
twelve: .float 12.0
hundred: .float 100.0

# Messages
msg_account: .asciiz "Account "
msg_balance: .asciiz ": $"
newline: .asciiz "\n"
msg_error: .asciiz "Error opening file\n"

.text
.globl main

main:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Step 1: Read balances.txt and create accounts
    jal readBalances
    
    # Step 2: Set interest rate to 3% for all accounts
    jal setAllRates
    
    # Step 3: Read and process transactions.txt
    jal processTransactions
    
    # Step 4: Calculate monthly interest for all accounts
    jal calculateAllInterest
    
    # Step 5: Print all account balances
    jal printAllBalances
    
    # Exit
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    li $v0, 10
    syscall

# Read balances from file and create accounts
readBalances:
    addi $sp, $sp, -8
    sw $ra, 4($sp)
    sw $s0, 0($sp)
    
    # Open file
    li $v0, 13
    la $a0, balance_file
    li $a1, 0           # read mode
    li $a2, 0
    syscall
    move $s0, $v0       # save file descriptor
    
    bltz $s0, rb_error
    
    # Read file content
    li $v0, 14
    move $a0, $s0
    la $a1, buffer
    li $a2, 256
    syscall
    
    # Close file
    li $v0, 16
    move $a0, $s0
    syscall
    
    # Parse buffer and create accounts
    jal parseBalances
    
    lw $s0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8
    jr $ra
    
rb_error:
    li $v0, 4
    la $a0, msg_error
    syscall
    j rb_done

# Parse balance data from buffer
parseBalances:
    addi $sp, $sp, -16
    sw $ra, 12($sp)
    sw $s0, 8($sp)
    sw $s1, 4($sp)
    sw $s2, 0($sp)
    
    la $s0, buffer      # current position
    la $s1, accounts    # account array
    li $s2, 0           # account count
    
pb_loop:
    lb $t0, 0($s0)
    beqz $t0, pb_done
    beq $t0, 10, pb_skip    # newline
    beq $t0, 13, pb_skip    # carriage return
    
    # Parse float from string
    move $a0, $s0
    jal parseFloat
    
    # Store balance in account
    mul $t1, $s2, 12        # offset for account
    add $t2, $s1, $t1
    
    # Set account number
    addi $t3, $s2, 1
    sw $t3, 0($t2)
    
    # Set balance
    s.s $f0, 8($t2)
    
    # Initialize rate to 0
    mtc1 $zero, $f1
    s.s $f1, 4($t2)
    
    addi $s2, $s2, 1
    move $s0, $v1           # update position
    j pb_loop
    
pb_skip:
    addi $s0, $s0, 1
    j pb_loop
    
pb_done:
    sw $s2, account_count
    lw $s2, 0($sp)
    lw $s1, 4($sp)
    lw $s0, 8($sp)
    lw $ra, 12($sp)
    addi $sp, $sp, 16
    jr $ra

# Parse float from string
# $a0 = string address
# Returns: $f0 = float value, $v1 = address after number
parseFloat:
    addi $sp, $sp, -4
    sw $s0, 0($sp)
    
    move $s0, $a0
    mtc1 $zero, $f0
    mtc1 $zero, $f1
    li $t0, 10
    mtc1 $t0, $f2
    cvt.s.w $f2, $f2
    
    # Parse integer part
pf_int_loop:
    lb $t1, 0($s0)
    blt $t1, 48, pf_check_dot
    bgt $t1, 57, pf_check_dot
    
    mul.s $f0, $f0, $f2
    addi $t1, $t1, -48
    mtc1 $t1, $f3
    cvt.s.w $f3, $f3
    add.s $f0, $f0, $f3
    addi $s0, $s0, 1
    j pf_int_loop
    
pf_check_dot:
    lb $t1, 0($s0)
    bne $t1, 46, pf_done    # check for '.'
    addi $s0, $s0, 1
    
    li $t2, 1
    mtc1 $t2, $f4
    cvt.s.w $f4, $f4
    
    # Parse decimal part
pf_dec_loop:
    lb $t1, 0($s0)
    blt $t1, 48, pf_done
    bgt $t1, 57, pf_done
    
    div.s $f4, $f4, $f2
    addi $t1, $t1, -48
    mtc1 $t1, $f3
    cvt.s.w $f3, $f3
    mul.s $f3, $f3, $f4
    add.s $f0, $f0, $f3
    addi $s0, $s0, 1
    j pf_dec_loop
    
pf_done:
    move $v1, $s0
    lw $s0, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Set interest rate for all accounts to 3%
setAllRates:
    la $t0, accounts
    lw $t1, account_count
    li $t2, 0
    l.s $f0, rate_3percent
    
sar_loop:
    beq $t2, $t1, sar_done
    mul $t3, $t2, 12
    add $t4, $t0, $t3
    s.s $f0, 4($t4)
    addi $t2, $t2, 1
    j sar_loop
sar_done:
    jr $ra

# Process transactions from file
processTransactions:
    addi $sp, $sp, -8
    sw $ra, 4($sp)
    sw $s0, 0($sp)
    
    # Open file
    li $v0, 13
    la $a0, transaction_file
    li $a1, 0
    li $a2, 0
    syscall
    move $s0, $v0
    
    bltz $s0, pt_error
    
    # Read file
    li $v0, 14
    move $a0, $s0
    la $a1, buffer
    li $a2, 256
    syscall
    
    # Close file
    li $v0, 16
    move $a0, $s0
    syscall
    
    # Parse and process transactions
    jal parseTransactions
    
    lw $s0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8
    jr $ra
    
pt_error:
    li $v0, 4
    la $a0, msg_error
    syscall
    j pt_done

# Parse transaction data
parseTransactions:
    addi $sp, $sp, -20
    sw $ra, 16($sp)
    sw $s0, 12($sp)
    sw $s1, 8($sp)
    sw $s2, 4($sp)
    sw $s3, 0($sp)
    
    la $s0, buffer
    la $s1, accounts
    
pt_loop:
    lb $t0, 0($s0)
    beqz $t0, pt_done2
    beq $t0, 10, pt_skip2
    beq $t0, 13, pt_skip2
    
    # Parse account number (integer)
    move $a0, $s0
    jal parseInt
    move $s2, $v0           # account number
    move $s0, $v1           # update position
    
    # Skip whitespace/newline
    addi $s0, $s0, 1
    
    # Parse amount
    move $a0, $s0
    jal parseFloat
    mov.s $f12, $f0         # transaction amount
    move $s0, $v1
    
    # Find account and update balance
    move $a0, $s2
    jal findAccount
    
    beqz $v0, pt_skip2      # account not found
    
    l.s $f1, 8($v0)         # current balance
    add.s $f1, $f1, $f12    # add transaction
    s.s $f1, 8($v0)
    
    j pt_loop
    
pt_skip2:
    addi $s0, $s0, 1
    j pt_loop
    
pt_done2:
    lw $s3, 0($sp)
    lw $s2, 4($sp)
    lw $s1, 8($sp)
    lw $s0, 12($sp)
    lw $ra, 16($sp)
    addi $sp, $sp, 20
    jr $ra

# Parse integer from string
# $a0 = string, returns $v0 = integer, $v1 = position after
parseInt:
    move $t0, $a0
    li $v0, 0
    
pi_loop:
    lb $t1, 0($t0)
    blt $t1, 48, pi_done2
    bgt $t1, 57, pi_done2
    
    mul $v0, $v0, 10
    addi $t1, $t1, -48
    add $v0, $v0, $t1
    addi $t0, $t0, 1
    j pi_loop
    
pi_done2:
    move $v1, $t0
    jr $ra

# Find account by number
# $a0 = account number, returns $v0 = address or 0
findAccount:
    la $t0, accounts
    lw $t1, account_count
    li $t2, 0
    
fa_loop:
    beq $t2, $t1, fa_not_found
    mul $t3, $t2, 12
    add $t4, $t0, $t3
    lw $t5, 0($t4)
    beq $t5, $a0, fa_found
    addi $t2, $t2, 1
    j fa_loop
    
fa_found:
    move $v0, $t4
    jr $ra
    
fa_not_found:
    li $v0, 0
    jr $ra

# Calculate monthly interest for all accounts
calculateAllInterest:
    la $t0, accounts
    lw $t1, account_count
    li $t2, 0
    l.s $f2, twelve
    
cai_loop:
    beq $t2, $t1, cai_done
    mul $t3, $t2, 12
    add $t4, $t0, $t3
    
    l.s $f0, 8($t4)         # balance
    l.s $f1, 4($t4)         # rate
    
    mul.s $f3, $f0, $f1
    div.s $f4, $f3, $f2
    add.s $f5, $f0, $f4
    
    s.s $f5, 8($t4)
    
    addi $t2, $t2, 1
    j cai_loop
cai_done:
    jr $ra

# Print all account balances
printAllBalances:
    addi $sp, $sp, -12
    sw $ra, 8($sp)
    sw $s0, 4($sp)
    sw $s1, 0($sp)
    
    la $s0, accounts
    lw $s1, account_count
    li $t0, 0
    
pab_loop:
    beq $t0, $s1, pab_done
    
    sw $t0, 0($sp)
    
    mul $t1, $t0, 12
    add $t2, $s0, $t1
    
    # Print account number
    li $v0, 4
    la $a0, msg_account
    syscall
    
    lw $t3, 0($t2)
    li $v0, 1
    move $a0, $t3
    syscall
    
    li $v0, 4
    la $a0, msg_balance
    syscall
    
    l.s $f12, 8($t2)
    li $v0, 2
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall
    
    lw $t0, 0($sp)
    addi $t0, $t0, 1
    j pab_loop
    
pab_done:
    lw $s1, 0($sp)
    lw $s0, 4($sp)
    lw $ra, 8($sp)
    addi $sp, $sp, 12
    jr $ra