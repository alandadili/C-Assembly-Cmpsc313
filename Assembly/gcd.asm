.data

    # data goes here
    aInput: .word 56
    bInput: .word 98

.text

    # code goes here

.globl main
.ent main
main:

    # int a = 56;
    lw		$a0, aInput		# 
    
    # int b = 98;
    lw		$a1, bInput		# 
    
    # int result = gcd(a, b);
    jal gcd
    move 	$a0, $v0		# $a0 = $v0

    # printf("GCD of %d and %d is %d\n", a, b, result);
    li $v0, 1
    syscall # a0 is set above


    # done
    li $v0, 10
    syscall

.end main

#
#   input:
#       A -> $a0
#       B -> $a1
#       gcd(A, B) -> $v0
#
.globl gcd
.ent gcd
gcd:

    # push the "saved" registers onto the stack
    subu    $sp, $sp, 4
    sw		$ra, 0($sp)		# 
    

    # collect inputs
    move 	$t0, $a0		# $t0 = $a0 (A)
    move 	$t1, $a1		# $t1 = $a  (B)

    # if (b == 0) {
    #     return a;
    # }
    beq		$t1, 0, baseCase	# if $t1 == 0 then goto doneGcd
    
    # return gcd(b, a % b);
    div $t0,$t1
    mfhi $t2
    move 	$a0, $t1		# $a0 = $t1
    move 	$a1, $t2		# $a1 = $t1
    jal gcd
    j done

baseCase:
    move 	$v0, $t0		# $v0 = $t0
done:
    # restore the saved registers (pop)
    lw		$ra, 0($sp)		# 
    addu    $sp, $sp, 4

    jr $ra
.end gcd