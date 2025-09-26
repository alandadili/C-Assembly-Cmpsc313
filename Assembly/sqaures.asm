.data

    # data goes here
    result: .word 0
    inputMessage: .asciiz "Enter N: "
    outputMessage: .asciiz "Sum of squares = "
    newline: .asciiz "\n"

.text

    # code goes here

.globl main
.ent main
main:

    #     int n;
    # printf("Enter N: ");
    li $v0, 4
    la $a0, inputMessage
    syscall

    # scanf("%d",&n);
    li $v0, 5
    syscall
    move $t0, $v0   # t0 has n

    # int accum = 0;
    lw		$t1, result		# 
    
    # int i = 1;
    li $t2, 1

loopLabel:
    # while (i <= n) {
    bgt		$t2, $t0, outputLabel	# if $t2 > $t0 then goto output

        #     accum += i * i;
        mul $t3, $t2, $t2
        add $t1, $t1, $t3

        #     i++;
        addi	$t2, $t2, 1			# $t2 = $t2 + 1
        
        j loopLabel
    # }


outputLabel:
    # printf("Sum of squares = %d\n",accum);
    li $v0, 4
    la $a0, outputMessage
    syscall

    li $v0, 1 
    move $a0, $t1
    syscall

    li $v0, 4
    la $a0, newline
    syscall


    # done
    li $v0, 10
    syscall

.end main