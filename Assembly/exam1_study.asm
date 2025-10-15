.data
# ===== Variable Declarations =====
myInt:     .word 42                # Integer
myArray:   .word 10, 20, 30, 40    # Integer array
myFloat:   .float 3.14             # Single precision float
myDouble:  .double 2.718281828     # Double precision float
message:   .asciiz "MIPS Example Complete!\n"

.text
.globl main
main:
    # ===== Integer =====
    lw $t0, myInt          # Load integer 42 into $t0

    # ===== Array =====
    lw $t1, myArray        # Load first element (10)
    lw $t2, myArray+4      # Load second element (20)
    add $t3, $t1, $t2      # $t3 = 10 + 20 = 30

    # ===== Floating Point =====
    l.s $f0, myFloat       # Load single-precision float 3.14
    l.d $f2, myDouble      # Load double-precision float 2.718281828

    # ===== Print message =====
    li $v0, 4              # syscall: print string
    la $a0, message
    syscall

    # ===== Exit program =====
    li $v0, 10             # syscall: exit
    syscall