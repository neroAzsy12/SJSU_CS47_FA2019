#<-------------------------- Macro Definition ------------------------------>#
	# Macro: print_str
	# usage: print_str(<address of string>)
	.macro print_str($arg)
	li	$v0, 4		#system call code for print_str
	la	$a0, $arg	# address of the string to print
	syscall			# print the string
	.end_macro
	
	# Macro: print_int
	# usage: print_int(<val>)
	.macro print_int($arg)
	li	$v0, 1
	li	$a0, $arg
	syscall
	.end_macro
	
	# Macro: exit
	# usage: exit
	.macro exit
	li	$v0, 10
	syscall
	.end_macro

.data
str:	.asciiz		"the answer is = "

.text
.globl main
main:	print_str(str)
	print_int(5)
	exit
	
