.data

    # data goes here
    arr: .word 11, 12, 13, 14, 15
         .word 21, 22, 23, 24, 25
         .word 31, 32, 33, 34, 35
         .word 41, 42, 43, 44, 45
         .word 51, 52, 53, 54, 55
    arraySize: .word 5
    # dataSize: .word 4 # size of an int

    # constants
    DATA_SIZE = 4

    outputMessage: .asciiz "Sum of diagonal elements: "

.text

    # code goes here

.globl main
.ent main
main:


    # call the function
    la $a0, arr
    lw $a1, arraySize
    jal sumDiagonal
    move 	$t0, $v0		# $t0 = $v0 (sum)

    # print string
    li $v0, 4
    la $a0, outputMessage
    syscall

    # print int
    li $v0, 1
    move 	$a0, $t0		# $a0 = $t0
    syscall

    # done
    li $v0, 10
    syscall

.end main

# 
#   function: sumDiagonal
#   input: a0 -> base address
#   input: a1 -> size of the array
#   output: v0 -> sum 
.globl sumDiagonal
.ent sumDiagonal
sumDiagonal:

    # input
    move 	$t0, $a0		# $t0 = $a0 (base address)
    move 	$t1, $a1		# $t1 = $a1 (array size)


    # int sum = 0;
    li $t2, 0

    # int row = 0
    li $t3, 0
sumLoop:
    bge		$t3, $t1, doneLoop	# if $t3 >= $t1 then goto doneLoop
    # for (int row = 0; row < size; row++) {

        # row major
        # addr = baseAddress + (rowIdx * numCols + colInx) * dataSize

        # (rowIdx * numCols + colInx)
        move 	$t4, $t3		# $t4 = $t3
        mul $t4, $t4, $t1
        add $t4, $t4, $t3

        # + (rowIdx * numCols + colInx) * dataSize
        mul $t4, $t4, DATA_SIZE

        # baseAddress + (rowIdx * numCols + colInx) * dataSize
        add $t4, $t0, $t4

        #     arr[row][row];
        lw $t5, ($t4)

        # sum += arr[row][row];
        add $t2, $t2, $t5

        # row++
        addi $t3, $t3, 1
        j sumLoop
    # }


doneLoop:
    # return sum;
    move 	$v0, $t2		# $v0 = $t2
    jr $ra
.end sumDiagonal





