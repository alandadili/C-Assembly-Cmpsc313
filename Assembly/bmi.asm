.data
weight_msg: .asciiz "Weight (kg): "
height_msg: .asciiz "Height (m): "
        
weight:  .float 81.6466 // 180 lbs in kg hard code
height:  .float 1.8288 // 6 ft in m hard code
bmi_msg: .asciiz "\nYour BMI is: "
newline: .asciiz "\n"
       
.text
.globl main

main:


    # Print weight message (kg)
    li $v0, 4
    la $a0, weight_msg
    syscall

    # Print weight value (float)
    li $v0, 2       
    l.s $f12, weight
    syscall

    # Print newline
    li $v0, 4
    la $a0, newline
    syscall

    # Print height message (m)
    li $v0, 4
    la $a0, height_msg
    syscall

    # Print height value (float)
    li $v0, 2
    l.s $f12, height
    syscall

    # Print newline
    li $v0, 4
    la $a0, newline
    syscall
    
    # Load weight and height
    l.s $f0, weight      
    l.s $f1, height      

    # height * height
    mul.s $f2, $f1, $f1 

    # Calculate BMI, weight / (height * height)
    div.s $f3, $f0, $f2  

    # Print BMI message
    li $v0, 4
    la $a0, bmi_msg
    syscall

    # Print BMI value (float)
    li $v0, 2
    mov.s $f12, $f3
    syscall

    # Print newline
    li $v0, 4
    la $a0, newline
    syscall

    # end
    li $v0, 10
    syscall
.end main