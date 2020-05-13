.include "./cs47_macro.asm"

#<------------------ APPLICATION PROGRAM---------------------->#
#<------------------ DATA SEGMENT DEFINITION------------------>#
.data
str:	.asciiz  "the answer is ="

#<------------------ CODE SEGMENT DEFINITION------------------>#
.text
.globl main
main:	print_str(str)
	print_int(5)
	exit
