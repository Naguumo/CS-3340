	.data
a:	.word	32
b:	.word	15
c:	.word	12

	.text
main:
	lw	$t1, a
	lw	$t2, b
	sw	$t2, a
	bne	$t2, 16, else
	sw	$t1, b
	
else:
	lw	$t3, c
	sw	$t3, b

exit:
	li	$v0, 10
	syscall
