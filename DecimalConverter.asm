

#Decimal Converter

.text 


main:
#start
	move	 $s0,$a1
	lw	 $s0,($s0)
	la	 $a0, hello_msg # load the addr of hello_msg into $a0.
	li	 $v0, 4 # 4 is the print_string syscall.
	syscall 	# do the syscall.(display welcome)
	
	la $a0, input_numb  #load the addr of input_numb into $a0
	li  $v0, 4  #print syscall
	syscall # display msg Input Number_
	la $a0,($s0)  #store the VALUE of s0 into a0
	li $v0, 4 #syscall to print the value of a0
	syscall #Display Input Number
	lb $t0,($s0) #load byte (Ascii value) into t0
	la $s4,runningsum #sets up address to store running sum in loop
	bne $t0,45,p_ascii #check for "-"
	beq $t0,45,n_ascii #check for "-"
#start from the loop ^^^ is fine
p_ascii:
	
	lb $s3,($s0)
	b p_ascii2
p_ascii2:	#beginning of the loop for Ascii->decimal
	beq   $s3,0,decbin  #stops loop if no more values ($s3=nul)
	mul $s2,$s2,10  #multiply by ten
	sub $t0,$s3,48  #subtract 48 from ascii value to get actual int value
	add $s2,$s2,$t0  #add actual int value to $s2, store in $s2
	addi $s0,$s0,1  #move address by 1
	lb $s3,($s0)
	b p_ascii2

	


decbin:  #decimal to binary

la $a0,output  #print out Output:
li $v0,4
syscall



lw $s6,bit #load in 2^31
lw $t5,zero #load in a 0
binloop:
beq $s6,0,endbinloop  #start loop
and $t5,$s2,$s6  #bitwise and $s4,$s6
beq $t5,0,neq32  #compare if AND logic !=1
bnez $t5,eq32    #compare if AND logic=1
neq32:
li $a0,0x30 # print 0
li $v0,11
syscall # actually perform the syscall
srl $s6,$s6,1
j binloop
eq32:
li $a0,0x31 # print 1
li $v0,11
srl $s6,$s6,1
syscall # print 1
j binloop

n_ascii:
	addi $s0,$s0,1  #skip the "-" character
	lb $s3,($s0)
	b n_ascii2
n_ascii2:	#beginning of the loop for Ascii->decimal
	beq   $s3,0,decbin2  #stops loop if no more values ($s3=nul)
	mul $s2,$s2,10  #multiply by ten
	sub $t0,$s3,48  #subtract 48 from ascii value to get actual int value
	add $s2,$s2,$t0  #add actual int value to $s2, store in $s2
	addi $s0,$s0,1
	lb $s3,($s0)
	b n_ascii2

	


decbin2:  #decimal to binary
#2SC complement conversion- Original Number-2(original number)
div $t3,$s2,2  #divide by 2 to fix the issue of the number not fitting
rem $t4,$s2,2  #store the remainder
add $t5,$t4,$t3  #add the remainder to the quotient and store into a different register
sub $s2,$s2,$t3  #subtract quotient 
sub $s2,$s2,$t5  #subtract quotient+remainder
sub $s2,$s2,$t3  #repeat process to get 2'sc
sub $s2,$s2,$t5  #subtract to get 2's Complement


la $a0,output  #print output
li $v0,4
syscall



lw $s6,bit  #load in bit label
lw $t5,zero  #load in 0 label
binloop2:
beq $s6,0,endbinloop2  #start loop
and $t5,$s2,$s6  #bitwise and $s4,$s6
beq $t5,0,neq32_2  #compare if AND logic !=1
bnez $t5,eq32_2    #compare if AND logic=1
neq32_2:
li $a0,0x30 # print 0  
li $v0,11
syscall # actually perform the syscall
srl $s6,$s6,1
j binloop2
eq32_2:
li $a0,0x31 # print 1
li $v0,11
srl $s6,$s6,1
syscall # print 1
j binloop2
endbinloop2:
li	 $v0, 10 # 10 is the exit syscall.
	syscall 	# do the syscall.
	

endbinloop:
	li	 $v0, 10 #exit
	syscall 	
# Data for the program:
.data
hello_msg: .asciiz 	"Welcome to Convertatron 5000\n"
# end hello.asm
input_numb: .asciiz   "Input Number:" #print input number
runningsum: .word 0
zero: .word 0
output:  .asciiz "\nOutput:"
output2: .asciiz "\nOutput:"
bit:  .word 2147483648
