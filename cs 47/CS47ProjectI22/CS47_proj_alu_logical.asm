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
	addi 	$sp, $sp, -24
	sw	$fp, 24($sp)
	sw	$ra, 20($sp)
	sw	$a2, 16($sp)
	sw	$a1, 12($sp)
	sw	$a0, 8($sp)
	addi	$fp, $sp 24

	li $t0, 42    # ascii value of *
	beq $t0, $a2, mul_signed	# if * go to multiplication 
	
	li $t0, 43    # ascii value of +
	beq $t0, $a2, add_logical	# if + go to addition 
	
	li $t0, 45    # ascii value of -
	beq $t0, $a2, sub_logical	# if - go to subtraction
	
	li $t0, 47    # ascii value of /
	beq $t0, $a2, div_signed	# if / go to division
	
	j end_au_logical
	
end_au_logical:
	lw	$fp, 24($sp)
	lw	$ra, 20($sp)
	lw	$a2, 16($sp)
	lw	$a1, 12($sp)
	lw	$a0, 8($sp)
	add 	$sp, $sp, 24
	jr 	$ra

# Implement add_logical
# Return: $v0 = ($a0 + $a1), $v1: overflow if any 
add_logical:
	addi	$sp, $sp, -24
	sw	$fp, 24($sp)
	sw	$ra, 20($sp)
	sw	$s0, 16($sp)
	sw	$a1, 12($sp)
	sw	$a0, 8($sp)
	addi	$fp, $sp 24
	
	li	$t0, 0		# t0 = 0 hold a2
	li	$t1, 0		# t1 = 0 hold a1
	li	$t2, 0		# $t2 = index 0-31
	li	$t3, 0		# $t3 = carry holder
	li	$t4, 0		# $t4 = bit answer to hold = $s2
	li	$t5, 0		# $t5 = carry in for full adder = $s3
	add	$s0, $zero, $zero # $s0 = saving the final outcome 

add_sub:
	extract_0th_bit($t0, $a0)	# t0 = $a0[first_bit]
	extract_0th_bit($t1, $a1)	# t1 = $a1[first_bit]
	full_adder($t0, $t1, $t4, $t3, $t5, $t6) # full adder: $t4 = bit answer, $t6 = carry out
	insert_to_nth_bit($s0, $t2, $t4, $t5) 	 # $s0[$t2] = $t4
	move	$t5, $t6 		# $t5 = $t6, carry in = carry out
	addi	$t2, $t2, 1		# $t2 += 1
	beq	$t2, 32, end_add_sub
	j	add_sub
	
end_add_sub:
	move	$v0, $s0	# $v0 = $s0
	move	$v1, $t6	# $v1 = t6, which holds the overflow(last carry out)
	
	lw	$fp, 24($sp)
	lw	$ra, 20($sp)
	lw	$s0, 16($sp)
	lw	$a1, 12($sp)
	lw	$a0, 8($sp)
	add	$sp, $sp, 24
	jr	$ra
	
# Implement sub_logical
# Return: $v0 = ($a0 - $a1), $v1 = overflow if any
sub_logical:
	addi	$sp, $sp, -20
	sw	$fp, 20($sp)
	sw	$ra, 16($sp)
	sw	$a1, 12($sp)
	sw	$a0, 8($sp)
	addi	$fp, $sp 20
	
	neg	$a1, $a1	# $a1 = ~$a1
	jal	add_logical	# $v0 = $a0 + ~$a1
	
	lw	$fp, 20($sp)
	lw	$ra, 16($sp)
	lw	$a1, 12($sp)
	lw	$a0, 8($sp)
	add	$sp, $sp, 20
	jr	$ra
	
