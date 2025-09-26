.text

    .globl main

# int main()
main:

    # //  add three numbers
    # int num = 10;
    # load the value from data into a register
    lw $t0, num

    # num += 10;
    li $t1, 10
    add $t2, $t0, $t1   # t2 = t0+t1

    # num += 10;
    add $t2, $t2, $t1   # t2 = t2 + t1

    # printf("%d\n", num);

    # print the int

    # "1" -> "print int"
    li $v0, 1
    move 	$a0, $t2		# $a0 = $t2
    syscall

    # print the newline
    li $v0, 4
    la $a0, newLine
    syscall

    # shut it down
    li $v0, 10
    syscall

.data

# declare variables
newLine: .asciiz "\n"
num: .word 10