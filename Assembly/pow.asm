.data

    # data goes here
    xMessage: .asciiz "enter x: "
    yMessage: .asciiz "enter y: "
    returnMessage: .asciiz "X^Y = "

.text

    # code goes here

.globl main
.ent main
main:

    #     int x;
    # printf("enter x: ");
    li $v0, 4
    la $a0, xMessage
    syscall

    # scanf("%d", &x);
    li $v0, 5
    syscall
    move 	$t0, $v0		# $t0 = $v0 (X)

    # //  collect y
    # int y;
    # printf("enter y: ");
    li $v0, 4
    la $a0, yMessage
    syscall

    # scanf("%d", &y);
    li $v0, 5
    syscall
    move 	$t1, $v0		# $t0 = $v0 (Y)

    # // calculate pow
    # int result = pow(x, y);
    move 	$a0, $t0		# $a0 = $t0 
    move 	$a1, $t1		# $a1 = $t1
    jal		pow				# jump to pow and save position to $ra
    move 	$t0, $v0		# $t0 = $v0 (result)

    # printf("%d^%d = %d\n", x, y, result);
    li $v0, 4
    la $a0, returnMessage
    syscall
    li $v0, 1
    move 	$a0, $t0		# $a0 = $t0
    syscall


    # done
    li $v0, 10
    syscall

.end main

#
#   pow(x, y) -> this computes x^y
#   
#   registers used: 
#   INPUT: 
#       x -> $a0
#       y -> $a1
#   OUTPUT 
#       x^y -> $v0
#
.globl pow
.ent pow
pow:
    # int res = 1;
    li $t0, 1       # res
    move 	$t1, $a0		# $t1 = $a0 (X)
    move 	$t2, $a1		# $t2 = $a1 (Y)
    li $t3, 0       # int i = 0;

powLoop:
    # for (int i = 0; i < y; i++) {
    bge		$t3, $t2, donePow	# if $t3 >= $t2 then goto donePow
    

    #     res *= x;
        mul $t0, $t0, $t1

        addi $t3, $t3, 1 # i++
        j powLoop

    # }
    # return res;

donePow:

    # return res;
    move 	$v0, $t0		# $v0 = $t0

    jr $ra

.end pow


