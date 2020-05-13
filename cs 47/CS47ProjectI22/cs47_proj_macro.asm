# Add you macro definition here - do not touch cs47_common_macro.asm"
#<------------------ MACRO DEFINITIONS ---------------------->#

# extract_nth_bit:
# get the nth bit of a bit pattern
# input:$regD: the returning bit
# 	$regS: the source bit pattern
#	$regT: the nth position(0-31)
# output:$regD
#----------------------------------------
.macro extract_nth_bit($regD, $regS, $regT)
	srlv	$regS, $regS, $regT	# shift pattern in regS right by regT
	li	$regD, 1		# regD = 1
	and	$regD, $regS, $regD	# masking to check the right most bit of $regS
.end_macro

# extract_0th_bit:
# get the nth bit of a bit pattern
# input:$regD: the returning bit
# 	$regS: the source bit pattern
# output:$regD
#----------------------------------------
.macro extract_0th_bit($regD, $regS)
	li	$regD, 1		# regD = 1
	and	$regD, $regS, $regD	# masking to check the right most bit of $regS
	srl	$regS, $regS, 1		# shift pattern in regS right by 1
.end_macro

# insert_to_nth_bit:
# insert 1 to nth bit of in bit pattern(nature of OR)s
# input:$regD: This the bit pattern in which 1 to be inserted at nth position
# 	$regS: Value n, from which position the bit to be inserted (0-31)
#	$regT: Register that contains 0x1 or 0x0 (bit value to insert)
#	$maskReg: register to hold temporary mask
# output:$regD
#----------------------------------------
.macro insert_to_nth_bit($regD, $regS, $regT, $maskReg)
	move	$maskReg, $regT			# move 1 in regT into maskReg
	sllv	$maskReg, $maskReg, $regS	# shift left by regS
	or	$regD, $regD, $maskReg		# regD = regD or maskReg
.end_macro

# half_adder:
# half adder takes in 2 bits, A and B, return 2 output, Y(answer on position) and C(carry)
# input:$A: first bit
# 	$B: second bit
#	$Y: answer holder
#	$C: carry holder
# output:$Y: answer
#	 $C: carry
#----------------------------------------
.macro half_adder($A, $B, $Y, $C)
	xor	$Y, $A, $B	# Y = A xor B
	and	$C, $A, $B	# C = A and B
.end_macro

# full_adder:
# full adder takes in 2 bits, A and B, return 2 output, Y(answer on position) and C(carry)
# input:$A: first bit
# 	$B: second bit
#	$Y: answer holder
#	$AB:carry from half adder
#	$Ci:carry in
#	$Co:caary out holder 
# output:$Y: answer
#	 $Co: carry out
#----------------------------------------
.macro full_adder($A, $B, $Y, $AB, $Ci, $Co)
	half_adder($A, $B, $Y, $AB)
	and	$Co, $Ci, $Y	# Co = Ci and (A xor B)
	xor	$Y, $Ci, $Y	# y = Ci xor (A xor B)
	xor	$Co, $Co, $AB	# Co = (Ci and (A xor B)) xor (A and B)
.end_macro