	.data
prompt:	.asciiz	"Enter some text:"
words:	.asciiz	" words "
chars:	.asciiz	" characters\n"
goodbye:.asciiz "Goodbye"
space:	.asciiz	" "
input:	.space 100
blank:	.asciiz	""
	
	.text
main:
	#Prompt for input
	la	$a0, prompt
	la	$a1, input
	li	$a2, 100
	li	$v0, 54
	syscall
	
	#Exit if blank
	bltz	$a1, exit
	
	#Output input to user
	la	$a0, input
	li	$v0, 4
	syscall
	
	#Call count function
	la	$a1, input
	jal	count
	
	#Repeat Until input is blank
	j	main	

exit:
	#Say Goodbye
	la	$a0, goodbye
	la	$a1, blank
	li	$v0, 59
	syscall
	#Exit Program
	li	$v0, 10
	syscall
	
count:
	#Make space in stack, counter for words
	addi	$sp, $sp, -4
	sw	$s1, 0($sp)

	li	$t0, 0		#Location counter
	lb	$t2, space	#Space comparator
	
	#Loop to count
	repeat:
		add	$t1, $a1, $t0	#Points to charAt(i)
		lbu	$t3, ($t1)	#Loads char
		#if charAt(i) = " "
		bne	$t3, $t2, spaceCompare
			addi	$s1, $s1, 1 #increment word counter
		spaceCompare:
		beqz	$t3, completed	#Exit if no more characters
		addi	$t0, $t0, 1	#Location counter increment - i++
		j	repeat
	completed:
	
	#Print word count to Screen
	addi	$a0, $s1, 1
	li	$v0, 1
	syscall
	la	$a0, words
	li	$v0, 4
	syscall
	
	#Print char count to Screen
	addi	$a0, $t0, 0
	li	$v0, 1
	syscall
	la	$a0, chars
	li	$v0, 4
	syscall
	
	#Clear used stack space
	lw	$s1, 0($sp)
	addi	$sp, $sp, 4
	
	#Return to main
	jr	$ra
