.data
    prompt1:    .asciiz "Enter real part of first complex number: "
    prompt2:    .asciiz "Enter imaginary part of first complex number: "
    prompt3:    .asciiz "Enter real part of second complex number: "
    prompt4:    .asciiz "Enter imaginary part of second complex number: "
    
    addResult:  .asciiz "\nAddition Result: "
    subResult:  .asciiz "\nSubtraction Result: "
    
    openParen:  .asciiz "("
    comma:      .asciiz ", "
    closeParen: .asciiz ")"
    newline:    .asciiz "\n"

    # Two input complex numbers (each = 2 doubles = 16 bytes)
    .align 3               # ensure 8-byte alignment for doubles
    complex1: .space 16
    complex2: .space 16

.text
.globl main

main:
    # Read first complex number (real)
    li   $v0, 4
    la   $a0, prompt1
    syscall

    li   $v0, 7          # read double -> $f0
    syscall
    la   $t0, complex1
    s.d  $f0, 0($t0)

    # Read first complex number (imag)
    li   $v0, 4
    la   $a0, prompt2
    syscall

    li   $v0, 7
    syscall
    la   $t0, complex1
    s.d  $f0, 8($t0)

    # Read second complex number (real)
    li   $v0, 4
    la   $a0, prompt3
    syscall

    li   $v0, 7
    syscall
    la   $t0, complex2
    s.d  $f0, 0($t0)

    # Read second complex number (imag)
    li   $v0, 4
    la   $a0, prompt4
    syscall

    li   $v0, 7
    syscall
    la   $t0, complex2
    s.d  $f0, 8($t0)

    # Call Add(a0=complex1, a1=complex2) -> v0 = ptr to new result
    la   $a0, complex1
    la   $a1, complex2
    jal  Add
    move $s0, $v0        # save pointer to addition result

    # Print addition result
    li   $v0, 4
    la   $a0, addResult
    syscall

    move $a0, $s0
    jal  Print

    # Call Subtract(a0=complex1, a1=complex2) -> v0 = ptr to new result
    la   $a0, complex1
    la   $a1, complex2
    jal  Subtract
    move $s1, $v0        # save pointer to subtraction result

    # Print subtraction result
    li   $v0, 4
    la   $a0, subResult
    syscall

    move $a0, $s1
    jal  Print

    # Exit
    li   $v0, 10
    syscall

# Add: $a0=ptr to complex A, $a1=ptr to complex B
# Returns: $v0=ptr to newly allocated complex (via sbrk)
Add:
    addi $sp, $sp, -16
    sw   $ra, 0($sp)
    sw   $a0, 4($sp)
    sw   $a1, 8($sp)

    # Allocate 16 bytes for result
    li   $v0, 9          # sbrk
    li   $a0, 16
    syscall
    move $t0, $v0        # t0 = result pointer

    # Load args back
    lw   $t1, 4($sp)
    lw   $t2, 8($sp)

    # real part
    l.d  $f0, 0($t1)
    l.d  $f2, 0($t2)
    add.d $f4, $f0, $f2
    s.d  $f4, 0($t0)

    # imag part
    l.d  $f0, 8($t1)
    l.d  $f2, 8($t2)
    add.d $f4, $f0, $f2
    s.d  $f4, 8($t0)

    move $v0, $t0        # return pointer

    lw   $ra, 0($sp)
    addi $sp, $sp, 16
    jr   $ra

# Subtract: $a0=ptr to A, $a1=ptr to B
# Returns: $v0=ptr to newly allocated complex (A - B)
Subtract:
    addi $sp, $sp, -16
    sw   $ra, 0($sp)
    sw   $a0, 4($sp)
    sw   $a1, 8($sp)

    # Allocate 16 bytes for result
    li   $v0, 9
    li   $a0, 16
    syscall
    move $t0, $v0

    lw   $t1, 4($sp)
    lw   $t2, 8($sp)

    # real part
    l.d  $f0, 0($t1)
    l.d  $f2, 0($t2)
    sub.d $f4, $f0, $f2
    s.d  $f4, 0($t0)

    # imag part
    l.d  $f0, 8($t1)
    l.d  $f2, 8($t2)
    sub.d $f4, $f0, $f2
    s.d  $f4, 8($t0)

    move $v0, $t0

    lw   $ra, 0($sp)
    addi $sp, $sp, 16
    jr   $ra

# Print: $a0=ptr to complex; prints "(a, b)\n"
Print:
    addi $sp, $sp, -8
    sw   $ra, 0($sp)
    sw   $a0, 4($sp)

    # "("
    li   $v0, 4
    la   $a0, openParen
    syscall

    # real
    lw   $t0, 4($sp)
    l.d  $f12, 0($t0)
    li   $v0, 3          # print double
    syscall

    # ", "
    li   $v0, 4
    la   $a0, comma
    syscall

    # imag
    lw   $t0, 4($sp)
    l.d  $f12, 8($t0)
    li   $v0, 3
    syscall

    # ")"
    li   $v0, 4
    la   $a0, closeParen
    syscall

    # "\n"
    li   $v0, 4
    la   $a0, newline
    syscall

    lw   $ra, 0($sp)
    addi $sp, $sp, 8
    jr   $ra