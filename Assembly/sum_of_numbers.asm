.data

    # data goes here

    # int numbers[9] = {7, 9, 2, 4, 6, 8, 0, 3, 1};
numbers: .word 7, 9, 2, 4, 6, 8, 0, 3, 1

    # const int arraySize = 9;
arraySize: .word 9

sumOutput: .asciiz  "The sum of all the numbers is: "
avgOutput: .asciiz "The average is "
newLine:    .asciiz "\n"

.text

    # code goes here

.globl main
.ent main
main:

    # int sum = 0;
    li $t0, 0

    # //  get the memory address of the array numbers
    # int *ptr = numbers;
    la $t1, numbers

    li $t2, 0   # i = 0
    lw $t3, arraySize
loop:
    bge		$t2, $t3, doneLoop	# if $t2 >= $t3 then goto doneLoop
    
    # for (int i = 0; i < arraySize; i++) {
    #     // sum += numbers[i];
    #     sum += *ptr;    // de-refence the pointer
    lw $t4, ($t1)
    add $t0, $t0, $t4
    #     ptr++;          // set the pointer to the next int in the array!
    addi $t1, $t1, 4     # MIPS doesn't auto-convert like C does!
    # }
    addi $t2, $t2, 1    # i++

    j loop

doneLoop:
    # printf("The sum of all the numbers is: %d\n", sum);
    li $v0, 4
    la $a0, sumOutput
    syscall
    li $v0, 1
    move 	$a0, $t0		# $a0 = $t0 
    syscall
    li $v0, 4
    la $a0, newLine
    syscall

    # double average = (double)sum / arraySize;
    mtc1 $t0, $f8   # sum
    mtc1 $t3, $f10  # arraySize

    # convert both to double
    cvt.d.w     $f8, $f8
    cvt.d.w     $f10, $f10
    div.d $f12, $f8, $f10

    # printf("The average is %f\n", average);
    li $v0, 4
    la $a0, avgOutput
    syscall
    li $v0, 3
    syscall
    li $v0, 4
    la $a0, newLine
    syscall



    # done
    li $v0, 10
    syscall

.end main