##########Tic Tac Toe Game##########
####################################
#Requires Bitmap Display
#Unit Width: 8
#Unit Height: 8
#Display Width: 512
#Display Height: 512
#Base Address: 0x10008000 ($gp)
####################################
#Please Use Numpad for Corresponding Entries
####################################

	.data
screenwh:	.word		64
backcolor:	.word		0xFFFFFFFF
linecolor:	.word		0x00000000
p1color:	.word		0x00FF0000
p2color:	.word		0x0000FF00

positions:	.word		0, 11012, 11096, 11180, 5636, 5720, 5804, 260, 344, 428
used:		.word		0, 0, 0, 0, 0, 0, 0, 0, 0, 0

blank:		.asciiz		""
intro:		.asciiz		"Lets Play Tic-Tac-Toe"
inputdisp:	.asciiz		"7|8|9\n-------    Please Enter\n4|5|6    A Corresponding Number\n-------\n1|2|3"
noplaymsg:	.asciiz		"Alright, Goodbye."
turnmsg:	.asciiz		"Pass the Controls to "
invalidmsg:	.asciiz		"You cannot make that move, Try Again"
replaymsg:	.asciiz		"Would you like to play again?"
p1prompt:	.asciiz		"Please Enter Player 1's Name:"
p1name:		.space		50
p2prompt:	.asciiz		"Please Enter Player 2's Name:"
p2name:		.space		50
nowinner:	.asciiz		"No one Won that round"
p1winner:	.asciiz		"Cross has Won the round"
p2winner:	.asciiz		"Circle has Won the round"
p1score:	.word		0
p2score:	.word		0
gamepoint:	.asciiz		" has WON the game!"
gamenone:	.asciiz		"Its a TIE game!"

.macro	backfill
	#Fill Display With White
	lw	$a0, screenwh
	lw	$a1, backcolor
	sll	$a2, $a0, 8
	add	$a2, $a2, $gp
	add	$a0, $gp, $zero
	fillwhite:
	beq	$a0, $a2, donefill
	sw	$a1, ($a0)
	addi	$a0, $a0, 4
	j	fillwhite
	donefill:
.end_macro

.macro	cross
	add	$a0, $s1, $zero
	lw	$a1, p1color
	li	$a2, 20
	mul	$a2, $a2, 256
	add	$a2, $a2, $a0
	xloop1:
	bge	$a0, $a2, xdone1
	sw	$a1, ($a0)
	addi	$a0, $a0, 260
	j	xloop1
	xdone1:
	add	$a0, $s1, 76
	addi	$a2, $a2, -252
	xloop2:
	bge	$a0, $a2, xdone2
	sw	$a1, ($a0)
	addi	$a0, $a0, 252
	j	xloop2
	xdone2:
.end_macro

.macro	circle
	add	$a0, $s1, $zero
	addi	$a0, $a0, 40
	lw	$a1, p2color
	li	$a2, 10
	mul	$a2, $a2, 256
	add	$a2, $a2, $a0
	oloop1:
	bge	$a0, $a2, odone1
	sw	$a1, ($a0)
	addi	$a0, $a0, 260
	j	oloop1
	odone1:
	addi	$a0, $a0, -80
	addi	$a2, $a2, 2560
	oloop2:
	bge	$a0, $a2, odone2
	sw	$a1, ($a0)
	addi	$a0, $a0, 260
	j	oloop2
	odone2:
	add	$a0, $s1, 36
	li	$a2, 9
	mul	$a2, $a2, 256
	add	$a2, $a2, $a0
	oloop3:
	bge	$a0, $a2, odone3
	sw	$a1, ($a0)
	addi	$a0, $a0, 252
	j	oloop3
	odone3:
	addi	$a0, $a0, 80
	addi	$a2, $a2, 2566
	oloop4:
	bge	$a0, $a2, odone4
	sw	$a1, ($a0)
	addi	$a0, $a0, 252
	j	oloop4
	odone4:
.end_macro

	.text
main:
	#Start Message
	la	$a0, intro
	li	$v0, 50
	syscall
	
	#Deal with User's Reply to Start Message
	bnez	$a0, exit
	
	#Prompt Player 1's Name
	promptp1:
	la	$a0, p1prompt
	la	$a1, p1name
	li	$a2, 50
	li	$v0, 54
	syscall
	
	#Prompt Player 2's Name
	promptp2:
	la	$a0, p2prompt
	la	$a1, p2name
	li	$a2, 50
	li	$v0, 54
	syscall
