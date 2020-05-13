.include "./cs47_macro.asm"

.data
msg1: .asciiz "Enter a +ve number : "
msg2: .asciiz "Enter another +ve number : "
msg3: .asciiz "LCM of "
s_is: .asciiz "is"
s_and: .asciiz "and"
s_space: .asciiz " "
s_cr: .asciiz "\n"

.text
.globl main
main:
	print_str(msg1)
	read_int($s0)
	print_str(msg2)
	read_int($s1)
	
	move $v0, $zero
	move $a0, $s0
	move $a1, $s1
	move $a2, $s0
	move $a3, $s1
	jal  lcm_recursive
	move $s3, $v0
	
	print_str(msg3)
	print_reg_int($s0)
	print_str(s_space)
	print_str(s_and)
	print_str(s_space)
	print_reg_int($s1)
	print_str(s_space)
	print_str(s_is)
	print_str(s_space)
	print_reg_int($s3)
	print_str(s_cr)
	exit

#------------------------------------------------------------------------------
# Function: lcm_recursive 
# Argument:
#	$a0 : +ve integer number m
#       $a1 : +ve integer number n
#       $a2 : temporary LCM by increamenting m, initial is m
#       $a3 : temporary LCM by increamenting n, initial is n
# Returns
#	$v0 : lcm of m,n 
#
# Purpose: Implementing LCM function using recursive call.
# 
#------------------------------------------------------------------------------
lcm_recursive:
	# Store frame
	# need to save $fp, $ra, $sp, $a0, $a1, $a2, $a3, 7
	addi $sp, $sp, -28
	sw $fp, 28($sp)
	sw $ra, 24($sp)
	sw $a3, 20($sp)
	sw $a2, 16($sp)
	sw $a1, 12($sp)
	sw $a0, 8($sp)
	addi $fp, $sp, 28
	
	# Body
	beq $a2, $a3, lcm_base_case	#if lcm_m == lcm_n
	bgt $a2, $a3, lcm_m_greater	#if lcm_m > lcm_n
	blt $a2, $a3, lcm_n_greater	#if lcm_m < lcm_n
	jal lcm_recursive
	
lcm_base_case:
	addu $v0, $a2, $0		#$v0 = lcm_m
	j lcm_recursive_rtn
	
lcm_m_greater:
	addu $a3, $a3, $a1		#$a3 = $a3 + $a1
	j lcm_recursive

lcm_n_greater:
	addu $a2, $a2, $a0		#$a2 = $a2 + $a0
	j lcm_recursive

	# Restore frame
lcm_recursive_rtn:
	lw $fp, 28($sp)
	lw $ra, 24($sp)
	lw $a3, 20($sp)
	lw $a2, 16($sp)
	lw $a1, 12($sp)
	lw $a0, 8($sp)
	addi $fp, $sp, 28
	jr $ra
	
