.data

# Matrix A: 2x3
A:      .word 1, 2, 3, 4, 5, 6
A_rows: .word 2
A_cols: .word 3

# Matrix B: 3x2
B:      .word 7, 8, 9, 10, 11, 12
B_rows: .word 3
B_cols: .word 2

# Result matrix (2x2, enough space for 4 words)
C:      .space 16

newline: .asciiz "\n"
msg_ok:  .asciiz "Result matrix:\n"
msg_err: .asciiz "Matrix multiplication not possible.\n"

.text
.globl main

main:
    # Load addresses
    la $a0, A
    la $a1, B
    la $a2, C
    lw $t0, A_rows
    lw $t1, A_cols
    lw $t2, B_rows
    lw $t3, B_cols
    # Check if A_cols == B_rows
    bne $t1, $t2, mult_error
    # Pass A_rows in $a3, call multiply
    move $a3, $t0      # A_rows
    jal multiply
    # Print result matrix
    la $a0, msg_ok
    li $v0, 4
    syscall
    la $t6, C
    lw $t7, A_rows     # rows
    lw $t8, B_cols     # cols
    li $t9, 0          # i = 0
print_row:
    bge $t9, $t7, end_print
    li $s0, 0          # j = 0
print_col:
    bge $s0, $t8, next_row
    mul $s1, $t9, $t8
    add $s1, $s1, $s0
    sll $s1, $s1, 2
    add $s2, $t6, $s1
    lw $a0, 0($s2)
    li $v0, 1
    syscall
    la $a0, newline
    li $v0, 4
    syscall
    addi $s0, $s0, 1
    j print_col
next_row:
    addi $t9, $t9, 1
    j print_row
end_print:
    li $v0, 10
    syscall
mult_error:
    la $a0, msg_err
    li $v0, 4
    syscall
    li $v0, 10
    syscall
multiply:
    move $s0, $a0      # A
    move $s1, $a1      # B
    move $s2, $a2      # C
    move $s3, $a3      # A_rows (m)
    lw   $s4, A_cols   # A_cols (n)
    lw   $s5, B_cols   # B_cols (p)
    li $t0, 0          # i = 0
mult_i_loop:
    bge $t0, $s3, mult_end
    li $t1, 0          # j = 0
mult_j_loop:
    bge $t1, $s5, mult_next_i
    li $t2, 0          # sum = 0
    li $t3, 0          # k = 0
mult_k_loop:
    bge $t3, $s4, mult_store
    # A[i][k]
    mul $t4, $t0, $s4
    add $t4, $t4, $t3
    sll $t4, $t4, 2
    add $t5, $s0, $t4
    lw $t6, 0($t5)
    # B[k][j]
    mul $t7, $t3, $s5
    add $t7, $t7, $t1
    sll $t7, $t7, 2
    add $t8, $s1, $t7
    lw $t9, 0($t8)
    # sum += A[i][k] * B[k][j]
    mul $t6, $t6, $t9
    add $t2, $t2, $t6
    addi $t3, $t3, 1
    j mult_k_loop
mult_store:
    # C[i][j] = sum
    mul $t4, $t0, $s5
    add $t4, $t4, $t1
    sll $t4, $t4, 2
    add $t5, $s2, $t4
    sw $t2, 0($t5)
    addi $t1, $t1, 1
    j mult_j_loop
mult_next_i:
    addi $t0, $t0, 1
    j mult_i_loop
mult_end:
    jr $ra