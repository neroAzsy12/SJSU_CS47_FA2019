.include "./cs47_proj_macro.asm"
.text
.globl au_logical
# TBD: Complete your project procedures
# Needed skeleton is given
#####################################################################
# Implement au_logical
# Argument:
# 	$a0: First number
#	$a1: Second number
#	$a2: operation code ('+':add, '-':sub, '*':mul, '/':div)
# Return:
#	$v0: ($a0+$a1) | ($a0-$a1) | ($a0*$a1):LO | ($a0 / $a1)
# 	$v1: ($a0 * $a1):HI | ($a0 % $a1)
# Notes:
#####################################################################
au_logical:
	addi $sp, $sp, -24
	sw $fp, 24($sp)
	sw $ra, 20($sp)
	sw $a2, 16($sp)
	sw $a1, 12($sp)
	sw $a0, 8($sp)
	addi $fp, $sp, 24
	
	li $t0, 42
	beq $t0, $a2, logical_multiply
	
	li $t0, 43
	beq $t0, $a2, logical_add
	
	li $t0, 45
	beq $t0, $a2, logical_subtract
	
	li $t0, 47
	beq $t0, $a2, div_logic_signed
	
	j au_logical_end		
# Addition and Subtraction -----------------------------------------------------------
#logical_add_sub:
	#addi $sp, $sp -32
	#sw $fp, 32($sp)
	#sw $ra, 28($sp)
	#sw $a2, 24($sp)
	#sw $a1, 20($sp)
	#sw $a0, 16($sp)
	#sw $s1, 12($sp)
	#sw $s0, 8($sp)
	#addi $fp, $sp, 32
	
	#add $s0, $zero, $zero  # the index tracker
	#add $s1, $zero, $zero  # this will hold the final answer for the operation
	#add $t0, $zero, $zero  # bit holder for a0
	#add $t1, $zero, $zero  # bit holder for a1
	#add $t2, $zero, $zero  # $ab
	#add $t3, $zero, $zero  # $y
	#add $t4, $zero, $zero  # Carry out
	#add $t5, $zero, $zero  # Carry in
	
	#li $t9, 45		# $t9 = '-'
	#bne $t9, $a2, logical_add_sub_operation # if its subtraction then get 2's complement of $a1
	#twos_complement($a1)
	#jal logical_add_sub_operation
#-----------------------------------------------	
#logical_add:
#	addi $sp, $sp -32
#	sw $fp, 32($sp)
#	sw $ra, 28($sp)
#	sw $a2, 24($sp)
#	sw $a1, 20($sp)
#	sw $a0, 16($sp)
#	sw $s1, 12($sp)
#	sw $s0, 8($sp)
#	addi $fp, $sp, 32
#	
#	add $s0, $zero, $zero  # the index tracker
#	add $s1, $zero, $zero  # this will hold the final answer for the operation
#	add $t0, $zero, $zero  # bit holder for a0
#	add $t1, $zero, $zero  # bit holder for a1
#	add $t2, $zero, $zero  # $ab
#	add $t3, $zero, $zero  # $y
#	add $t4, $zero, $zero  # Carry out
#	add $t5, $zero, $zero  # Carry in
#	
#	add $a2, $zero, $zero
#	extract_nth_bit($t5, $a2, $zero)
#	jal logical_add_sub_operation
#	
#ogical_subtract:
#	addi $sp, $sp -32
#	sw $fp, 32($sp)
#	sw $ra, 28($sp)
#	sw $a2, 24($sp)
#	sw $a1, 20($sp)
#	sw $a0, 16($sp)
#	sw $s1, 12($sp)
#	sw $s0, 8($sp)
#	addi $fp, $sp, 32
#	
#	add $s0, $zero, $zero  # the index tracker
#	add $s1, $zero, $zero  # this will hold the final answer for the operation
#	add $t0, $zero, $zero  # bit holder for a0
#	add $t1, $zero, $zero  # bit holder for a1
#	add $t2, $zero, $zero  # $ab
#	add $t3, $zero, $zero  # $y
#	add $t4, $zero, $zero  # Carry out
#	add $t5, $zero, $zero  # Carry in
#	
#	#t4
#	add $a2, $zero, $zero
#	nor $a2, $a2, $zero
#	extract_nth_bit($t5, $a2, $zero)
#	twos_complement($a1)
#	jal logical_add_sub_operation	
#
#logical_add_sub_operation:
#	extract_nth_bit($t0, $a0, $s0) # $t0 = 1 or 0 from a0[s0]
#	extract_nth_bit($t1, $a1, $s0) # $t1 = 1 or 0 from a1[s0]
#	
#	full_adder($t0, $t1, $t2, $t3, $t4, $t5) # $t3 = $y from the full adder, 
#	
#	insert_to_nth_bit($s1, $s0, $t3, $t5)
#	
#	move $t5, $t4			    # set carry in to carry out
#	addi $s0, $s0, 0x1		    # $s0 += 1, increase the index by 1
#	beq $s0, 0x20, logical_add_sub_return # if index == 32, go to return
#	j logical_add_sub_operation	    # else continue the loop
#	
#logical_add_sub_return: #s1
#	add $v0, $s1, $zero			    # $v0 will have the result from $s4
#	add $v1, $t4, $zero			    # modified for the multiplication part
#	j logical_add_sub_end
#	
#logical_add_sub_end:
#	lw $fp, 32($sp)
#	lw $ra, 28($sp)
#	lw $a2, 24($sp)
#	lw $a1, 20($sp)
#	lw $a0, 16($sp)
#	lw $s1, 12($sp)
#	lw $s0, 8($sp)
#	addi $sp, $sp, 32
#	jr $ra