resetpoint:	
	#Reset Used Array
	li	$t0, 0
	sw	$t0, used+4
	sw	$t0, used+8
	sw	$t0, used+12
	sw	$t0, used+16
	sw	$t0, used+20
	sw	$t0, used+24
	sw	$t0, used+28
	sw	$t0, used+32
	sw	$t0, used+36
	
	backfill
	
	#Draw Edge Lines
	lw	$a0, screenwh
	lw	$a1, linecolor
	sll	$a2, $a0, 2
	add	$a2, $a2, $gp
	add	$a0, $gp, $zero
	drawedge1:
	beq	$a0, $a2, doneedge1
	sw	$a1, ($a0)
	addi	$a0, $a0, 4
	j	drawedge1
	doneedge1:
	lw	$a2, screenwh
	sll	$a2, $a2, 8
	add	$a2, $a2, $gp
	addi	$a2, $a2, -256
	drawedge2:
	bge	$a0, $a2, doneedge2
	sw	$a1, ($a0)
	addi	$a0, $a0, 84
	sw	$a1, ($a0)
	addi	$a0, $a0, 84
	sw	$a1, ($a0)
	addi	$a0, $a0, 84
	sw	$a1, ($a0)
	addi	$a0, $a0, 4
	j	drawedge2
	doneedge2:
	addi	$a2, $a2, 256
	drawedge3:
	beq	$a0, $a2, doneedge3
	sw	$a1, ($a0)
	addi	$a0, $a0, 4
	j	drawedge3
	doneedge3:
	add	$a2, $gp, $zero
	li	$a3, 256
	mul	$a3, $a3, 21
	add	$a0, $a2, $a3
	addi	$a2, $a0, 256
	drawedge4:
	beq	$a0, $a2, doneedge4
	sw	$a1, ($a0)
	addi	$a0, $a0, 4
	j	drawedge4
	doneedge4:
	add	$a2, $gp, $zero
	li	$a3, 256
	mul	$a3, $a3, 42
	add	$a0, $a2, $a3
	addi	$a2, $a0, 256
	drawedge5:
	beq	$a0, $a2, doneedge5
	sw	$a1, ($a0)
	addi	$a0, $a0, 4
	j	drawedge5
	doneedge5:
	
	#Loop 9 Times for Input and Display
	li	$t0, 9	#Used to Alternate Player
playgame:
	beqz	$t0, donegame
	rem	$a0, $t0, 2
	jal	makemove
	addi	$t0, $t0, -1
	j	playgame
	donegame:
	
	#Completed game with no winner
	la	$a0, nowinner
	la	$a1, blank
	
	#Display Winner
displaywinner:
	li	$v0, 59
	syscall
	
	#Prompt for Replay
replay:
	la	$a0, replaymsg
	li	$v0, 50
	syscall
	
	beqz	$a0, resetpoint
	
	#Display final score
	backfill
	lw	$a1, p1score
	lw	$a2, p2score
	lw	$s1, positions+20
	add	$s1, $s1, $gp
	p2won:
	bge	$a1, $a2, p1won
	circle
	la	$a0, p2name
	la	$a1, gamepoint
	j	reallytheend
	p1won:
	beq	$a1, $a2, tied
	cross
	la	$a0, p1name
	la	$a1, gamepoint
	j	reallytheend
	tied:
	la	$a0, gamenone
	la	$a1, blank
	reallytheend:
	li	$v0, 59
	syscall
	
	j	exit

