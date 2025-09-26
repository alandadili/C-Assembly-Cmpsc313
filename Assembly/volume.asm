.data

    # data goes here
    inputMessage: .asciiz "Enter Radius: "
    outputMessage: .asciiz "Volume = "
    newline: .asciiz "\n"
    volume: .double 0.0
    pi: .double 3.1415926
    fourDividedByThree: .double 1.33333
    errorMessage: .asciiz "Radius must be greater than zero \n"

.text

    # code goes here

.globl main
.ent main
main:

    # // input: radius of a sphere (int)
    # // output: volume of a sphere (double)

    # //  collect radius
    # int radius;
    # printf("Enter Radius: ");
    li $v0, 4
    la $a0, inputMessage
    syscall

    # scanf("%d",&radius);
    li $v0, 5
    syscall
    move $t0, $v0

    # //  ensure positive
    # while (radius <= 0) {
loopLabel:
    bgtz $t0, bodyLabel
    
        #     printf("Radius must be greater than zero");
        li $v0, 4
        la $a0, errorMessage
        syscall

        #     printf("Enter Radius: ");
        li $v0, 4
        la $a0, inputMessage
        syscall

        #     scanf("%d",&radius);
        li $v0, 5
        syscall
        move $t0, $v0

        j loopLabel
    # }

bodyLabel:

    # //  calculate volume
    # double volume = (4/3.0) * 3.14159 * radius * radius * radius;

    # (1) move the radius to co-processor 0
    mtc1 $t0, $f6
    cvt.d.w $f6, $f6   # convert the integer to a double
    mul.d $f12, $f6, $f6
    mul.d $f12, $f12, $f6 # radius * radius * radius

    # load the coeffecients
    l.d $f8, pi
    mul.d $f12, $f8, $f12   # radius * radius * radius * pi
    l.d $f10, fourDividedByThree
    mul.d $f12, $f10, $f12   # radius * radius * radius * pi * 4/3
    s.d $f12, volume

    # printf("Volume = %5.2f",volume);
    li $v0, 4
    la $a0, outputMessage
    syscall

    # print double	3	$f12 = double value	(none)
    # f12 already has the argument!
    li $v0, 3   # print double
    # move.d $f12, $f12
    syscall

    li $v0, 4
    la $a0, newline
    syscall



    # done
    li $v0, 10
    syscall

.end main