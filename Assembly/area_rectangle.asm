.data

    # data segment -> variables
lengthMessage: .asciiz "Please enter the length: "
widthMessage: .asciiz "Please enter the width: "
areaMessage: .asciiz "The area is: "
newLine: .asciiz "\n"

.text
    # text segment -> program code goes here

.globl main
.ent main
main:

    #     //  (1) collect length
    # int length;
    # printf("Please enter the length: ");
    li $v0, 4
    la $a0, lengthMessage
    syscall

    # scanf("%d",&length);
    li $v0, 5
    syscall # result is in $v0
    move 	$t0, $v0		# $t0 = $v0

    #     //  (2) collect width
    # int width;
    # printf("Please enter the width: ");
    li $v0, 4
    la $a0, widthMessage
    syscall

    # scanf("%d",&width);
    li $v0, 5
    syscall # width is in $v0
    move 	$t1, $v0		# $t1 = $v0

    # //  (3) calculate area
    # int area = length * width;
    mul $t2, $t1, $t0 # t2 = t1*t0

    # //  (4) output
    # printf("The area is: %d \n",area);
    li $v0, 4
    la $a0, areaMessage
    syscall

    # print int
    li $v0, 1   # print int
    # arg in a0
    move 	$a0, $t2		# $a0 = $t2
    syscall

    # print the new line
    li $v0, 4
    la $a0, newLine
    syscall

    li $v0, 10
    syscall
.end main