makemove:
	beqz	$a0, p1turn
	la	$a1, p2name
	j	playerturn
	p1turn:
	la	$a1, p1name
	playerturn:
	move	$t9, $a0
	la	$a0, turnmsg
	li	$v0, 59
	syscall
	j	choice
	
	badmove:
	la	$a0, invalidmsg
	la	$a1, blank
	li	$v0, 59
	syscall
	
	choice:
	la	$a0, inputdisp
	li	$v0, 51
	syscall
	
	bnez	$a1, badmove		#Invalid Input
	
	sle	$t1, $a0, $zero		#Number <= 0
	bnez	$t1, badmove
	
	li	$t2, 9
	sgt	$t1, $a0, $t2		#Number > 9
	bnez	$t1, badmove
	
	mul	$a0, $a0, 4
	lw	$t2, used($a0)
	bnez	$t2, badmove		#Number is taken
	
	#Draw Move
	lw	$s1, positions($a0)
	add	$s1, $s1, $gp
	
	beqz	$t9, drawcross
	li	$t1, 1
	sw	$t1, used($a0)		#Add to Used Array
	circle
	j	donedraw
	drawcross:
	li	$t1, 2
	sw	$t1, used($a0)		#Add to Used Array
	cross
	donedraw:
	
	#Check for Winner
		#Case of 111-000-000
	lw	$t2, used+4
	seq	$t3, $t1, $t2
	lw	$t2, used+8
	seq	$t4, $t1, $t2
	lw	$t2, used+12
	seq	$t5, $t1, $t2
	and	$t3, $t3, $t4
	and	$t3, $t3, $t5
	beq	$t3, 1, chickendinner
	
		#Case of 000-111-000
	lw	$t2, used+16
	seq	$t3, $t1, $t2
	lw	$t2, used+20
	seq	$t4, $t1, $t2
	lw	$t2, used+24
	seq	$t5, $t1, $t2
	and	$t3, $t3, $t4
	and	$t3, $t3, $t5
	beq	$t3, 1, chickendinner
		#Case of 000-000-111
	lw	$t2, used+28
	seq	$t3, $t1, $t2
	lw	$t2, used+32
	seq	$t4, $t1, $t2
	lw	$t2, used+36
	seq	$t5, $t1, $t2
	and	$t3, $t3, $t4
	and	$t3, $t3, $t5
	beq	$t3, 1, chickendinner
		#Case of 100-010-001
	lw	$t2, used+4
	seq	$t3, $t1, $t2
	lw	$t2, used+20
	seq	$t4, $t1, $t2
	lw	$t2, used+36
	seq	$t5, $t1, $t2
	and	$t3, $t3, $t4
	and	$t3, $t3, $t5
	beq	$t3, 1, chickendinner
		#Case of 100-100-100
	lw	$t2, used+4
	seq	$t3, $t1, $t2
	lw	$t2, used+16
	seq	$t4, $t1, $t2
	lw	$t2, used+28
	seq	$t5, $t1, $t2
	and	$t3, $t3, $t4
	and	$t3, $t3, $t5
	beq	$t3, 1, chickendinner
		#Case of 010-010-010
	lw	$t2, used+8
	seq	$t3, $t1, $t2
	lw	$t2, used+20
	seq	$t4, $t1, $t2
	lw	$t2, used+32
	seq	$t5, $t1, $t2
	and	$t3, $t3, $t4
	and	$t3, $t3, $t5
	beq	$t3, 1, chickendinner
		#Case of 001-001-001
	lw	$t2, used+12
	seq	$t3, $t1, $t2
	lw	$t2, used+24
	seq	$t4, $t1, $t2
	lw	$t2, used+36
	seq	$t5, $t1, $t2
	and	$t3, $t3, $t4
	and	$t3, $t3, $t5
	beq	$t3, 1, chickendinner
		#Case of 001-010-100
	lw	$t2, used+12
	seq	$t3, $t1, $t2
	lw	$t2, used+20
	seq	$t4, $t1, $t2
	lw	$t2, used+28
	seq	$t5, $t1, $t2
	and	$t3, $t3, $t4
	and	$t3, $t3, $t5
	beq	$t3, 1, chickendinner
	
	jr	$ra
	
	chickendinner:
	beqz	$t9, crosswon
	lw	$t3, p2score
	add	$t3, $t3, 1
	sw	$t3, p2score
	la	$a0, p2name
	la	$a1, p2winner
	j	endgame
	crosswon:
	lw	$t3, p1score
	add	$t3, $t3, 1
	sw	$t3, p1score
	la	$a0, p1name
	la	$a1, p1winner
	endgame:
	j	displaywinner

exit:
	la	$a0, noplaymsg
	la	$a1, blank
	li	$v0, 59
	syscall
	
	li	$v0, 10
	syscall
