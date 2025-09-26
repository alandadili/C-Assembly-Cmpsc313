.data

    # data goes here
    # int data[] = {5, 7, 9, 2, 6, 1};
data: .word 5, 7, 9, 2, 6, 1
    # const int arrayLength = sizeof(data) / sizeof(data[0]);
arrayLength: .word 6
arrayLengthMinusOne: .word 5
whiteSpace: .asciiz " "
newLine: .asciiz "\n"
breaker: .asciiz "****\n"
doneMsg: .asciiz "done sort\n"

.text

    # code goes here

.globl main
.ent main
main:


    #
    #   sort piece
    # //  sort these
    # int didSwap = 0; // boolean :(
sortLoop:
    # do {
    #     didSwap = 0;
    li $t0, 0



    
    li $t1, 0   # i = 0
    lw $t2, arrayLengthMinusOne
    la $t3, data
    #     for (int i = 0; i < arrayLength-1; i++) {
sortInnerLoop:
    bge		$t1, $t2, doneInnerSort	# if $t1 >= $t2 then goto doneInnerSort
    



        # find data[i] and data[i+1]
        mul $t4, $t1, 4
        add $t5, $t3, $t4
        lw $t6, ($t5)   # data[i]

        addi $t4, $t1, 1
        mul $t4, $t4, 4
        add $t5, $t3, $t4
        lw $t7, ($t5)   # data[i+1]

    
    #         if (data[i] > data[i + 1]) {
    ble		$t6, $t7, endSwap	# if $t6 <= $t7 then goto endSwap
    
                                            # swap debug
                                            li $v0, 1
                                            move $a0, $t6
                                            syscall
                                            li $v0, 4
                                            la $a0, whiteSpace
                                            syscall
                                            li $v0, 1
                                            move $a0, $t7
                                            syscall
                                            li $v0, 4
                                            la $a0, newLine
                                            syscall

#     #             didSwap = 1;
        li $t0, 1

#     #             int temp = data[i];   
#     #             data[i] = data[i + 1];
        mul $t4, $t1, 4
        add $t5, $t3, $t4
        sw		$t7, ($t5)		# 

                                            # debug
                                            li $v0, 1
                                            lw $a0, ($t5)
                                            syscall
                                            li $v0, 4
                                            la $a0, whiteSpace
                                            syscall

                                        
        
#     #             data[i + 1] = temp;
        addi $t4, $t1, 1
        mul $t4, $t4, 4
        add $t5, $t3, $t4
        sw		$t6, ($t5)		# 

        
                                            # debug
                                            li $v0, 1
                                            lw $a0, ($t5)
                                            syscall
                                            li $v0, 4
                                            la $a0, newLine
                                            syscall

                                            li $v0, 4
                                            la $a0, breaker
                                            syscall
endSwap:
    



            addi	$t1, $t1, 1			# $t1 = $t1 + 1 (i++)
            j sortInnerLoop
doneInnerSort:
    #         } # end for
    #     }




    # } while (didSwap);
    beq		$t0, 1, sortLoop	# if $t0 == 1 then goto sortLoop
    

doneSort:

li $v0, 4
la $a0, doneMsg
syscall



    #
    # print piece



    #     //   output these
    # for (int i = 0; i < arrayLength; i++) {
    #     printf("%d ", data[i]);
    # }
    li $t0, 0
    lw $t1, arrayLength
    la $t2, data
loop:
    bge		$t0, $t1, doneCode	# if $t0 >= $t1 then goto doneCode
    mul $t3, $t0, 4
    add $t4, $t3, $t2
    li $v0, 1
    lw $a0 ($t4)    # data[i]
    syscall
    li $v0, 4
    la $a0, whiteSpace
    syscall
    addi $t0, $t0, 1
    j loop

doneCode:

    # done
    li $v0, 10
    syscall

.end main