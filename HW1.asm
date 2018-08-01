	.data
a:	.word	1
b:	.word	2
c:	.word	3
out1:	.word	0
out2:	.word	0
out3:	.word	0
name:	.asciiz	""
mesName:.asciiz	"What is your name? "
mesInt:	.asciiz	"Please enter an integer between 1-100: "
mesRes:	.asciiz	"your answers are: "

	.text
main:
	#Prompt for Name
	la	$a0, mesName
	li	$v0, 4		#4 is OPcode for output
	syscall
	
	#Store Name Input
	la	$a0, name
	la	$a1, name
	li	$v0, 8		#8 is OPcode for ascii input
	syscall
	
	#Prompt for Num1
	la	$a0, mesInt
	li	$v0, 4
	syscall
	#Store Num1
	li	$v0, 5		#5 is OPcode for word input
	syscall
	sw	$v0, a
	
	#Prompt for Num2
	la	$a0, mesInt
	li	$v0, 4
	syscall
	#Store Num2
	li	$v0, 5
	syscall
	sw	$v0, b
	
	#Prompt for Num3
	la	$a0, mesInt
	li	$v0, 4
	syscall
	#Store Num3
	li	$v0, 5
	syscall
	sw	$v0, c
	
	#Load Variables
	lw	$s1, a
	lw	$s2, b
	lw	$s3, c
	
	#Calculate Values
	add	$t1, $s1, $s2	#t1 = a + b
	add	$t1, $t1, $s3	#t1 = t1 + c
	sw	$t1, out1
	
	add	$t2, $s3, $s2	#t2 = c + b
	sub	$t2, $t2, $s1	#t2 = t2 - a
	sw	$t2, out2
	
	addi	$t1, $s1, 2	#t1 = a + 2
	subi	$t2, $s2, 5	#t2 = b - 5	
	subi	$t3, $s3, 1	#t3 = c - 1
	add	$t4, $t1, $t2	#t4 = t1 + t2
	sub	$t4, $t4, $t3	#t4 = t4 - t3
	sw	$t4, out3
	
	#Output Name
	la	$a0, name
	li	$v0, 4
	syscall
	
	#Output Numbers
	la	$a0, mesRes	#Message
	syscall
	
	lw	$a0, out1	#Output 1
	li	$v0, 1		#1 is OPcode for number output
	syscall
	
	li	$a0, 32		#32 is ascii value for space, Space
	li	$v0, 11		#11 is OPcode for character output
	syscall
	
	lw	$a0, out2	#Output 2
	li	$v0, 1
	syscall
	
	li	$a0, 32		#Space
	li	$v0, 11
	syscall
	
	lw	$a0, out3	#Output 3
	li	$v0, 1
	syscall

exit:
	li	$v0, 10
	syscall
	
#What is your name? Ishaan
#Please enter an integer between 1-100: 23
#Please enter an integer between 1-100: 22
#Please enter an integer between 1-100: 11
#Ishaan
#your answers are: 56 10 32
#-- program is finished running --

#What is your name? Somebody
#Please enter an integer between 1-100: 86
#Please enter an integer between 1-100: 32
#Please enter an integer between 1-100: 15
#Somebody
#your answers are: 133 -39 101
#-- program is finished running --
