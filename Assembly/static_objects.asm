.data

    # data goes here

.text

    # code goes here

.globl main
.ent main
main:

    # object1 = new object()
    la		$t1, object1		# 
    # object1.print()
    lw		$t2, 0($t1)		# 
    # pass object1 as the argument!
    move 	$a0, $t1		# $a0 = $t1
    jalr $t2
    

    # object2 = new object()
    la  $t1, object2

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

# static objects!
object1: .word print            # jump table
        .asciiz "Hello "        # instance data
object2: .word print
        .asciiz "World!" 
printAddr: .word print


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















