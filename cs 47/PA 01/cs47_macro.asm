#<------------------ MACRO DEFINITIONS ---------------------->#
        # Macro : print_str
        # Usage: print_str(<address of the string>)
        .macro print_str($arg)
	li	$v0, 4     # System call code for print_str  
	la	$a0, $arg   # Address of the string to print
	syscall            # Print the string        
	.end_macro
	
	# Macro : print_int
        # Usage: print_int(<val>)
        .macro print_int($arg)
	li 	$v0, 1     # System call code for print_ina = i + j + kt
	li	$a0, $arg  # Integer to print
	syscall            # Print the integer
	.end_macro

	# takes user input of an integer value
	.macro read_int($reg)
	li 	$v0, 5	   # system call code for read integer, takes user input of integer
	syscall		   # reads the integer, this is important to have it here, since it will store the value before moving it
	move 	$reg, $v0  # sets the contents of $reg to register $v0 (the user input)
	.end_macro
	
	# prints the user integer input
	.macro print_reg_int($reg)
	li	$v0, 1	  # system call code to print integer 
	move	$a0, $reg # sets $a0 to have the int value of $reg
	syscall		  # prints the integer from $reg using $a0
	.end_macro
		
	# Macro : exit
        # Usage: exit
        .macro exit
	li 	$v0, 10 
	syscall
	.end_macro
	
