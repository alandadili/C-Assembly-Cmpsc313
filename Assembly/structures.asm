.data

    # data goes here
    employee: .space 12
    ageMessage: .asciiz "age: "
    payMessage: .asciiz "pay: "
    classMessage: .asciiz "class: "
    newLine: .asciiz "\n"


.text

    # code goes here

.globl main
.ent main
main:

    # // make a employee
    # EMPLOYEE employee;  // stack
    la		$t0, employee		# 
    
    # employee.age = 34;
    li $t1, 34
    sw		$t1, 0($t0)		# 
    
    # employee.pay = 24000;
    li $t1, 24000
    sw		$t1, 4($t0)		#

    # employee.class = 12;
    li $t1, 12
    sw		$t1, 8($t0)		#

    # printStruct(employee);
    move 	$a0, $t0		# $a0 = $t0
    jal printStruct


    # // make a employee (heap)
    # EMPLOYEE *employee2;
    # employee2 = (EMPLOYEE *)malloc(sizeof(EMPLOYEE)); // heap
    li $v0, 9
    li $a0, 12
    syscall
    move 	$t0, $v0		# $t0 = $v0


    # // populate
    # // (*employee2).age = 45;
    li $t1, 45  
    sw		$t1, 0($t0)		# 

    # // (*employee2).pay = 45000;
    li $t1, 45000
    sw		$t1, 4($t0)		#

    # // (*employee2).class = 15;
    li $t1, 15
    sw		$t1, 8($t0)		#
    # employee2->age = 45;
    # employee2->pay = 45000;
    # employee2->class = 15;
    # printHeapStruct(employee2);
    move 	$a0, $t0		# $a0 = $t0
    jal printStruct

    # // free (not supported)
    # free(employee2);
    
    # employee2 = NULL;
    li $t0, 0



    # done
    li $v0, 10
    syscall

.end main

# function : printStruct
.globl printStruct
.ent printStruct
printStruct:

    move 	$t5, $a0		# $t5 = $t1

    # printf("age: %i\n", person.age);
    li $v0, 4
    la $a0, ageMessage
    syscall
    li $v0, 1
    lw		$a0, 0($t5)		# age
    syscall
    li $v0, 4
    la $a0, newLine
    syscall

    # printf("pay: %i\n", person.pay);
    li $v0, 4
    la $a0, payMessage
    syscall
    li $v0, 1
    lw		$a0, 4($t5)		# pay
    syscall
    li $v0, 4
    la $a0, newLine
    syscall

    # printf("class: %i\n", person.class);
    li $v0, 4
    la $a0, classMessage
    syscall
    li $v0, 1
    lw		$a0, 8($t5)		# class
    syscall
    li $v0, 4
    la $a0, newLine
    syscall



    jr $ra
.end printStruct