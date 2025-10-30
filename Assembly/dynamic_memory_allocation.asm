.data

    # data goes here
    p1: .word 42

.text

    # code goes here

.globl main
.ent main
main:


    # // make an int (on the stack)
    # int p1 = 42;
    lw  $t0, p1

    # //  print the int
    # printf("p1: %d\n", p1);
    li $v0, 1
    move $a0, $t0
    syscall

    # //
    # //  dynamic memory allocation
    # // int *p1Ptr = malloc(sizeof(int)); // allocate memory for an int on the heap
    # int *p1Ptr = malloc(4); // 4 bytes for an int
    li $v0, 9   # new system call
    li $a0, 4   # 4 bytes to an int
    syscall

    # t0 has the dynamic memory address!
    move 	$t0, $v0		# $t0 = $v0

    # //  set the int
    # *p1Ptr = 43;
    li $t1, 43
    sw		$t1, 0($t0)		# 
    
    # //  print the int
    # printf("p1Ptr: %d\n", *p1Ptr);
    li $v0, 1
    lw $a0, ($t0)
    syscall

    # //  clean up memory (not supported in MIPS)
    # free(p1Ptr);


    # done
    li $v0, 10
    syscall

.end main