# Implement mul_unsigned
# Return: $v0 = Lo result, $v1 = Hi result 
mul_unsigned:
	addi	$sp, $sp, -48
	sw	$fp, 48($sp)
	sw	$ra, 44($sp)
	sw	$s6, 40($sp)
	sw	$s5, 36($sp)
	sw	$s4, 32($sp)
	sw	$s3, 28($sp)
	sw	$s2, 24($sp)
	sw	$s1, 20($sp)
	sw	$s0, 16($sp)
	sw	$a1, 12($sp)
	sw	$a0, 8($sp)
	addi $fp, $sp, 48
	
	move	$s6, $a1 	# $s6 = $a1
	li	$s0, 0 		# s0 for hi part of product
	li	$s1, 0 		# s1 for lo part of product
	li	$s2, 0 		# s2 for hi of MCND
	jal	twos_complement_if_neg	# $a0 = |$a0|
	move	$s3, $v0 	# $s3 = $v0
	move	$a0, $s6	# $a0 = $s6 = $a1
	jal	twos_complement_if_neg	# $a0 = |$a1|
	move	$s5, $v0  	# $s5 = $v0
	
	li	$s4, 0   # s4 as loop counter
	
unsigned_mul_loop:
	extract_0th_bit($t0, $s5)
	beqz	$t0, shift_MCND_by_1
	# add product and MCND in 64 bit
	move	$a0, $s0	# $a0 = $s0
	move	$a1, $s1	# $a1 = $s1
	move	$a2, $s2	# $a2 = $s2
	move	$a3, $s3	# $a3 = $s3
	jal	bit64_adder	# this is to two 32 bit numbers to get 64 bit
	move	$s0, $v0	# $s0 = $v0
	move	$s1, $v1	# $s1 = $v1

shift_MCND_by_1:
	move	$a0, $s2	# $a0 = $s2
	move	$a1, $s3	# $a1 = $s3
	jal	MCND_64bit_shift_left_by_1 # shift to the left by 1
	move	$s2, $v0	# $s2 = $v0
	move	$s3, $v1	# $s3 = $v1
	
	addi	$s4, $s4, 1	# $s4 += 1
	beq	$s4, 32, unsign_mul_loop_end # exit if $s4 == 32
	j	unsigned_mul_loop # repeat if $s4 != 32

unsign_mul_loop_end:
	move	$v0, $s1	# $v0 = $s1
	move	$v1, $s0	# $v1 = $s0
	
	lw	$fp, 48($sp)
	lw	$ra, 44($sp)
	lw	$s6, 40($sp)
	lw	$s5, 36($sp)
	lw	$s4, 32($sp)
	lw	$s3, 28($sp)
	lw	$s2, 24($sp)
	lw	$s1, 20($sp)
	lw	$s0, 16($sp)
	lw	$a1, 12($sp)
	lw	$a0, 8($sp)
	addi 	$sp, $sp, 48
	jr	$ra
	
# Implement mul_signed
# Return: $v0 = Lo result, $v1 = Hi result 
mul_signed:
	addi	$sp, $sp, -32
	sw	$fp, 32($sp)
	sw	$ra, 28($sp)
	sw	$s6, 24($sp)
	sw	$s1, 20($sp)
	sw	$s0, 16($sp)
	sw	$a1, 12($sp)
	sw	$a0, 8($sp)
	addi 	$fp, $sp, 32
	
	move	$t1, $a0	# $t1 = $a0
	move	$t2, $a1	# $t2 = $a1
	li	$t3, 31		# $t3 = 31,
	extract_nth_bit($t0, $t1, $t3)		# $t0 = $a0[31]
	extract_nth_bit($t4, $t2, $t3)		# $t4 = $a1[31]
	xor	$s6, $t0, $t4	# $s6 = $t0 (a0[31]) xor $t4 (a0[31])
	jal	mul_unsigned	# jump and link to multiplication unsigned
	move	$s0, $v0	# $s0 = $v0 (lo)
	move	$s1, $v1	# $s1 = $v1 (Hi)
	
	beqz	$s6, end_mul_signed 	# if it is 1 then exit
	move	$a0, $s0	    	# else, $a0 = $s0
	move	$a1, $s1	   	# $a1 = $s1
	jal	twos_complement_64bit	# find the twos_complement of both hi and lo 
	move	$s0, $v0		# $s0 = |$s0|
	move	$s1, $v1		# $s1 = |$s1|

