.data

    # data goes here
    volume: .word 0
    surfaceArea: .word 0
    aMessage: .asciiz "Enter First Number: "
    bMessage: .asciiz "Enter Second Number: "
    cMessage: .asciiz "Enter Third Number: "
    volumeMessage: .asciiz "The volume is "
    surfaceAreaMessage: .asciiz "The surface area is "
    newline: .asciiz "\n"

.text

    # code goes here

.globl main
.ent main
main:

# // ask the user for a, b, c
#     int a, b, c;
#     printf("Enter First Number: ");
    li $v0, 4
    la $a0, aMessage
    syscall

#     scanf("%d", &a);
    li $v0, 5
    syscall
    move 	$t0, $v0		# $t0 = $v0

#     printf("Enter Second Number: ");
    li $v0, 4
    la $a0, bMessage
    syscall

#     scanf("%d", &b);
    li $v0, 5
    syscall
    move 	$t1, $v0		# $t0 = $v0

#     printf("Enter Third Number: ");
    li $v0, 4
    la $a0, cMessage
    syscall

#     scanf("%d", &c);
    li $v0, 5
    syscall
    move 	$t2, $v0		# $t0 = $v0

#     // calculate the volume
#     int volume = (a * b * c); -> T3
    move $t3, $t0
    mul $t3, $t3, $t1
    mul $t3, $t3, $t2
    sw $t3, volume

#     printf("The volume is %d.\n", volume);
    li $v0, 4
    la $a0, volumeMessage
    syscall
    li $v0, 1
    move $a0, $t3
    syscall
    li $v0, 4
    la $a0, newline
    syscall


#     // calculate the surface area
#     int surfaceArea = 2 * (a*b+a*c+b*c);  // t4 * t5 * t6
    mul $t4, $t0, $t1
    mul $t5, $t0, $t2
    mul $t6, $t1, $t2
    add $t7, $t4, $t5
    add $t7, $t7, $t6
    li $t8, 2
    mul $t7, $t7, $t8
    sw $t7, surfaceArea
    

#     printf("The surface area is %d.\n", surfaceArea);
    li $v0, 4
    la $a0, surfaceAreaMessage
    syscall
    li $v0, 1
    move $a0, $t7
    syscall
    li $v0, 4
    la $a0, newline
    syscall



    # done
    li $v0, 10
    syscall

.end main