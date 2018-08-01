		.data
height:		.double	0
weight:		.double	0
bmi:		.double	0.0
name:		.space	100
namePrompt:	.asciiz	"What is your name? "
heightPrompt:	.asciiz	"Please enter your height in inches: "
weightPrompt:	.asciiz	"Now enter your weight in pounds (Round to a whole number): "
bmiOut1:	.asciiz	"Your bmi is: "
under:		.asciiz	"\nThis is considered underweight.\n"
normal:		.asciiz	"\nThis is a normal weight.\n"
over:		.asciiz	"\nThis is considered overweight.\n"
obese:		.asciiz	"\nThis is considered obese.\n"
sevenonethree:	.double	703
eighteen:	.double	18.5
twentyfive:	.double	25
thirty:		.double	30

		.text
main:
		#Prompt Name
		la	$a0, namePrompt
		li	$v0, 4
		syscall
		
		#Take Input for Name
		la	$a0, name
		li	$a1, 100
		li	$v0, 8
		syscall
		
		#Prompt Height
		la	$a0, heightPrompt
		li	$v0, 4
		syscall
		
		#Take Input for Height
		li	$v0, 7
		syscall
		s.d	$f0, height
		
		#Prompt Weight
		la	$a0, weightPrompt
		li	$v0, 4
		syscall
		
		#Take Input for Weight
		li	$v0, 7
		syscall
		s.d	$f0, weight
		
		#Calculate BMI
		l.d	$f0, height
		mul.d	$f0, $f0, $f0
		
		l.d	$f2, weight
		l.d	$f10, sevenonethree
		mul.d	$f2, $f2, $f10
		
		div.d	$f12, $f2, $f0
		
		#Output BMI
		la	$a0, name
		li	$v0, 4
		syscall
		
		la	$a0, bmiOut1
		li	$v0, 4
		syscall
		
		li	$v0, 3
		syscall
		
		#Conditional Output
		l.d	$f10, eighteen
		c.lt.d	$f12, $f10	#BMI < 18.5
		bc1f	twofive
		la	$a0, under
		j	output
twofive:
		l.d	$f10, twentyfive
		c.lt.d	$f12, $f10	#BMI < 25
		bc1f	threezero
		la	$a0, normal
		j	output
threezero:
		l.d	$f10, thirty
		c.lt.d	$f12, $f10	#BMI < 30
		bc1f	else
		la	$a0, over
		j	output
else:
		la	$a0, obese
output:
		li	$v0, 4
		syscall
		
exit:
		li	$v0, 10
		syscall