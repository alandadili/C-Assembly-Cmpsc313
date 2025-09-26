.data

    # data goes here
    # int data[] = {7, 2, 3, 5, 9, 1};
data: .word 7, 2, 3, 5, 9, 1
    # const int arraySize = 6;
arraySize: .word 6
output: .asciiz "the index is "
input: .asciiz "Enter a number: "

.text

    # code goes here

.globl main
.ent main
main:

    # int number;

    # //ask the user for a number
    # printf("Enter a number: ");
    li $v0, 4
    la $a0, input
    syscall
    # scanf("%d", &number);
    li $v0, 5
    syscall
    move 	$t0, $v0		# $t0 = $v0

    # int index = -1;
    li $t1, -1
    li $t2, 0   # i=0
    lw $t3, arraySize
    la $t4, data

loop:
    bge		$t2, $t3, done	# if $t2 >= $t3 then goto done
    
    # for (int i = 0; i < arraySize; i++) {

        mul $t5, $t2, 4
        add $t6, $t4, $t5
        lw $t7, ($t6)   # data[i]
        bne		$t0, $t7, doneSet	# if $t0 != $t7 then goto doneSet
    #     if (number == data[i]) {
setIndex:
    move $t1, $t2
doneSet:
    addi $t2, $t2, 1
    j loop
    #         index = i;
    #     }
    # }


done:
    # //  print the index
    # printf("the index is %d\n", index);
    li $v0, 4
    la $a0, output
    syscall
    li $v0, 1
    move 	$a0, $t1		# $a0 = $t1
    syscall




    # done
    li $v0, 10
    syscall

.end main