.data

    # data goes here
number: .word 42
output1: .asciiz "Value of number = "
output2: .asciiz "Value of dataUsingIndirection = "

.text

    # code goes here

.globl main
.ent main
main:

    #     //  pointers
    # int number = 42;    // raw integer 32 bit (DATA SEGEMENT)
    # int *numPtr = NULL;        // memory address that points to an integer
    # numPtr = &number;
    la		$t1, number		# 
    

    # find the address of number

    # // print out the data itself
    # printf("Value of number = %d\n", number);
    li $v0, 4
    la $a0, output1
    syscall
    li $v0, 1
    lw $a0, number
    syscall

    # //  how would we do the above with only numPtr?
    # //  use pointer indirection!
    # int dataUsingIndirection = *numPtr;
    la $t3, number

    # printf("Value of dataUsingIndirection = %d\n", dataUsingIndirection);
    li $v0, 4
    la $a0, output2
    syscall
    li $v0, 1
    lw $a0, ($t3)   # int dataUsingIndirection = *numPtr;
    syscall


    # done
    li $v0, 10
    syscall

.end main