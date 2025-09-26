.data

    # data goes here

    # int data[] = {2, 7, 11, 15};
    data: .word 2, 7, 11, 15

    # int target = 9;
    target: .word 9

    # int arrayLength = sizeof(data) / sizeof(data[0]);
    arrayLength: .word 4

    # output
    newLine: .asciiz "\n"
    iOutput: .asciiz "i: "
    jOutput: .asciiz "j: "

    debug: .asciiz "DEBUG\n"

.text

    # code goes here

.globl main
.ent main
main:

    lw		$t0, arrayLength		# 
    li		$t1, 0		# $t1 = 0 (i)
    la		$t2, data		#
    lw		$t3, target		# 

outerLoop:
    # for (int i=0; i<arrayLength; i++) {
    bge		$t1, $t0, done	# if $t1 >= $t0 then goto done
    addi	$t4, $t1, 1		# $t4 = $t1 + 1 (j)

    innerLoop:
        #     for (int j=i+1; j<arrayLength; j++) {
        bge		$t4, $t0, endInnerLoop	# if $t4 >= $t0 then goto outerLoop

        # calculate data[i]
        mul     $t5, $t1, 4
        add     $t5, $t5, $t2
        lw		$t6, ($t5)		# 
        
        # calculate data[j]
        mul     $t7, $t4, 4
        add     $t7, $t7, $t2
        lw		$t8, ($t7)		# 

        # calculate data[i] + data[j]
        add		$t8, $t8, $t6		# $t8 = $t8 + $t6
        
        #         if (data[i] + data[j] == target) {
        #             goto done;
        bge		$t8, $t3, done	# if $t8 >= $t3 then goto done
        
        #         } # end inner for
        addi	$t4, $t4, 1			# $t4 = $t4 + 1 (j++)
        j innerLoop

    #     } # end outer for
    endInnerLoop:
    addi	$t1, $t1, 1			# $t1 = $t1 + 1 (i++)
    j outerLoop

    # }

done:

    #             printf("i: %d\n", i);
    li $v0, 4
    la $a0, iOutput
    syscall
    li $v0, 1
    move 	$a0, $t1		# $a0 = $t1 \
    syscall
    li $v0, 4
    la $a0, newLine
    syscall

    #             printf("j: %d\n", j);
    li $v0, 4
    la $a0, iOutput
    syscall
    li $v0, 1
    move 	$a0, $t4		# $a0 = $t1 
    syscall
    li $v0, 4
    la $a0, newLine
    syscall

    # done
    li $v0, 10
    syscall

.end main