.data
sec_per:   .asciiz "Enter the total seconds in a period: "
hours_msg:    .asciiz "Hours: "
minutes_msg:  .asciiz ", Minutes: "
seconds_msg:  .asciiz ", Seconds: "
newline:      .asciiz "\n"

.text
.globl main

main:

    # Load input seconds
    # Prompt user for input seconds
    li $v0, 4
    la $a0, sec_per
    syscall

    li $v0, 5
    syscall
    move $t0, $v0            # $t0 = sec_per

    # Calculate hours = sec_per / 3600
    li $t1, 3600
    div $t0, $t1
    mflo $t2                 # $t2 = hours

    # sec_per = sec_per % 3600
    mfhi $t0                 # $t0 = sec_per % 3600

    # Calculate minutes = sec_per / 60
    li $t1, 60
    div $t0, $t1
    mflo $t3                 # $t3 = minutes

    # seconds = sec_per % 60
    mfhi $t4                 # $t4 = seconds

    # Print hours
    li $v0, 4
    la $a0, hours_msg
    syscall
    li $v0, 1
    move $a0, $t2
    syscall

    # Print minutes
    li $v0, 4
    la $a0, minutes_msg
    syscall
    li $v0, 1
    move $a0, $t3
    syscall

    # Print seconds
    li $v0, 4
    la $a0, seconds_msg
    syscall
    li $v0, 1
    move $a0, $t4
    syscall

    # Print newline
    li $v0, 4
    la $a0, newline
    syscall

    # Exit
    li $v0, 10
    syscall