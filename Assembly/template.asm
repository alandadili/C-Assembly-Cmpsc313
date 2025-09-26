.data

    # data segment -> variables

.text
    # text segment -> program code goes here

.globl main
.ent main
main:


    li $v0, 10
    syscall
.end main
