	.data
prompt:	.asciiz	"Please enter the month 1-12, enter 0 to quit: "
error:	.asciiz	"Month must be between 1 and 12"
output:	.asciiz	"Number of days in month "
is:	.asciiz " is: "
newLine:.asciiz	"\n"
array:	.word	31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31

	.text
main:
	#Prompt User
	la	$a0, prompt
	li,	$v0, 4
	syscall

	#Get Input
	li,	$v0, 5
	syscall
	move	$t1, $v0
	
	#Check =0
	beqz	$t1, exit
	
	#If Error, Loop
	bgt	$t1, 12, wrong
		
	#Compute Result
	subi	$t4, $t1, 1
	mul	$t4, $t4, 4
	lw	$t2, array($t4)
	
	#Output Result
	la	$a0, output
	li	$v0, 4
	syscall
	
	addi	$a0, $t1, 0
	li	$v0, 1
	syscall
	
	la	$a0, is
	li	$v0, 4
	syscall
	
	addi	$a0, $t2, 0
	li	$v0, 1
	syscall
	
	la	$a0, newLine
	li	$v0, 4
	syscall
	
	#Loop
	j	main
	
exit:
	li	$v0, 10
	syscall
	
wrong:
	la	$a0, error
	li	$v0, 4
	syscall
	j	main