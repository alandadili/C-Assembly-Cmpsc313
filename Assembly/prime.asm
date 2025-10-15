.data
msg_input:    .asciiz "Enter an integer: "
msg_prime:    .asciiz " is prime\n"
msg_notprime: .asciiz " is not prime\n"

.text
.globl main

main:
    # Prompt user input
    la $a0, msg_input
    li $v0, 4
    syscall

    # Read integer
    li $v0, 5
    syscall
    move $s0, $v0      # Save user input in $s0

    move $a0, $s0      # $a0 = user input for isPrime
    jal isPrime
    move $t0, $v0      # Save result (1=prime, 0=not)

    # Print the original input
    move $a0, $s0
    li $v0, 1
    syscall

    # Print prime/not prime message
    beqz $t0, print_notprime
    la $a0, msg_prime
    li $v0, 4
    syscall
    j end

print_notprime:
    la $a0, msg_notprime
    li $v0, 4
    syscall

end:
    li $v0, 10
    syscall

# isPrime: $a0 = number, returns $v0 = 1 if prime, 0 if not
isPrime:
    move $t0, $a0      # n
    li $v0, 1          # Assume prime

    ble $t0, 1, not_prime   # n <= 1 is not prime

    li $t1, 2          # i = 2
prime_loop:
    mul $t2, $t1, $t1
    bgt $t2, $t0, end_prime # if i*i > n, done

    div $t0, $t1
    mfhi $t3
    beqz $t3, not_prime     # if n % i == 0, not prime

    addi $t1, $t1, 1
    j prime_loop
end_prime:
    li $v0, 1
    jr $ra
not_prime:
    li $v0, 0
    jr $ra