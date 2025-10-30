.data

    # data goes here
    newLine: .asciiz "\n"

.text

    # code goes here

.globl main
.ent main
main:

    # //  arrays (dynamic allocation)
    # int n = 5;    (T0)
    li $t0, 5

    # int *data = (int *)malloc(n * sizeof(int)); (T1)
    li $v0, 9
    li $a0, 20  # 5 integers
    syscall
    move 	$t1, $v0		# $t1 = $v0

    # // populate the array
    li $t2, 0   # i=0
    # for (int i = 0; i < n; i++) {
    move 	$t4, $t1		# $t4 = $t1 (data array)
populateLoop:
    bge		$t2, $t0, donePopulate	# if $t2 >= $t0 then goto donePopulate

    # (i + 1) * 10
    move 	$t3, $t2		# $t3 = $t2
    addi	$t3, $t3, 1			# $t3 = $t3 + 1
    mul $t3, $t3, 10

    #     data[i] = (i + 1) * 10;
    sw		$t3, ($t4)		# 

    # i++
    addi	$t4, $t4, 4			# $t4 = $t4 + 1
    addi	$t2, $t2, 1			# $t2 = $t2 + 1
    j populateLoop

    # }

donePopulate:

    # //  print the array
    li $t2, 0   # i=0
    
    # for (int i = 0; i < n; i++) {
    move 	$t4, $t1		# $t4 = $t1 (data array)
printLoop:
    bge		$t2, $t0, donePrint	# if $t2 >= $t0 then goto donePrint
    
    #     printf("data[%d] = %d\n", i, data[i]);

    # print int
    li $v0, 1
    lw		$a0, ($t4)		# 
    syscall
    li $v0, 4
    la $a0, newLine
    syscall
    
    # i++
    addi	$t4, $t4, 4			# $t4 = $t4 + 1
    addi	$t2, $t2, 1			# $t2 = $t2 + 1
    j printLoop

    # }


donePrint:

    # noop -> not supported in QT SPIM

    # // free the allocated memory
    # free(data);

    # done
    li $v0, 10
    syscall

.end main