end_mul_signed:
	move	$v0, $s0		# $v0 = |$s0| LO part
	move	$v1, $s1		# $v1 = |$s1| HI part
	lw	$fp, 32($sp)
	lw	$ra, 28($sp)
	lw	$s6, 24($sp)
	lw	$s1, 20($sp)
	lw	$s0, 16($sp)
	lw	$a1, 12($sp)
	lw	$a0, 8($sp)
	addi 	$sp, $sp, 32
	jr	$ra
	
# Implement div_unsigned
# Return: $v0 = quotient, $v1 = remainder 
div_unsigned:
	addi	$sp, $sp, -40
	sw	$fp, 40($sp)
	sw	$ra, 36($sp)
	sw	$s4, 32($sp)
	sw	$s3, 28($sp)
	sw	$s2, 24($sp)
	sw	$s1, 20($sp)
	sw	$s0, 16($sp)
	sw	$a1, 12($sp)
	sw	$a0, 8($sp)
	addi	$fp, $sp, 40
	
	move	$s1, $a1		# s1 = a1 for divisor
	jal	twos_complement_if_neg	# $a0 = |$a0|
	move	$s0, $v0		# s0 = $v0(|$a0|) for dividend
	move	$a0, $s1		# $a0 = $a1
	jal	twos_complement_if_neg	# $a0 = |$a1|
	move	$s1, $v0		# $s1 = $v0(|$a1|) for divisor
	li	$s2, 0			# $s2 for quotient
	li	$s3, 0			# $s3 for remainder
	li	$s4, 0			# $s4 for loop counter
	
	move	$s2, $s0	# $s2 = $s0
	
division_loop:
	beq	$s4, 32, end_division
	sll	$s3, $s3, 1		# remainder is shift to the left by 1
	li	$t1, 31			# $t1 = 31
	move	$t2, $s2		# $t2 = s2
	
	extract_nth_bit($t0, $t2, $t1)
	insert_to_nth_bit($s3, $zero, $t0, $t3)
	sll	$s2, $s2, 1		# dividend is shifted by 1
	
	move	$a0, $s3		# $a0 = remainder
	move	$a1, $s1		# $a1 = divisor
	jal	sub_logical		# $v0 = remainder - divisor
	move	$t3, $v0		# $t3 = $v0
	
	bltz	$t3, not_large_enough
	move	$s3, $t3		# $s3 = $t3
	li	$t0, 1			# $t0 = 1
	insert_to_nth_bit($s2, $zero, $t0, $t2) # $s2[0] = $t0
	
not_large_enough:
	addi	$s4, $s4, 1		# $s4 += 1
	j	division_loop		# repeat the loop again
	
end_division:
	move	$v0, $s2 		# $v0 = quotient
	move	$v1, $s3		# $v1 = remainder
	lw	$fp, 40($sp)
	lw	$ra, 36($sp)
	lw	$s4, 32($sp)
	lw	$s3, 28($sp)
	lw	$s2, 24($sp)
	lw	$s1, 20($sp)
	lw	$s0, 16($sp)
	lw	$a1, 12($sp)
	lw	$a0, 8($sp)
	addi	$sp, $sp, 40
	jr	$ra
	
# Implement div_signed
# Return: $v0 = quotient, $v1 = remainder 
div_signed:
	addi	$sp, $sp, -40
	sw	$fp, 40($sp)
	sw	$ra, 36($sp)
	sw	$s4, 32($sp)
	sw	$s3, 28($sp)
	sw	$s2, 24($sp)
	sw	$s1, 20($sp)
	sw	$s0, 16($sp)
	sw	$a1, 12($sp)
	sw	$a0, 8($sp)
	addi	$fp, $sp, 40
	
	move	$t1, $a0	# $t1 = $a0
	move	$t2, $a1	# $t2 = $a1
	li	$t3, 31		# $t3 = 31
	extract_nth_bit($s3, $t1, $t3)	# $s3 = $t1[$t3]
	extract_nth_bit($s4, $t2, $t3)	# $s4 = $t1[$t3]
	xor	$s0, $s3, $s4	# $s0 = $s3 xor $s4
	
	jal	div_unsigned	# jump and link to division loop
	move	$s1, $v0	# $s1 = quotient
	move	$s2, $v1	# $s2 = remainder
	
	beqz	$s0, check_remainder_sign
	move	$a0, $s1	# $a0 = quotient
	jal	twos_complement	# $v0 = ~quotient
	move	$s1, $v0	# $s1 = ~quotient
	
