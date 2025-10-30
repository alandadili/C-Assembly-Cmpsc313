.data

    # data goes here

.text

    # code goes here

.globl main
.ent main
main:


    # // make a linked list 10->20->30->40->50
    # store it in $s0

    # Node* head = (Node*)malloc(sizeof(Node));
    li $v0, 9
    li $a0, 8
    syscall
    move 	$t1, $v0		# $t0 = $v0
    move 	$s0, $v0		# $s0 = $v0 (store the head in s0)

    # head->data = 10;
    li $t0, 10
    sw		$t0, 0($t1)		#

    # head->next = (Node*)malloc(sizeof(Node));
    li $v0, 9
    li $a0, 8
    syscall
    move 	$t2, $v0		# $t0 = $v0

    # set t1->next
    sw		$t2, 4($t1)		# 
    

    # head->next->data = 20;
    li $t0, 20
    sw		$t0, 0($t2)		#

    # head->next->next = (Node*)malloc(sizeof(Node));
    li $v0, 9
    li $a0, 8
    syscall
    move 	$t3, $v0		# $t0 = $v0

    # set t2->next
    sw		$t3, 4($t2)		# 

    # head->next->next->data = 30;
    li $t0, 30
    sw		$t0, 0($t3)		#

    # head->next->next->next = (Node*)malloc(sizeof(Node));
    li $v0, 9
    li $a0, 8
    syscall
    move 	$t4, $v0		# $t0 = $v0

    # set t3->next
    sw		$t4, 4($t3)		# 

    # head->next->next->next->data = 40;
    li $t0, 40
    sw		$t0, 0($t4)		#

    # head->next->next->next->next = (Node*)malloc(sizeof(Node));
    li $v0, 9
    li $a0, 8
    syscall
    move 	$t5, $v0		# $t0 = $v0

    # set t4->next
    sw		$t5, 4($t4)		# 

    # head->next->next->next->next->data = 50;
    li $t0, 50
    sw		$t0, 0($t5)		#

    # head->next->next->next->next->next = NULL;
    li $t0, 0
    sw		$t0, 4($t5)		# 
    
    # done
    li $v0, 10
    syscall

.end main