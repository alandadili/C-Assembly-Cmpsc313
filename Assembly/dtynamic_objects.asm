.data

    # data goes here
    m1: .asciiz "hello "
    m2: .asciiz "world!"

.text

    # code goes here

.globl main
.ent main
main:

    # object1 = new object()
    # la		$t1, object1		# 

    # dynamic memory
    li $v0, 9

    # 4 bytes for the print method
    # 24 bytes for the string
    li $a0, 28
    syscall
    move 	$t0, $v0		# $t0 = $v0

    # build the object
    lw		$t3, print		# 
    sw		$t3, 0($t0)		# jump table
    la      $t4, m1
    sw		$t4, 4($t0)		# data

    # save the object
    la		$t6, object1		# 
    sw		$t0, 0($t6)		# 
    la		$t1, object1
    
    # object1.print()
    lw		$t2, 0($t1)		# 
    # pass object1 as the argument!
    move 	$a0, $t1		# $a0 = $t1
    jalr $t2


    #
    #
    #
    #
    #
    

    # object2 = new object()
    # la  $t1, object2
    # dynamic memory
    li $v0, 9

    # 4 bytes for the print method
    # 24 bytes for the string
    li $a0, 28
    syscall
    move 	$t0, $v0		# $t0 = $v0

    # build the object
    lw		$t3, print		# 
    sw		$t3, 0($t0)		# jump table
    la      $t4, m2
    sw		$t4, 4($t0)		# data

    # save the object
    la		$t6, object2		# 
    sw  $t1, ($t6)
    la		$t1, object2








    # object2.print()
    lw		$t2, 0($t1)		# 
    # pass object2 as the argumnet
    move 	$a0, $t1		# $a0 = $t1
    jalr    $t2
    

    # done
    li $v0, 10
    syscall

.end main


.data

# dynamic objects!
# object1: .word print            # jump table
#         .asciiz "Hello "        # instance data
# object2: .word print
#         .asciiz "World!" 
object1:    .word 0
object2:    .word 0


.text

.globl print
.ent print
print:
    li $v0, 4
    
    # memory address for the ascii data
    # input: $a0 -> object
    addi	$a0, $a0, 4			# $a0 = $a0 + 4
    

    syscall


    jr $ra
.end print