logical_add:
	addi $sp, $sp, -24
	sw $fp, 24($sp)
	sw $ra, 20($sp)
	sw $a2, 16($sp)
	sw $a1, 12($sp)
	sw $a0, 8($sp)
	addi $fp, $sp, 24
	
	add $a2, $zero, $zero
	j logical_add_sub
	
logical_subtract:
	addi $sp, $sp, -24
	sw $fp, 24($sp)
	sw $ra, 20($sp)
	sw $a2, 16($sp)
	sw $a1, 12($sp)
	sw $a0, 8($sp)
	addi $fp, $sp, 24
	
	add $a2, $zero, $zero
	#twos_complement($a2)
	#twos_complement($a1)
	nor $a2, $a2, $zero
	nor $a1, $a1, $zero
	j logical_add_sub

# $t0 = index
# $t1 = $a0[i]
# $t2 = $a1[i]
# $t3 = C
# $t9 = result
logical_add_sub:
	add $t0, $zero, $zero
	add $v0, $zero, $zero
	
	addi $t7, $zero, 0x1
	extract_nth_bit($t3, $a2, $zero)

add_sub:
	extract_nth_bit($t1, $a0, $t0)
	extract_nth_bit($t2, $a1, $t0)
	
	add $t9, $zero, $zero
	add $t9, $t1, $t2
	add $t9, $t9, $t3
	extract_nth_bit($t4, $t9, $zero) # $t5 = Y
	extract_nth_bit($t3, $t9, $t7)
	
	insert_to_nth_bit($v0,$t0,$t4,$t6)
	addi $t0, $t0, 0x1
	
	blt $t0, 0x20, add_sub
	
	add $v1, $t3, $zero
	lw $fp, 24($sp)
	lw $ra, 20 ($sp)
	lw $a2, 16($sp)
	lw $a1, 12($sp)
	lw $a0, 8($sp)
	addi $sp, $sp, 24
	jr $ra
		
		
# Multiplication--------------------------------------------------------------------
twos_complement:	   # $a0 is the only argument needed
	addi $sp, $sp, -16
	sw $fp, 16($sp)
	sw $ra, 12($sp)
	sw $a0, 8($sp)
	addi $fp, $sp, 16
	
	#twos_complement($a0)
	not $a0, $a0	   # bit inversion of $a0
	#addi $a1, $zero, 0x1
	addi $v0, $a0, 0x1
	#jal logical_add    # use the logical_add created to add ~$a0 with $a1
	
	lw $fp, 16($sp)
	lw $ra, 12($sp)
	lw $a0, 8($sp)
	addi $sp, $sp, 16
	jr	$ra

twos_complement_if_neg:
	addi $sp, $sp, -16
	sw $fp, 16($sp)
	sw $ra, 12($sp)
	sw $a0, 8($sp)
	addi $fp, $sp, 16
	
	bge $a0, $zero, if_neg_end
	jal twos_complement # $v0 has the result
	
if_neg_end: # added this to work
	lw $fp, 16($sp)
	lw $ra, 12($sp)
	lw $a0, 8($sp)
	addi $sp, $sp, 16
	jr	$ra

twos_complement_64bit:
	addi $sp, $sp, -20
	sw $fp, 20($sp)
	sw $ra, 16($sp)
	sw $a1, 12($sp)
	sw $a0, 8($sp)
	addi $fp, $sp, 20
	
	#twos_complement($a0)	# inverts $a0 
	#twos_complement($a1)	# inverts $a1
	
	#not $a0, $a0
	#not $a1, $a1
	not $a0, $a0
	not $a1, $a1
	
	add $a2, $a1, $zero
	addi $a1, $zero, 0x1
	
	#jal logical_add_sub_operation
	jal logical_add
	
	add $a3, $zero, $v0
	add $a0, $zero, $v1
	add $a1, $a2, $zero
	
	#add $a1, $a2, $zero	# $a1 should have its original value restored
	#add $a2, $v0, $zero
	#add $a0, $v1, $zero
	
	#jal logical_add_sub_operation
	jal logical_add
	add $v1, $zero, $v0
	add $v0, $zero, $a3
	
	lw $fp, 20($sp)
	lw $ra, 16($sp)
	lw $a1, 12($sp)
	lw $a0, 8($sp)
	addi $sp, $sp, 20
	jr $ra
	
