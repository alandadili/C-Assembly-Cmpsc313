.data

    # data goes here
    monthMessage: .asciiz "Enter a two digit month:"
    dayMessage: .asciiz "Enter a two digit day:"
    yearMessage: .asciiz "Enter a four digit year:"
    slash: .asciiz "/"
    newLine: .asciiz "\n"

.text

    # code goes here

.globl main
.ent main
main:

    # // create a date on the heap
    # Date *date = (Date *)malloc(sizeof(Date));
    li $v0, 9
    li $a0, 12
    syscall
    move 	$s0, $v0		# $s0 = $v0

    # //  ask the user for a two digit month
    # printf("Enter a two digit month: ");
    # scanf("%d", &m);
    li $v0, 4
    la $a0, monthMessage
    syscall
    li $v0, 5
    syscall
    move 	$t0, $v0		# $t0 = $v0

    # // ask the user for a two digit day
    # printf("Enter a two digit day: ");
    # scanf("%d", &d);
    li $v0, 4
    la $a0, dayMessage
    syscall
    li $v0, 5
    syscall
    move 	$t1, $v0		# $t0 = $v0


    # // ask the user for a four digit year
    # printf("Enter a four digit year: ");
    # scanf("%d", &y);
    li $v0, 4
    la $a0, yearMessage
    syscall
    li $v0, 5
    syscall
    move 	$t2, $v0		# $t0 = $v0

    # // store the values in the date struct
    # date->m = m;
    sw		$t0, 0($s0)		# 
    
    # date->d = d;
    sw		$t1, 4($s0)		# 

    # date->y = y;
    sw		$t2, 8($s0)		# 


    # printDate(date);    // MM/DD/YYYY
    move 	$a0, $s0		# $s0 = $s0
    jal printDate

    # printEuroDate(date);    // DD/MM/YYYY
    move 	$a0, $s0		# $s0 = $s0
    jal printEuroDate

    # //  free the date from the heap
    # free(date);

    # done
    li $v0, 10
    syscall

.end main


.globl printDate
.ent printDate
printDate:

    # preserve the saved registers
    sub		$sp, $sp, 4		# $sp = $sp - 4
    sw		$s0, 0($sp)		# 

    # get the argument
    move 	$s0, $a0		# $s0 = $a0
    
    # printf("%d/%d/%d\n", date->m, date->d, date->y);
    li $v0, 1
    lw		$a0, 0($s0)		# 
    syscall
    li $v0, 4
    la $a0, slash
    syscall
    li $v0, 1
    lw		$a0, 4($s0)		# 
    syscall
    li $v0, 4
    la $a0, slash
    syscall
    li $v0, 1
    lw		$a0, 8($s0)		# 
    syscall
    li $v0, 4
    la $a0, newLine
    syscall

    # restore the saved registers
    lw		$s0, 0($sp)		# 
    addi	$sp, $sp, 4			# $sp = $sp + 4
    
    jr $ra
.end printDate



.globl printEuroDate
.ent printEuroDate
printEuroDate:

    # preserve the saved registers
    sub		$sp, $sp, 4		# $sp = $sp - 4
    sw		$s0, 0($sp)		# 

    # get the argument
    move 	$s0, $a0		# $s0 = $a0
    
    # printf("%d/%d/%d\n", date->m, date->d, date->y);
    li $v0, 1
    lw		$a0, 4($s0)		# 
    syscall
    li $v0, 4
    la $a0, slash
    syscall
    li $v0, 1
    lw		$a0, 0($s0)		# 
    syscall
    li $v0, 4
    la $a0, slash
    syscall
    li $v0, 1
    lw		$a0, 8($s0)		# 
    syscall
    li $v0, 4
    la $a0, newLine
    syscall

    # restore the saved registers
    lw		$s0, 0($sp)		# 
    addi	$sp, $sp, 4			# $sp = $sp + 4
    
    jr $ra
.end printEuroDate