.data

    # data goes here
    inputMessage: .asciiz "Enter a number: "
    newLine: .asciiz "\n"
    two: .word 2

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

    # to_binary(num);
    jal to_binary

    # Print newline
    li      $v0, 4
    la      $a0, newLine
    syscall

    # return 0;

    # done
    li $v0, 10
    syscall

.end main




.globl to_binary
.ent to_binary
to_binary:

    # Save $ra and $s0
    subu    $sp, $sp, 8
    sw      $ra, 0($sp)
    sw      $s0, 4($sp)

    # Move argument to $s0
    move    $s0, $a0

    # Load 2 into $t0
    lw      $t0, two

    # if ($s0 < 2)
    li      $t1, 2
    blt     $s0, $t1, baseCase

    # Recursive case:
    div     $s0, $t0        # $s0 / 10
    mflo    $a0             # a0 = $s0 / 10
    jal     to_binary

    # Print digit: $s0 % 10
    div     $s0, $t0
    mfhi    $a0             # a0 = $s0 % 10
    li      $v0, 1
    syscall

    j done

baseCase:
    # Print the single digit
    move    $a0, $s0
    li      $v0, 1
    syscall

done:
    # Restore $ra and $s0
    lw      $ra, 0($sp)
    lw      $s0, 4($sp)
    addiu   $sp, $sp, 8
    jr      $ra

.end to_binary