bit_replicator: # argument is $a0
	addi $sp, $sp, -20
	sw $fp, 20($sp)
	sw $ra, 16($sp)
	sw $s0, 12($sp)
	sw $a0, 8($sp)
	addi $fp, $sp, 20
	
	add $v0, $zero, $zero
	beq $a0, $zero, bit_replicator_end # if $a0 = 0, $v0 is 0x00000000
	#neg $v0, $v0		     # else $v0 = 0xFFFFFFFF
	nor $v0, $v0, $zero
	
bit_replicator_end:
	lw $fp, 20($sp)
	lw $ra, 16($sp)
	lw $s0, 12($sp)
	lw $a0, 8($sp)
	addi $sp, $sp, 20
	jr $ra

# I = $t0	index tracker for the loop
# $t1 = 31	used for insert_to_nth_bit for position
# $t2 = M	Multiplicand, a0
# $t3 = L	Miltiplier, a1
# $t4 = X
# $t5 = H
# $t8 = temp register for insert_to_nth_bit
# $t9 = H[0]
logical_multiplication_unsigned:
	addi $sp, $sp, -20
	sw $fp, 20($sp)
	sw $ra, 16($sp)
	sw $a1, 12($sp)
	sw $a0, 8($sp)
	addi $fp, $sp, 20

	add $t0, $zero, $zero	# index = 0
	addi $t1, $zero, 0x1F	# index flag = 31
	add $t2, $zero, $a0	# $t2 = $a0
	add $t3, $zero, $a1	# $t3 = $a1
	add $t5, $zero, $zero	# H = 0
	
multiplication_loop:
	extract_nth_bit($a0, $t3, $zero) # $a0 = L[0]
	jal bit_replicator		 # replicates L[0] 32 times
	
	and $t4, $t2, $v0		 # X = M and L[0] (32 bits)
	add $t5, $t5, $t4		 # H = H + x
	
	srl $t3, $t3, 0x1			 # Shift L to the right by 1 bit
	
	extract_nth_bit($t9, $t5, $zero) # $t9 = H[0]
	insert_to_nth_bit($t3, $t1, $t9, $t8) # $t3 = L[31] = H[0]
	
	srl $t5, $t5, 0x1  		 # Shift H to the right by 1 bit
	
	addi $t0, $t0, 0x1			 # I ++
	blt $t0, 0x20, multiplication_loop # If Index < 32, repeat
	j multiplication_return		 # If index == 32, end loop

multiplication_return:
	add $v0, $t3, $zero
	add $v1, $t5, $zero
	j mul_unsigned_end

mul_unsigned_end:
	lw $fp, 20($sp)
	lw $ra, 16($sp)
	lw $a1, 12($sp)
	lw $a0, 8($sp)
	addi $sp, $sp, 20
	jr $ra

# $a0 Multiplicand
# $a1 Multiplier
# N1 = $a0
# N2 = $a1
logical_multiply:
	addi $sp, $sp, -24
	sw $fp, 24($sp)
	sw $ra, 20($sp)
	sw $a2, 16($sp)
	sw $a1, 12($sp)
	sw $a0, 8($sp)
	addi $fp, $sp, 24
	#jal mul_signed
# $t6 = xor of $t7 and $t8
# $t7 = a0[31]
# $t8 = a1[31]
# $t9 = 31, needed to extract a0[31] and a1[31]			
#mul_signed:
	add $v0, $a0, $zero
	jal twos_complement_if_neg
	
	add $t0, $v0, $zero	# $t0 = N1
	add $a0, $a1, $zero
	add $v0, $a0, $zero
	
	jal twos_complement_if_neg
	add $a0, $t0, $zero
	add $a1, $v0, $zero
	
	jal logical_multiplication_unsigned
	#----------------------------------------------#
	lw $a1, 12($sp)
	lw $a0, 8($sp)
	
	
	addi $t9, $zero, 31
	extract_nth_bit($t7, $a0, $t9) # $t7 = a0[31]
	extract_nth_bit($t8, $a1, $t9) # $t8 = a1[31]
	xor $t6, $t7, $t8
	
	beq $t6, $zero, mul_signed_end # if $t6 = 0, skip
	
	add $a0, $v0, $zero	       # $a0 = Lo
	add $a1, $v1, $zero            # $a1 = Hi
	jal twos_complement_64bit      # determine two complement form of 64 bit num of Rhi, Rlo

