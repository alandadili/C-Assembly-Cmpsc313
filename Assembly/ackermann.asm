.data
msg_result: .asciiz "Ackermann result: "
newline:    .asciiz "\n"

.text
.globl main

main:
    # Example: Ackermann(2, 2)
    li $a0, 2      # m = 2 hardcoded <---
    li $a1, 2      # n = 2 hardcoded <---
    jal ackermann
    move $s0, $v0  # Save result

    # Print result message
    la $a0, msg_result
    li $v0, 4
    syscall

    # Print result value
    move $a0, $s0
    li $v0, 1
    syscall

    # Print newline
    la $a0, newline
    li $v0, 4
    syscall

    # Exit
    li $v0, 10
    syscall

# Ackermann function: $a0 = m, $a1 = n, returns $v0
ackermann:
    addi $sp, $sp, -16   # Make space for 4 words
    sw $ra, 12($sp)
    sw $a0, 8($sp)
    sw $a1, 4($sp)

    # if m == 0: return n+1
    beqz $a0, base_case_m0

    # if n == 0: return Ackermann(m-1, 1)
    beqz $a1, case_n0

    # Otherwise: return Ackermann(m-1, Ackermann(m, n-1))
    addi $a1, $a1, -1    # n-1
    jal ackermann        # Ackermann(m, n-1)
    move $t0, $v0        # Save result

    lw $a0, 8($sp)       # Restore m
    addi $a0, $a0, -1    # m-1
    move $a1, $t0        # n = result of previous call
    jal ackermann
    j end_ack

base_case_m0:
    lw $a1, 4($sp)
    addi $v0, $a1, 1
    j end_ack

case_n0:
    lw $a0, 8($sp)
    addi $a0, $a0, -1
    li $a1, 1
    jal ackermann

end_ack:
    lw $ra, 12($sp)
    addi $sp, $sp, 16
    jr $ra