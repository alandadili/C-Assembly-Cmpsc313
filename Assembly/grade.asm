.data

    # data goes here
    grade: .word 0
    inputMessage: .asciiz "Enter your grade: "
    aMessage: .asciiz "You entered A\n"
    bMessage: .asciiz "You entered B\n"
    cMessage: .asciiz "You entered C\n"
    dMessage: .asciiz "You entered D\n"
    fMessage: .asciiz "You entered F\n"
    newline: .asciiz "\n"

.text

    # code goes here

.globl main
.ent main
main:

    #     int grade;
    # printf("Enter your grade: ");
    li $v0, 4
    la $a0, inputMessage
    syscall

    # scanf("%d",&grade);
    li $v0, 5
    syscall
    move $t0, $v0
    sw $t0, grade

    # debug!
    li $v0, 1
    move $a0, $t0
    syscall
    li $v0, 4
    la $a0, newline
    syscall


    # cases!
    bge		$t0, 90, aLabel	# if $t0 >= 90 then goto aLabel
    bge		$t0, 80, bLabel	# if $t0 >= 80 then goto bLabel
    bge		$t0, 70, cLabel	# if $t0 >= 70 then goto cLabel
    bge		$t0, 60, dLabel	# if $t0 >= 60 then goto dLabel
    bge		$t0, 0, fLabel	# if $t0 >= 0 then goto fLabel
    



    # printf("You entered A");
aLabel:
    li $v0, 4
    la $a0, aMessage
    syscall
    j done

bLabel:
    # printf("You entered B");
    li $v0, 4
    la $a0, bMessage
    syscall
    j done

cLabel:
    # printf("You entered C");
    li $v0, 4
    la $a0, cMessage
    syscall
    j done

dLabel:
    # printf("You entered D");
    li $v0, 4
    la $a0, dMessage
    syscall
    j done

fLabel:
    # printf("You entered F");
    li $v0, 4
    la $a0, fMessage
    syscall
    j done



done:
    # done
    li $v0, 10
    syscall

.end main