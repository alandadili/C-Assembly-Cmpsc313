.data

    # data goes here
    newLine: .asciiz "\n"

.text

    # code goes here

.globl main
.ent main
main:

    # o1 = new object()
    la		$s0, object1		# 

    # o1.print()            # Hello World
    move 	$a0, $s0		# $a0 = $t0 (pass the object as the argument)
    lw		$s1, 0($s0)		# load the print()
    jalr $s1
    
    # o1.cancel()
    move 	$a0, $s0		# $a0 = $t0 (pass the object as the argument)
    lw		$s1, 4($s0)		# load the cancel()
    jalr $s1

    # o1.print()            # XXXXXXXXXXX
    move 	$a0, $s0		# $a0 = $t0 (pass the object as the argument)
    lw		$s1, 0($s0)		# load the print()
    jalr $s1
 




    # do the same for object 2
    la		$s0, object2		# new object()
    
    move 	$a0, $s0		# $a0 = $t0
    lw  $s1, 0($s0)
    jalr $s1                # object2.print()

    move 	$a0, $s0		# $a0 = $t0
    lw  $s1, 4($s0)
    jalr $s1                # object2.cancel()

    move 	$a0, $s0		# $a0 = $t0
    lw  $s1, 0($s0)
    jalr $s1                # object2.print()


    # done
    li $v0, 10
    syscall

.end main


#
#   objects
#   
.data 

object1:    # 32 bytes total
    .word print # jump table
    .word cancel    # jump table
    .asciiz "Hello World!"

object2:
    .word print
    .word cancel
    .asciiz "Computer Programming"


#
#   methods 
.text

.globl print
.ent print
print:

    # argument a0 is the object itself!
    li $v0, 4

    # 8 offset to get the string
    addi	$a0, $a0, 8			# $a0 = $a0 + 8
    syscall

    li $v0, 4
    la $a0, newLine
    syscall

    jr $ra
.end print


#
#   transforms "Hello" into "XXXXX"

.globl cancel
.ent cancel
cancel:

    # input: object in a0

    # get the string 8($a0)
    addi    $t0, $a0, 8
    li $t2, 'X'     # replacement character

    # get the first char of the string
    lb $t1, 0($t0)
loop:
    beqz $t1, done
    sb		$t2, 0($t0)		#   replace the byte with the X
    addi $t0, $t0, 1    # move to the next byte

    # load the next byte
    lb $t1, 0($t0)

    j loop
    

done:
    jr $ra
.end cancel