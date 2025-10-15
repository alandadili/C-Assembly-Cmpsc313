.data
msg_result: .asciiz "C(n, r) = "
newline:    .asciiz "\n"

.text
.globl main

main:
    # C(9, 5) hardcoded for C(n,r) change values for $a0 and $a1 to test
    li $a0, 9     # n
    li $a1, 5      # r
    jal combination
    move $s0, $v0  # Save result

    la $a0, msg_result
    li $v0, 4
    syscall
    move $a0, $s0
    li $v0, 1
    syscall
    la $a0, newline
    li $v0, 4
    syscall

    # Exit
    li $v0, 10
    syscall

# combination(n, r): $a0 = n, $a1 = r, returns $v0 = C(n, r)
combination:
    addi $sp, $sp, -16
    sw $ra, 12($sp)
    sw $a0, 8($sp)
    sw $a1, 4($sp)

    # Base cases: if r == 0 or r == n, return 1
    beqz $a1, comb_base
    beq $a0, $a1, comb_base

    # Recursive: C(n, r) = C(n-1, r-1) + C(n-1, r)
    addi $a0, $a0, -1
    addi $a1, $a1, -1
    jal combination
    move $t0, $v0        # C(n-1, r-1)

    lw $a0, 8($sp)
    lw $a1, 4($sp)
    addi $a0, $a0, -1
    # $a1 stays the same
    jal combination
    add $v0, $v0, $t0    # C(n-1, r-1) + C(n-1, r)
    j comb_end

comb_base:
    li $v0, 1

comb_end:
    lw $ra, 12($sp)
    addi $sp, $sp, 16
    jr $ra