check_remainder_sign:
	beqz	$s3, end_div_signed
	move	$a0, $s2	# $a0 = remainder
	jal	twos_complement	# $v0 = ~remainder
	move	$s2, $v0	# $s2 = $v0
	
end_div_signed:
	move	$v0, $s1 	# $v0 = quotient
	move	$v1, $s2	# $v1 = remainder
	
	lw	$fp, 40($sp)
	lw	$ra, 36($sp)
	lw	$s4, 32($sp)
	lw	$s3, 28($sp)
	lw	$s2, 24($sp)
	lw	$s1, 20($sp)
	lw	$s0, 16($sp)
	lw	$a1, 12($sp)
	lw	$a0, 8($sp)
	addi	$sp, $sp, 40
	jr	$ra
	
# Implement twos_complement
# Return: $v0: number in 2's complement
twos_complement:
	addi	$sp, $sp, -16
	sw	$fp, 16($sp)
	sw	$ra, 12($sp)
	sw	$a0, 8($sp)
	addi	$fp, $sp 16
	
	not	$a0, $a0	# $a0 = ~$a0
	li	$a1, 1		# $a1 = 1
	jal	add_logical	# $v0 = ~$a0 + 1
	
	lw	$fp, 16($sp)
	lw	$ra, 12($sp)
	lw	$a0, 8($sp)
	addi	$sp, $sp 16
	jr	$ra
	
# Implement twos_complement_if_neg
# Return: $v0 = number in 2's complement
twos_complement_if_neg:
	addi	$sp, $sp, -16
	sw	$fp, 16($sp)
	sw	$ra, 12($sp)
	sw	$a0, 8($sp)
	addi	$fp, $sp 16
	
	li	$t1, 31		# $t1 = 31
	move	$t2, $a0	# $t2 = $a0
	extract_nth_bit($t0, $t2, $t1)	# $t0 = $t2[$t1]
	beqz	$t0, if_positive	# if $t0 is positive jump to positive
	jal	twos_complement		# else $v0 = ~$t0
	j	twos_complement_if_neg_done
	
if_positive:
	move	$v0, $a0	# $v0 = $a0 
	
twos_complement_if_neg_done:
	lw	$fp, 16($sp)
	lw	$ra, 12($sp)
	lw	$a0, 8($sp)
	addi	$sp, $sp 16
	jr	$ra
	
# Implement twos_complement_64bit
# Return: $v0 = Lo number in 2's complement, $v1 = Hi number in 2's complement
twos_complement_64bit:
	addi	$sp, $sp, -28
	sw	$fp, 28($sp)
	sw	$ra, 24($sp)
	sw	$s1, 20($sp)
	sw	$s0, 16($sp)
	sw	$a1, 12($sp)
	sw	$a0, 8($sp)
	addi	$fp, $sp 28
	
	not	$a0, $a0	# invert a0
	not	$a1, $a1	# invert a1
	move	$s0, $a1	# s0 = a1
	li	$a1, 1
	jal	add_logical
	
	move	$a0, $v1	# set a0 to the overflow bit
	move	$a1, $s0	# a1 = s0
	move	$s1, $v0	# save Lo part of 64bit 2'complement in s1
	jal	add_logical
	
	move	$v1, $v0	# move Hi part of 64bit 2'complement in v1
	move	$v0, $s1
	
	lw	$fp, 28($sp)
	lw	$ra, 24($sp)
	lw	$s1, 20($sp)
	lw	$s0, 16($sp)
	lw	$a1, 12($sp)
	lw	$a0, 8($sp)
	addi	$sp, $sp, 28
	jr	$ra
	
