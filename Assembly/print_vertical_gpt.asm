.data

    # data goes here
    inputMessage: .asciiz "Enter a number: "
    newLine: .asciiz "\n"
    ten: .word 10

.text

.globl main
.ent main
main:

    # code goes here    

    # //  ask the user for a number
    # printf("Enter a number: ");
    # scanf("%d", &num);
    li $v0, 4
    la $a0, inputMessage
    syscall
    li $v0, 5
    syscall
    move 	$a0, $v0		# $a0 = $v0

    # print_vertical(num);
    jal print_vertical

    # return 0;

    # done
    li $v0, 10
    syscall

.end main




.globl print_vertical
.ent print_vertical
print_vertical:

    # Save $ra and $s0
    subu    $sp, $sp, 8
    sw      $ra, 0($sp)
    sw      $s0, 4($sp)

    # Move argument to $s0
    move    $s0, $a0

    # Load 10 into $t0
    lw      $t0, ten

    # if ($s0 < 10)
    li      $t1, 10
    blt     $s0, $t1, baseCase

    # Recursive case:
    div     $s0, $t0        # $s0 / 10
    mflo    $a0             # a0 = $s0 / 10
    jal     print_vertical

    # Print digit: $s0 % 10
    div     $s0, $t0
    mfhi    $a0             # a0 = $s0 % 10
    li      $v0, 1
    syscall

    # Print newline
    li      $v0, 4
    la      $a0, newLine
    syscall

    j done

baseCase:
    # Print the single digit
    move    $a0, $s0
    li      $v0, 1
    syscall

    # Print newline
    li      $v0, 4
    la      $a0, newLine
    syscall

done:
    # Restore $ra and $s0
    lw      $ra, 0($sp)
    lw      $s0, 4($sp)
    addiu   $sp, $sp, 8
    jr      $ra

.end print_vertical
