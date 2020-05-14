.data 
	tb1: .asciiz "project2"

.text
	li $v0,4
	la $a0,tb1 
	syscall 
	