# Implement bit_replicator
# Return: $v0: all 0 or all 1 for 32-bit 
bit_replicator:
	addi	$sp, $sp -16
	sw	$fp, 16($sp)
	sw	$ra, 12($sp)
	sw	$a0, 8($sp)
	addi	$fp, $sp, 16
	
	extract_0th_bit($t0, $a0)
	beqz	$t0, end_bit_replicator 	# if t0 = 0 t0 already the answer
	
	srl	$t0, $t0, 1	# know t1 should be all 0s
	move	$a0, $t0	# a0 = t0
	jal	twos_complement # $v0 is now all 1s
	
end_bit_replicator:
	move	$v0, $t0	# $v0 = $t0
	
	lw	$fp, 16($sp)
	lw	$ra, 12($sp)
	lw	$a0, 8($sp)
	addi	$sp, $sp, 16
	jr	$ra

# Implement bit64_adder
# Return: $v0 = hi, $v1 = lo
bit64_adder:
	addi	$sp, $sp, -36
	sw	$fp, 36($sp)
	sw	$ra, 32($sp)
	sw	$s5, 28($sp)
	sw	$s4, 24($sp)
	sw	$s3, 20($sp)
	sw	$s2, 16($sp)
	sw	$s1, 12($sp)
	sw	$s0, 8($sp)
	addi	$fp, $sp, 36
	
	move	$s0, $a0	# s0 for Lo
	move	$s1, $a1	# s1 for Hi
	move	$s2, $a2	# s2 for Lo result
	move	$s3, $a3	# s3 for Hi result
	
	# add Lo first 
	move	$a0, $s2
	move	$a1, $s0
	jal	add_logical	# gives the LO result
	move	$s2, $v0	# s2 = LO result
	move	$t0, $v1	# carry out
	
	# first add Hi with carry out
	move 	$a0, $s3
	move	$a1, $t0
	jal	add_logical
	move	$s3, $v0	# $s3 = $v0
	
	move 	$a0, $s3
	move	$a1, $s1
	jal	add_logical	# $v0 = $s3 + $s1
	move	$s3, $v0	# $s3 = HI result
	move	$v0, $s2	# $v0 = LO part
	move	$v1, $s3	# $v1 = HI part
	
	lw	$fp, 36($sp)
	lw	$ra, 32($sp)
	lw	$s5, 28($sp)
	lw	$s4, 24($sp)
	lw	$s3, 20($sp)
	lw	$s2, 16($sp)
	lw	$s1, 12($sp)
	lw	$s0, 8($sp)
	addi	$sp, $sp, 36
	jr 	$ra
	
# Return: $v0 = hi part, $v1 = lo part
MCND_64bit_shift_left_by_1:
	addi	$sp, $sp, -24
	sw	$s0, 24($sp)
	sw	$a1, 20($sp) 
	sw	$a0, 16($sp)
	sw	$ra, 12($sp)
	sw	$fp, 8($sp)
	addi	$fp, $sp, 24

	move	$s0, $a1	# set s0 = low part
	li	$t1, 31		# shift by 31 to get the last bit
	extract_nth_bit($t0, $s0, $t1)
	sll	$a0, $a0, 1 	# shift high part by one(make room)
				# shift high register by 1 then insert MSB from low
	insert_to_nth_bit($a0, $zero, $t0, $t1)
	sll	$a1, $a1, 1	 # shift low register by 1
	move	$v0, $a0
	move	$v1, $a1
	
	lw	$s0, 24($sp)
	lw	$a1, 20($sp) 
	lw	$a0, 16($sp)
	lw	$ra, 12($sp)
	lw	$fp, 8($sp)
	addi	$sp, $sp, 24
	jr	$ra