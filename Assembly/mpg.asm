.data

    # data segment -> variables
gallonMessage: .asciiz "how many gallons of gas does the car hold?"
milesMessage: .asciiz "how many miles does it go before refueling?"
mpgMessage: .asciiz "MPG: "
newLine: .asciiz "\n"

.text
    # text segment -> program code goes here

.globl main
.ent main
main:

    #     // (1) ask for the number of gallons
    # printf("how many gallons of gas does the car hold?");
    li $v0, 4
    la $a0, gallonMessage
    syscall

    # int gallons;
    # scanf("%d",&gallons);
    li $v0, 5   # read int
    syscall
    # v0 holds the result

    # copy into t0
    move 	$t0, $v0		# $t0 = $v0

    




    # //  (2) ask for miles before refueling
    # printf("how many miles does it go before refueling?");
    li $v0, 4   # print string
    la $a0, milesMessage
    syscall
    
    # int miles;
    # scanf("%d",&miles);
    li $v0, 5   # read int
    syscall
    # result in v0, copy it to t1
    move 	$t1, $v0		# $t1 = $v0


    # //  (3) calculate MPG
    # int mpg = miles/gallons;
    div $t2, $t1, $t0   # t2 = t0 / t1



    # //  (4) output
    # printf("MPG: %d \n",mpg);
    li $v0, 4
    la $a0, mpgMessage
    syscall

    # print int
    li $v0, 1
    move 	$a0, $t2		# $a0 = $t2 
    syscall

    # print the newline
    li $v0, 4
    la $a0, newLine
    syscall



    li $v0, 10
    syscall
.end main
