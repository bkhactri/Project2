.data 
	tb1: .asciiz "project2"
	tb2: .asciiz "tuan da o day"
	tb2: .asciiz "tri da o day"

.text
	li $v0,4
	la $a0,tb1
	syscall 
	
	li $v0, 4
	la $a0, tb2
	syscall
	
	li $v0, 4
	la $a0, tb3
	syscall
