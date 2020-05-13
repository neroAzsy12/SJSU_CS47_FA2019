.include "./cs47_proj_macro.asm"
.text
.globl au_normal
# TBD: Complete your project procedures
# Needed skeleton is given
#####################################################################
# Implement au_normal
# Argument:
# 	$a0: First number
#	$a1: Second number
#	$a2: operation code ('+':add, '-':sub, '*':mul, '/':div)
# Return:
#	$v0: ($a0+$a1) | ($a0-$a1) | ($a0*$a1):LO | ($a0 / $a1)
# 	$v1: ($a0 * $a1):HI | ($a0 % $a1)
# Notes:
#####################################################################
au_normal:
	addi $sp, $sp, -24
	sw $fp, 24($sp)
	sw $ra, 20($sp)
	sw $a2, 16($sp)
	sw $a1, 12($sp)
	sw $a0,  8($sp)
	addi $fp, $sp, 24
	
	li $t0, 42    # ascii value of *
	beq $t0, $a2, multiply_au_normal
	
	li $t0, 43    # ascii value of +
	beq $t0, $a2, add_au_normal
	
	li $t0, 45    # ascii value of -
	beq $t0, $a2, subtract_au_normal
	
	li $t0, 47    # ascii value of /
	beq $t0, $a2, divide_au_normal
	
	j end_au_normal

multiply_au_normal:
	mult $a0, $a1
	mflo $v0
	mfhi $v1
	j end_au_normal

add_au_normal:
	add $v0, $a0, $a1
	j end_au_normal
	
subtract_au_normal:
	sub $v0, $a0, $a1
	j end_au_normal

divide_au_normal:
	div $a0, $a1
	mfhi $v1
	mflo $v0
	j end_au_normal
	
end_au_normal:
	lw $fp, 24($sp)
	lw $ra, 20($sp)
	lw $a2, 16($sp)
	lw $a1, 12($sp)
	lw $a0, 8($sp) 
	addi $sp, $sp, 24
	jr	$ra
