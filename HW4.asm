	.data
filename:	.asciiz		"fox.txt"
filetext:	.asciiz		"The quick brown fox jumped over the lazy river."
filetext_end:	.space		1
msgok:		.asciiz		"Data is OK"
msgbad:		.asciiz		"Data has been corrupted"
readbuffer:	.space		100
readlength:	.word		0
paritybuffer:	.space		100
newline:	.asciiz		"0"
space:		.asciiz		" "
seperator:	.asciiz		"|"
		
	.text
main:
	#Open File
	la	$a0, filename
	li	$a1, 1
	li	$a2, 0
	li	$v0, 13
	syscall
	
	#Write to File
	move	$a0, $v0
	la	$a1, filetext
	la	$a2, filetext_end
	subu	$a2, $a2, $a1
	li	$v0, 15
	syscall
	
	#Close File
	li	$v0, 16
	syscall
	
	#Reopen File
	la	$a0, filename
	li	$a1, 0
	li	$a2, 0
	li	$v0, 13
	syscall
	
	#Read into Buffer
	move	$a0, $v0
	la	$a1, readbuffer
	li	$a2, 100
	li	$v0, 14
	syscall
	sw	$v0, readlength
	
	#ReClose File
	li	$v0, 16
	syscall
	
	#Iterate through Buffer
	li	$t0, 0			#$t0 = i = 0
	lw	$t1, readlength		#$t1 = buffer.length
	sll	$t1, $t1, 2
	jal	setParity
	
	#Check if data is corrupted
	li	$t0, 0			#$t0 = i = 0
	lw	$t1, readlength		#$t1 = buffer.length
	sll	$t1, $t1, 2
	jal	compareParity
	
	beqz	$v0, bad		#if(compareParity() == true)
		la	$a0, msgok
		j	exit
	bad:
		la	$a0, msgbad
	
exit:
	li	$v0, 4
	syscall

	li	$v0, 10
	syscall
	
setParity:
	#Loop through each character in buffer
	lb	$a0, readbuffer($t0)	#$a0 = buffer.charAt(i)
	
	move	$s0, $ra
	jal	parityBit
	move	$ra, $s0
	sb	$v1, paritybuffer($t0)
	
	addi	$t0, $t0, 1		#i++
	bne	$t0, $t1, setParity	#do while(i != buffer.length)
	jr	$ra

compareParity:
	lb	$a0, readbuffer($t0)	#$a0 = readbuffer.charAt(i)
	lb	$a1, paritybuffer($t0)	#$a1 = paritybuffer.charAt(i)
	
	move	$s0, $ra
	jal	parityBit
	move	$ra, $s0
	
	bne	$v1, $a1, cPExit		#if(charAt(i) != parityBit(i))return false;
	
	addi	$t0, $t0, 1		#i++
	bne	$t0, $t1, compareParity
	addi	$v0, $zero, 0
	jr	$ra
	
cPExit:
	addi	$v0, $zero, 1
	jr	$ra
	
parityBit:
	lb	$t9, newline
	beq	$a0, $t9, pBExit	#if(buffer.charAt(i) == 0) return
	
	add	$t3, $a0, $zero
	bit0:
	addi	$t5, $zero, 0		#$t5 = 0
	rem	$t4, $t3, 2		#$t4 = $t3 % 2
	beqz	$t4, bit1		#if(remainder == 0)
		addi	$t5, $t5, 1	#$t5++
	bit1:
	srl	$t3, $t3, 1
	rem	$t4, $t3, 2
	beqz	$t4, bit2
		addi	$t5, $t5, 1
	bit2:
	srl	$t3, $t3, 1
	rem	$t4, $t3, 2
	beqz	$t4, bit3
		addi	$t5, $t5, 1
	bit3:
	srl	$t3, $t3, 1
	rem	$t4, $t3, 2
	beqz	$t4, bit4
		addi	$t5, $t5, 1
	bit4:
	srl	$t3, $t3, 1
	rem	$t4, $t3, 2
	beqz	$t4, bit5
		addi	$t5, $t5, 1
	bit5:
	srl	$t3, $t3, 1
	rem	$t4, $t3, 2
	beqz	$t4, bit6
		addi	$t5, $t5, 1
	bit6:
	srl	$t3, $t3, 1
	rem	$t4, $t3, 2
	beqz	$t4, bit7
		addi	$t5, $t5, 1
	bit7:
	rem	$t4, $t5, 2
	beqz	$t4, zero		#if($t5 % 2 == 0)
		ori	$a0, $a0, 0x0080	#parity = 1
	zero:
	move	$v1, $a0		#return $v1
	
pBExit:	
	jr	$ra