mul_signed_end:
	lw $fp, 24($sp)
	lw $ra, 20($sp)
	lw $a2, 16($sp)
	lw $a1, 12($sp)
	lw $a0, 8($sp)
	addi $sp, $sp, 24
	jr $ra

# --------------------------------------------------------------------
div_logic_unsigned:
	addi $sp, $sp, -56
	sw $fp, 56($sp)
	sw $ra, 52($sp)
	sw $a0, 48($sp)
	sw $a1, 44($sp)
	sw $a2, 40($sp)
	sw $s0, 36($sp)
	sw $s1, 32($sp)
	sw $s2, 28($sp)
	sw $s3, 24($sp)
	sw $s4, 20($sp)
	sw $s5, 16($sp)
	sw $s6, 12($sp)
	sw $s7, 8($sp)
	addi $fp, $sp, 56
	
	add $s0, $zero, $zero #I
	add $s1, $zero, $a0 #Q
	add $s2, $zero, $a1 #D
	add $s3, $zero, $zero
	addi $s6, $zero, 0x1F
	addi $t8, $zero, 0x1
	
div_unsigned_loop:
	sll $s3, $s3, 0x1
	extract_nth_bit($s5, $s1, $s6)
	insert_to_nth_bit($s3, $zero, $s5, $s7)
	sll $s1, $s1, 0x1
	add $a0, $zero, $s3
	add $a1, $zero, $s2
	
	jal logical_subtract
	
	add $s4, $zero, $v0
	bltz $s4, s_greater_than_0
	add $s3, $zero, $s4
	insert_to_nth_bit($s1, $zero, $t8, $s7) 
s_greater_than_0:
	addi $s0, $s0, 0x1	
	bgt $s0, $s6, div_unsigned_end
	j div_unsigned_loop		
div_unsigned_end:
	add $v0, $s1, $zero
	add $v1, $s3, $zero
		
	lw $fp, 56($sp)
	lw $ra, 52($sp)
	lw $a0, 48($sp)
	lw $a1, 44($sp)
	lw $a2, 40($sp)
	lw $s0, 36($sp)
	lw $s1, 32($sp)
	lw $s2, 28($sp)
	lw $s3, 24($sp)
	lw $s4, 20($sp)
	lw $s5, 16($sp)
	lw $s6, 12($sp)
	lw $s7, 8($sp)
	addi $sp, $sp, 56
	jr $ra	

div_logic_signed:
	addi $sp, $sp, -24
	sw $fp, 24($sp)
	sw $ra, 20($sp)
	sw $a0, 16($sp)
	sw $a1, 12($sp)
	sw $a2, 8($sp)
	addi $fp, $sp, 24
	
	add $v0, $a0, $zero
	jal twos_complement_if_neg
	add $t1, $v0, $zero #t1 = N1
	add $a0, $a1, $zero
	add $v0, $a0, $zero
	jal twos_complement_if_neg
	add $a1, $v0, $zero
	add $a0, $t1, $zero
	jal div_logic_unsigned
	add $t1, $zero, $v0 #t1 = Q
	add $t2, $zero, $v1 #t2 = R
	addi $t6, $zero, 0x1F
	lw $a0, 16($sp)
	lw $a1, 12($sp)
	extract_nth_bit($t3, $a0, $t6)
	extract_nth_bit($t4, $a1, $t6)
	xor $t5, $t3, $t4
	addi $t8, $zero, 0x1
	bne $t5, $t8, keep_q_as_is
	add $a0, $t1, $zero
	jal twos_complement
	add $t1, $v0, $zero
keep_q_as_is:
	lw $a0, 16($sp)
	extract_nth_bit($t3, $a0, $t6)
	addi $t8, $zero, 0x1
	bne $t3, $t8, keep_r_as_is
	add $a0, $t2, $zero
	jal twos_complement
	add $t2, $v0, $zero
keep_r_as_is:
	add $v0, $t1, $zero
	add $v1, $t2, $zero
	lw $fp, 24($sp)
	lw $ra, 20 ($sp)
	lw $a0, 16($sp)
	lw $a1, 12($sp)
	lw $a2, 8($sp)
	addi $sp, $sp, 24
	jr $ra
# --------------------------------------------------------------------
au_logical_end:
	lw $fp, 24($sp)
	lw $ra, 20($sp)
	lw $a2, 16($sp)
	lw $a1, 12($sp)
	lw $a0, 8($sp)
	addi $sp, $sp, 24
	jr $ra
