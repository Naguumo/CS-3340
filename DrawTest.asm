	.data
screenwh:	.word		64
backcolor:	.word		0xFFFFFFFF
linecolor:	.word		0x00000000
p1color:	.word		0x00FF0000
p2color:	.word		0x0000FF00

positions:	.word		0, 11012, 11096, 11180, 5636, 5720, 5804, 260, 344, 428

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
	
	#Fill Display With Black
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
	
	#addi	$s1, $gp, 260		#Position 7
	#addi	$s1, $gp, 344		#Position 8
	addi	$s1, $gp, 428		#Position 9
	#addi	$s1, $gp, 5636		#Position 4
	#addi	$s1, $gp, 5720		#Position 5
	#addi	$s1, $gp, 5804		#Position 6
	#addi	$s1, $gp, 11012		#Position 1
	#addi	$s1, $gp, 11096		#Position 2
	#addi	$s1, $gp, 11180		#Position 3
	
	#Draw Cross given Position
	cross
	
	#Draw Circle given Position
	li	$t1, 20
	lw	$s1, positions($t1)
	add	$s1, $s1, $gp
	circle
	
	j	exit

exit:
	li	$v0, 10
	syscall
