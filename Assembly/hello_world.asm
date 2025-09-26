.text

    # declare the main function
    .globl main
main:

    # printf("Hello, World!\n");

    # MIPS has system calls
    #   "4" -> "print string"
    li $v0, 4
    la $a0, msg # "load array"
    syscall # execute

    # return 0;

    # "10" -> "terminate program"
    li $v0, 10
    syscall # execute

.data

# declare the variables
msg: .asciiz "Hello, World!\n"