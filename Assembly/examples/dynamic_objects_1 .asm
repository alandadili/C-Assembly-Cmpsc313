.data

    # data goes here
    newLine: .asciiz "\n"
    prompt: .asciiz "Please enter the data: "

.text

    # code goes here

.globl main
.ent main
main:

    # o1 = new object()
    # la		$s0, object1		# 
    li $v0, 9
    li $a0, 36
    syscall
    sw 	$v0, object1		# $v0 = object1

    # build the jump tables
    la		$t0, print		# 
    la		$t1, cancel		# 
    la      $t2, read
    sw		$t0, 0($v0)		# print()
    sw		$t1, 4($v0)		# cancel()
    sw		$t2, 8($v0)		# read()
    
    move 	$s0, $v0		# $s0 = $v0

    # read the input string
    # o1.read()
    move 	$a0, $s0		# $a0 = $s0
    lw		$s1, 8($s0)		# load the read()
    jalr $s1

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
 




    # # do the same for object 2
    # la		$s0, object2		# new object()
    
    # move 	$a0, $s0		# $a0 = $t0
    # lw  $s1, 0($s0)
    # jalr $s1                # object2.print()

    # move 	$a0, $s0		# $a0 = $t0
    # lw  $s1, 4($s0)
    # jalr $s1                # object2.cancel()

    # move 	$a0, $s0		# $a0 = $t0
    # lw  $s1, 0($s0)
    # jalr $s1                # object2.print()


    # done
    li $v0, 10
    syscall

.end main


#
#   objects
#   
.data 


# dynamic memory allocation
object1:    .word 0
object2:    .word 0

# object1:    # 36 bytes total
#     .word print # jump table
#     .word cancel    # jump table
#     .word read    # jump table
#     .asciiz "Hello World!"

# object2:
#     .word print
#     .word cancel
#     .word read
#     .asciiz "Computer Programming"


#
#   methods 
.text

#
#   reads a string using syscall 8
.globl read
.ent read
read:

    # input is the object itself in A0
    move 	$t7, $a0		# $t7 = $a0

    # print the prompt string
    li $v0, 4
    la $a0, prompt
    syscall

    #
    #   read string (2 args a0 and a1)
    li $v0, 8

    # address of the buffer in the object
    addi $a0, $t7, 12
    li $a1, 24          # size of the buffer
    syscall

    jr $ra
.end read

#
#   prints the string

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