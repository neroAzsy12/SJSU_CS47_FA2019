.text
#-------------------------------------------
# Procedure: insertion_sort
# Argument: 
#	$a0: Base address of the array
#       $a1: Number of array element
# Return:
#       None
# Notes: Implement insertion sort, base array 
#        at $a0 will be sorted after the routine
#	 is done.
#-------------------------------------------
insertion_sort:
	# RTE STORE 
	subi $sp, $sp, 20	
	sw  $fp, 20($sp)
	sw  $ra, 16($sp)			
	sw  $a0, 12($sp)			
	sw  $a1, 8($sp)				
	addi $fp, $sp, 20			
	
	li $t0, 1								
	bgt $a1, $t0, insertion_for_loop			
	
insertion_for_loop:					
	bge $t0, $a1, insertion_sort_end	  	
	move $t1, $t0				
						
insertion_while_loop:						
	bgtz $t1, insertion_swap			
	li $t6, 4									
	mult $t0, $t6				
	mflo $t7			
	add $t7, $t7, 4				
	add $a0, $a0, $t7			
	addi $t0, $t0, 1			
	j	insertion_for_loop		
	
insertion_swap:	
	lw $t2, 4($a0) 								
	lw $t3, 0($a0) 					
	blt $t2, $t3, insertion_move			
	j insertion_next_elem		

insertion_move:					
	move $t4, $t2			 
	move $t2, $t3					
	move $t3, $t4				
	sw $t2, 4($a0)				
	sw $t3, 0($a0)				
	j insertion_next_elem			
	
insertion_next_elem:	
	subi $t1, $t1, 1			
	subi $a0, $a0, 4			
	j insertion_while_loop								
	
insertion_sort_end:
	lw  $fp, 20($sp)			# RTE RESTORE
	lw  $ra, 16($sp)			# Loading 20 bytes for stack pointer
	lw  $a0, 12($sp)
	lw  $a1, 8($sp)
	addi $sp, $sp, 20
	jr	$ra