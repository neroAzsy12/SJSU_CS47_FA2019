.include "./cs47_macro.asm"

.data 
char_pipe: .asciiz " | "

.text 
main: lw $t0, 0x10
      lw $t1, 0x11
loop: bne $t0, $zero, end
      add $s0, $s0, $t1
      addi $t1, $t1, -2
      addi $t0, $t0, -1
      j loop
end: sw $s0, 0x13