# Add you macro definition here - do not touch cs47_common_macro.asm"
#<------------------ MACRO DEFINITIONS ---------------------->#

.macro half_adder($a, $b, $c, $y) #from Lecture 18
	xor $y, $a, $b		  # y = a xor b
	and $c, $a, $b		  # c = a and b
.end_macro

# $a is the bit at a0[i]
# $b is the bit at a1[i]
.macro full_adder($a, $b, $ab, $y, $co, $ci)
	half_adder($a, $b, $ab, $y) # $ab = a and b, $y = $a xor $b
	and $co, $ci, $y 	    # $co = $ci and ($a xor $b)
	xor $co, $co, $ab	    # $co = $ci or ($a and $b)
	xor $y, $ci, $y		    # $y = $ci xor ($a xor $b)
.end_macro

.macro twos_complement($number) # bit inversion
	not $number, $number	# each 1 is changed to a 0, each 0 is changed into a 1
	addi $number, $number, 0x1 # needs to add 1, inorder to get the two's complement of a number
.end_macro

# $regD is the holder that will contain 1 or 0, use a random register
# $regS is the source bit pattern $a0 or $a1 depending on which one
# $regT is the index between (0-31), a0[regT] or a1[regT]
.macro extract_nth_bit($regD, $regS, $regT) 
	srlv $regD, $regS, $regT
	and $regD, $regD, 1
.end_macro
 
 # regD: is the register that contains the result
 # regS: the position in which the bit will be inserted on
 # regT: register that has either 1 or 0 (bit value to insert)
 # maskReg: temporary register
.macro insert_to_nth_bit($regD, $regS, $regT, $maskReg)
	addi $maskReg, $zero, 1
	sllv $maskReg, $maskReg, $regS
	nor $maskReg, $maskReg, $zero
	and $regD, $regD, $maskReg
	sllv $regT, $regT, $regS
	or $regD, $regD, $regT
	
	#move $maskReg, $regT
	#sllv $maskReg, $maskReg, $regS
	#or $regD, $regD, $maskReg
.end_macro
