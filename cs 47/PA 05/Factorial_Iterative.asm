.include "./cs47_macro.asm"

.data
msg1: .asciiz "Enter a number ? "
msg2: .asciiz "Factorial of the number is "
charCR: .asciiz "\n"

.text
.globl main
main:	print_str(msg1)
	read_int($t0)
	
# Write body of the iterative
# factorial program here
# Store the factorial result into 
# register $s0
addiu $t1, $zero, 1
addiu $s0, $zero, 1
factorial:
	bgt $t1, $t0, print_factorial	# while $t1 < $t0
	mul $s0, $s0, $t1		# $s0 = $s0 * $t1
	add $t1, $t1, 1			# $t1 = $t1 + 1
	j factorial
# DON'T IMPLEMENT RECURSIVE ROUTINE 
# WE NEED AN ITERATIVE IMPLEMENTATION 
# RIGHT AT THIS POSITION. 
# DONT USE 'jal' AS IN PROCEDURAL /
# RECURSIVE IMPLEMENTATION.

print_factorial:
	print_str(msg2)
	print_reg_int($s0)
	print_str(charCR)
	exit
