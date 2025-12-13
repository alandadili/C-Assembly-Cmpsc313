.data
set1: .space 404      # 101 integers (0-100) = 404 bytes
set2: .space 404
set3: .space 404
newline: .asciiz "\n"
space: .asciiz " "

.text
.globl main

main:
    # Initialize stack
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Test IntegerSet operations
    # Create set1
    la $a0, set1
    jal initSet
    
    # Create set2
    la $a0, set2
    jal initSet
    
    # Insert elements into set1: {1, 3, 5, 7}
    la $a0, set1
    li $a1, 1
    jal insertElement
    
    la $a0, set1
    li $a1, 3
    jal insertElement
    
    la $a0, set1
    li $a1, 5
    jal insertElement
    
    la $a0, set1
    li $a1, 7
    jal insertElement
    
    # Insert elements into set2: {3, 5, 9, 11}
    la $a0, set2
    li $a1, 3
    jal insertElement
    
    la $a0, set2
    li $a1, 5
    jal insertElement
    
    la $a0, set2
    li $a1, 9
    jal insertElement
    
    la $a0, set2
    li $a1, 11
    jal insertElement
    
    # Print set1
    la $a0, set1
    jal printSet
    
    # Print newline
    li $v0, 4
    la $a0, newline
    syscall
    
    # Print set2
    la $a0, set2
    jal printSet
    
    # Print newline
    li $v0, 4
    la $a0, newline
    syscall
    
    # Test union
    la $a0, set1
    la $a1, set2
    la $a2, set3
    jal unionOf
    
    la $a0, set3
    jal printSet
    
    # Print newline
    li $v0, 4
    la $a0, newline
    syscall
    
    # Test intersection
    la $a0, set1
    la $a1, set2
    la $a2, set3
    jal intersectionOf
    
    la $a0, set3
    jal printSet
    
    # Exit
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    li $v0, 10
    syscall

# Initialize set to empty (all zeroes)
# $a0 = address of set
initSet:
    li $t0, 0           # counter
    li $t1, 101         # size
init_loop:
    beq $t0, $t1, init_done
    sll $t2, $t0, 2     # multiply by 4
    add $t3, $a0, $t2
    sw $zero, 0($t3)
    addi $t0, $t0, 1
    j init_loop
init_done:
    jr $ra

# Insert element k into set
# $a0 = address of set
# $a1 = element k
insertElement:
    blt $a1, $zero, insert_done  # if k < 0, return
    bgt $a1, 100, insert_done    # if k > 100, return
    
    sll $t0, $a1, 2     # k * 4
    add $t1, $a0, $t0   # address of set[k]
    li $t2, 1
    sw $t2, 0($t1)      # set[k] = 1
insert_done:
    jr $ra

# Delete element k from set
# $a0 = address of set
# $a1 = element k
deleteElement:
    blt $a1, $zero, delete_done
    bgt $a1, 100, delete_done
    
    sll $t0, $a1, 2
    add $t1, $a0, $t0
    sw $zero, 0($t1)    # set[k] = 0
delete_done:
    jr $ra

# Union of two sets
# $a0 = set1, $a1 = set2, $a2 = result set
unionOf:
    addi $sp, $sp, -4
    sw $s0, 0($sp)
    
    li $s0, 0           # counter
union_loop:
    li $t0, 101
    beq $s0, $t0, union_done
    
    sll $t1, $s0, 2     # offset
    add $t2, $a0, $t1   # set1[i]
    add $t3, $a1, $t1   # set2[i]
    add $t4, $a2, $t1   # result[i]
    
    lw $t5, 0($t2)
    lw $t6, 0($t3)
    or $t7, $t5, $t6    # result = set1[i] OR set2[i]
    sw $t7, 0($t4)
    
    addi $s0, $s0, 1
    j union_loop
union_done:
    lw $s0, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Intersection of two sets
# $a0 = set1, $a1 = set2, $a2 = result set
intersectionOf:
    addi $sp, $sp, -4
    sw $s0, 0($sp)
    
    li $s0, 0
inter_loop:
    li $t0, 101
    beq $s0, $t0, inter_done
    
    sll $t1, $s0, 2
    add $t2, $a0, $t1
    add $t3, $a1, $t1
    add $t4, $a2, $t1
    
    lw $t5, 0($t2)
    lw $t6, 0($t3)
    and $t7, $t5, $t6   # result = set1[i] AND set2[i]
    sw $t7, 0($t4)
    
    addi $s0, $s0, 1
    j inter_loop
inter_done:
    lw $s0, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Print set elements separated by spaces
# $a0 = address of set
printSet:
    addi $sp, $sp, -8
    sw $ra, 4($sp)
    sw $s0, 0($sp)
    
    li $s0, 0
print_loop:
    li $t0, 101
    beq $s0, $t0, print_done
    
    sll $t1, $s0, 2
    add $t2, $a0, $t1
    lw $t3, 0($t2)
    
    beqz $t3, print_skip
    
    # Print element
    li $v0, 1
    move $a0, $s0
    syscall
    
    # Print space
    li $v0, 4
    la $a0, space
    syscall
    
print_skip:
    addi $s0, $s0, 1
    j print_loop
print_done:
    lw $s0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8
    jr $ra

# Compare two sets for equality
# $a0 = set1, $a1 = set2
# Returns $v0 = 1 if equal, 0 otherwise
equals:
    li $t0, 0
    li $v0, 1           # assume equal
equals_loop:
    li $t1, 101
    beq $t0, $t1, equals_done
    
    sll $t2, $t0, 2
    add $t3, $a0, $t2
    add $t4, $a1, $t2
    
    lw $t5, 0($t3)
    lw $t6, 0($t4)
    
    bne $t5, $t6, not_equal
    
    addi $t0, $t0, 1
    j equals_loop
not_equal:
    li $v0, 0
equals_done:
    jr $ra