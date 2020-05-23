.data

#---- Cho nay danh luu thong tin nguoi choi -----#
	InputNameSyscall: .asciiz "Dat ten nhan vat cua ban nao: "
	Name: .space 100
	WinCount: .word 0
	Score: .word 
#---- Day la du lieu de ve cai truong hop doan sai -------#
	# Gia do phia tren
	shelfTop: .asciiz "\n           _\n         /_/|\n         | |+-----o\n"
	# Gia do phia duoi
	shelfBot: .asciiz "   / \\   | ||  /|\n  /      |_|/ / /\n /___________/ /\n |___________|/\n"
	# Day treo
	rope:      .asciiz "         | ||     |\n"
	# Khong co day treo
	notrope:      .asciiz "         | ||      \n"
	# Dau nguoi
	headMan:   .asciiz "         | ||     O\n"
	# Than nguoi
	bodyMan1:  .asciiz "    O/o  | ||     |   \n"
	bodyMan2:  .asciiz "    O/o  | ||    /|   \n"
	bodyMan3:  .asciiz "    O/o  | ||    /|\\ \n"
	# Chan nguoi
	legMan1:   .asciiz "   /|___\\| ||___ /    \n"
	legMan2:   .asciiz "   /|___\\| ||___ / \\ \n"
	# Khong hien thi nguoi
	notMan1:    .asciiz "         | ||          \n"
	notMan2:    .asciiz "    O/o  | ||          \n"
	notMan3:    .asciiz "   /|___\\| ||___      \n"


#----- Day la phan danh cho xu ly game -----------#
	Game: .asciiz "  _-^-_ HANGMAN _-^-_" 
	inputChoose: .asciiz "\n  ==  Lua chon cach doan cua ban  ==\n1. Doan ki tu \n2. Doan chuoi \nLua chon cua ban: "
	Warning : .asciiz "\nDAY LA TU KHOA : "

	# ====> Nhap dang ky tu
	inputGuessChar: .asciiz "Ban doan ky tu la : "
	# ====> Nhap dang chuoi
	inputGuessString: .asciiz "Ban doan dap an la : "

	strCheck:.space 100 #chuoi nhap
	size: .word 0 #size cua chuoi dap an

	outputExist: .asciiz "\nKi tu nay ban da doan roi  \n"
	downLine: .asciiz "\n"
	outputLost: .asciiz "\n*** You lost! ***\n"
	outputWin: .asciiz "\n*** You win! ***\n"
	notExist: .asciiz "\nKi tu khong ton tai. Ban mat 1 mang."
	ntfRemainLive: .asciiz "\n<>===<> So mang con lai: "

	

#------ Day la phan luu thong tin ---------#	
	# ====> OutputStr co the thay doi
	UnKnown : .asciiz "*"
	OutputStr: .space 200
	Life: .word 7

#------ Day la phan doc file ---------#	
	fileName: .asciiz "D:/De.txt"
	fileWords: .space 1024
	Word: .space 200 #Trong day chua de
	SizeWord: .word 0 #Trong day chua so luong size de
	SizeString: .word 0 
	sl: .word 0
	n: .word 0 #So luong de
	MaDe: .word 0
.text
	.globl main
main:
	#Xuat thong bao nhap ten
	li $v0,4
	la $a0,InputNameSyscall
	syscall
	#Nhap ten 
	li $v0,8
	la $a0,Name
	la $a1,100
	syscall
	
	#Truyen tham so vao
	la $a0,Name
	#Goi ham kiem tra ten
	jal _CheckName




	#Doc file
	li $v0,13           	# mo file voi syscall 13
    	la $a0,fileName     	# dia chi file
    	li $a1,0        	# bat flag len 0 de doc
    	syscall
    	move $s0,$v0        	# luu vao thanh ghi $s0
	
	# luu vao chuoi
	li $v0, 14		# doc file voi syscall 14
	move $a0,$s0		# noi dung file
	la $a1,fileWords  	# chuoi luu tru file
	la $a2,1024		# chieu dai toi da cua chuoi
	syscall
	
	#lay kich thuoc cua chuoi
	sw $v0, SizeString
	
	#Close the file
   	li $v0, 16         		# close_file syscall code
 	move $a0,$s0      		# file descriptor to close
    	syscall
	
	# lay so luong tu trong chuoi
	la $a0, fileWords
	lw $a1, SizeString
	la $a2, n
	
	# goi ham lay so luong tu
	jal _GetSize

_ContinuePlay:

	#Lay ra tong so de va random tu 1 -> n de lay ra ma de
	lw $a1, n
   	li $v0, 42  #random
    	syscall
   	
	#li $a0,0
	addi $a0,$a0,1	

	#luu vao bien ma de
	sw $a0,MaDe
	
	# truyen tham so
	la $a0, fileWords
	lw $a1, SizeString
	la $a2, Word
	lw $a3, MaDe
	# goi ham lay de
	jal _Getword

	# truyen tham so
	lw $a0,SizeWord
	jal _CreateOutPutStr	
	
	# Hien thi dau game
	li $v0,4
	la $a0,Game
	syscall
	
	# Hien thi gia do phia tren
	li $v0,4
	la $a0,shelfTop
	syscall
	# Day treo
	li $v0,4
	la $a0,notrope
	syscall
	# Hien thi phan than co nguoi hoac khong co nguoi
	li $v0,4
	la $a0,notMan1
	syscall
	li $v0,4
	la $a0,notMan2
	syscall
	li $v0,4
	la $a0,notMan3
	syscall
	# Hien thi gia do phia duoi
	li $v0,4
	la $a0,shelfBot
	syscall
	
	#Xuat de
	li $v0,4
	la $a0,Warning
	syscall
	
	li $v0,4
	la $a0,OutputStr
	syscall

	#Xuat xuong dong
	li $v0, 4 	
	la $a0, downLine	
	syscall 

	# Ham doan ki tu
	jal _GuessCharacter
# Ham lua chon nhap ki tu hay chuoi
_Choose:
	li $v0,4
	la $a0,inputChoose
	syscall

	li $v0,5
	syscall

	move $s5,$v0
	beq $s5,1,_inputChar.Continue
	beq $s5,2,_GuessString
	j _Choose
# Sai 0 
_NumIncorrect_0:
	# Hien thi gio do phia tren
	li $v0,4
	la $a0,shelfTop
	syscall
	# Dây treo
	li $v0,4
	la $a0,notrope
	syscall
	# Hien thi phan than co nguoi hoac khong co nguoi
	li $v0,4
	la $a0,notMan1
	syscall
	li $v0,4
	la $a0,notMan2
	syscall
	li $v0,4
	la $a0,notMan3
	syscall
	# Hien thi gia do phia duoi
	li $v0,4
	la $a0,shelfBot
	syscall
	j Lost.Continue	
# Sai 1	
_NumIncorrect_1:
	# Hien thi gia do phia tren
	li $v0,4
	la $a0,shelfTop
	syscall
	# Dây treo
	li $v0,4
	la $a0,rope
	syscall
	# Hien thi phan than co nguoi hoac khong co nguoi
	li $v0,4
	la $a0,notMan1
	syscall
	li $v0,4
	la $a0,notMan2
	syscall
	li $v0,4
	la $a0,notMan3
	syscall
	# Hien thi gia do phia duoi
	li $v0,4
	la $a0,shelfBot
	syscall
	j Lost.Continue	
# Sai 2
_NumIncorrect_2:
	# Hien thi gia do phia tren
	li $v0,4
	la $a0,shelfTop
	syscall
	# Dây treo
	li $v0,4
	la $a0,rope
	syscall
	# Hien thi phan than co nguoi hoac khong co nguoi
	li $v0,4
	la $a0,headMan
	syscall
	li $v0,4
	la $a0,notMan2
	syscall
	li $v0,4
	la $a0,notMan3
	syscall
	# Hiên thi gia do phia duoi
	li $v0,4
	la $a0,shelfBot
	syscall
	j Lost.Continue	
# Sai 3	
_NumIncorrect_3:
	# Hien thi gia do phia tren
	li $v0,4
	la $a0,shelfTop
	syscall
	# Dây treo
	li $v0,4
	la $a0,rope
	syscall
	# Hien thi phan than co nguoi hoac khong co nguoi
	li $v0,4
	la $a0,headMan
	syscall
	li $v0,4
	la $a0,bodyMan1
	syscall
	li $v0,4
	la $a0,notMan3
	syscall
	# Hiên thi gia do phia duoi
	li $v0,4
	la $a0,shelfBot
	syscall
	j Lost.Continue	
# Sai 4	
_NumIncorrect_4:
	# Hien thi gia do phia tren
	li $v0,4
	la $a0,shelfTop
	syscall
	# Dây treo
	li $v0,4
	la $a0,rope
	syscall
	# Hien thi phan than co nguoi hoac khong co nguoi
	li $v0,4
	la $a0,headMan
	syscall
	li $v0,4
	la $a0,bodyMan2
	syscall
	li $v0,4
	la $a0,notMan3
	syscall
	# Hiên thi gia do phia duoi
	li $v0,4
	la $a0,shelfBot
	syscall

	j Lost.Continue	
# Sai 5	
_NumIncorrect_5:
	# Hien thi gia do phia tren
	li $v0,4
	la $a0,shelfTop
	syscall
	# Dây treo
	li $v0,4
	la $a0,rope
	syscall
	# Hien thi phan than co nguoi hoac khong co nguoi
	li $v0,4
	la $a0,headMan
	syscall
	li $v0,4
	la $a0,bodyMan3
	syscall
	li $v0,4
	la $a0,notMan3
	syscall
	# Hien thi gia do phia duoi
	la $a0,shelfBot
	syscall

	j Lost.Continue		
# Sai 6
_NumIncorrect_6:
	# Hien thi gia do phia tren
	li $v0,4
	la $a0,shelfTop
	syscall
	# Dây treo
	li $v0,4
	la $a0,rope
	syscall
	# Hien thi phan than co nguoi hoac khong co nguoi
	li $v0,4
	la $a0,headMan
	syscall
	li $v0,4
	la $a0,bodyMan3
	syscall
	li $v0,4
	la $a0,legMan1
	syscall
	# Hien thi gia do phia duoi
	li $v0,4
	la $a0,shelfBot
	syscall
	j Lost.Continue	
# Sai 7
_NumIncorrect_7:
	# Hien thi gia do phia tren
	li $v0,4
	la $a0,shelfTop
	syscall
	# Dây treo
	li $v0,4
	la $a0,rope
	syscall
	# Hien thi phan than co nguoi hoac khong co nguoi
	li $v0,4
	la $a0,headMan
	syscall
	li $v0,4
	la $a0,bodyMan3
	syscall
	li $v0,4
	la $a0,legMan2
	syscall
	# Hien thi gia d? phia duoi
	li $v0,4
	la $a0,shelfBot
	syscall
	j Condi

# PHAN XU LY GAME DUOI DAY NE #
#----- Ham doan ky tu----#
_GuessCharacter:
	# Dau thu tuc
	addi $sp,$sp,-64
	sw $ra,($sp)
	sw $t0,4($sp)
	sw $t1,8($sp)
	sw $t2,12($sp)
	sw $t3,16($sp)
	sw $t4,20($sp)
	sw $t5,24($sp)
	sw $t6,28($sp)
	sw $t7,32($sp)
	sw $s0,36($sp)
	sw $s1,40($sp)

	lw $t4,Life
	la $t1,Word
	lw $t2,SizeWord
	la $t3,OutputStr
Condi:	
	#Kiem tra dieu kien chay
	beq $t4,$0,OutLost
	
	#Kiem tra chien thang
	li $t7,'*' # khoi tao *

	move $t5,$0  # khoi tao bien dem
	j CheckWinLoop

	CheckWinLoop:
		beq $t5,$t2,OutWin
		lb $t6,($t3)

		beq $t6,$t7,Condi.Next1
		addi $t5,$t5,1
		addi $t3,$t3,1
		j CheckWinLoop
Condi.Next1:	
	j _Choose
_inputChar.Continue:
	sub $t3,$t3,$t5
	#Xuat thong bao nhap
	li $v0, 4 	
	la $a0, inputGuessChar 	
	syscall 	
	
	#NhapKiTu
	li $v0, 12	
	syscall
	
	#Luu du lieu
	move $t0,$v0

	#Kiem tra ki tu vua nhap da tung duoc nhap chua
	move $t5,$0 
	j Condi.LoopFind

	Condi.LoopFind:
		beq $t5,$t2,Condi.Out.True
		lb $t6,($t3)	

		beq $t6,$t0,Condi.Out.False
		addi $t5,$t5,1
		addi $t3,$t3,1
		j Condi.LoopFind

	Condi.Out.False:
		sub $t3,$t3,$t5

		#Xuat thong bao ton tai
		li $v0, 4 	
		la $a0, outputExist	
		syscall 

		j Condi

	Condi.Out.True:
		sub $t3,$t3,$t5

		j Condi.Next

Condi.Next:
	#Flag gan bang 0
	move $t7,$0
	#Khoi tao thanh ghi dem = 0
	move $t5,$0
	#$s0 phan tu mang da
	#$s1 phan tu mang doi chung
	#Tim vi tri ki tu nhap vao
	j FindInArr

	FindInArr:
		beq $t5, $t2,FindInArr.Out
		lb $s0,($t1)
		lb $s1,($t3)

		beq $s0,$t0,FindInArr.ChangeOutputStr
		j FindInArr.NChangeOutputStr

		FindInArr.ChangeOutputStr:
			sb $t0,($t3)
			addi $t7,$t7,1
			j FindInArr.NChangeOutputStr
		FindInArr.NChangeOutputStr:
			addi $t5,$t5,1
			addi $t3,$t3,1
			addi $t1,$t1,1
			j FindInArr
	FindInArr.Out:
		sub $t3,$t3,$t5
		sub $t1,$t1,$t5
		beq $t7,$0,Lost
		j Win
	Lost:
		#so mang tru 1
		addi $t4, $t4, -1
		# Kiem tra so lan sai va xuat giao dien
		beq $t4, 6, _NumIncorrect_1
		beq $t4, 5, _NumIncorrect_2
		beq $t4, 4, _NumIncorrect_3
		beq $t4, 3, _NumIncorrect_4
		beq $t4, 2, _NumIncorrect_5
		beq $t4, 1, _NumIncorrect_6
		beq $t4, 0, _NumIncorrect_7
	Lost.Continue:
		#Xuat thong bao thua
		li $v0, 4 	
		la $a0, notExist	
		syscall 
		
		# Thong bao so mang con lai
		li $v0,4
		la $a0,ntfRemainLive
		syscall
		li $v0,1
		move $a0,$t4
		syscall
		#Xuat xuong dong
		li $v0, 4 	
		la $a0, downLine	
		syscall 

		#Dua lai gia tri ve Ram
		sw $t4,Life
		
		#Xuat chuoi outputstr
		li $v0, 4 	
		move $a0, $t3	
		syscall 
		
		#Xuat xuong dong
		li $v0, 4 	
		la $a0, downLine	
		syscall 
		j Condi

	Win:
		# Thong bao so mang con lai
		li $v0,4
		la $a0,ntfRemainLive
		syscall
		li $v0,1
		move $a0,$t4
		syscall
		#Xuat xuong dong
		li $v0, 4 	
		la $a0, downLine	
		syscall 

		li $v0, 4 	
		la $a0, Warning
		syscall 

		#Xuat chuoi outputstr
		li $v0, 4 	
		move $a0, $t3	
		syscall 

		#Xuat xuong dong
		li $v0, 4 	
		la $a0, downLine	
		syscall 
		j Condi

OutLost:
	#Xuat thong bao thua
	li $v0, 4 	
	la $a0, outputLost	
	syscall 

	li $v0, 10	
	syscall 
	j End
OutWin:
	#Xuat thong bao thang
	li $v0, 4 	
	la $a0, outputWin	
	syscall 

	li $v0, 10	
	syscall
	j End
End:
	# CUoi thu tuc
	lw $ra,($sp)
	lw $t0,4($sp)
	lw $t1,8($sp)
	lw $t2,12($sp)
	lw $t3,16($sp)
	lw $t4,20($sp)
	lw $t5,24($sp)
	lw $t6,28($sp)
	lw $t7,32($sp)
	lw $s0,36($sp)
	lw $s1,40($sp)
	addi $sp,$sp,64
	jr $ra

# Nhap dang chuoi
_GuessString:
	#Nhap chuoi
	li $v0,4
	la $a0,inputGuessString
	syscall
	li $v0,8
	la $a0,strCheck
	la $a1,100
	syscall


	#Tham so vao ham
	la $a0,strCheck#Chuoi nhap
	la $a1,Word #Chuoi dap an
	la $a2,SizeWord #size de
	#Goi ham kiem tra
	jal _KiemTraCaChuoi
	#Nhan kq tra ve roi dua vao t1
	move $t1,$v0
	#xuat kq
	beq $t1,1,_OutWin.String
	j _OutLost.String
_OutWin.String:
	li $v0,4
	la $a0,outputWin	
	syscall

	li $v0,10
	syscall
_OutLost.String:
	li $v0,4
	la $a0,outputLost	
	syscall

	li $v0,10
	syscall


#----- Ham kiem tra ca chuoi dap an -----#
_KiemTraCaChuoi:
#Dau thu tuc
	addi $sp,$sp,-32 #Khai bao stack

	sw $ra,($sp) #Luu tru so dong de quay tro lai
	sw $t0,4($sp) 
	sw $t1,8($sp)
	sw $t2,12($sp)
	sw $s0,16($sp)
	sw $s1,20($sp)
	sw $s2,24($sp)
	sw $s3,28($sp)

#Than thu tuc
	#Lay dia chi chuoi nhap - dung lay size
	move $s0,$a0
	#Lay dia chi chuoi nhap 
	move $s1,$a0
	#Lay dia chi chuoi de
	move $s2,$a1
	#Lay size
	lw $s3,($a2)
	
	#Tao bien dem so luog ky tu cua chuoi nhap
	li $t0,0

_KiemTraCaChuoi.Lap:
	#Doc 1 ky tu
	lb $t1,($s0)
	#KT neu ky tu !=\n thi tang dem
	bne $t1,'\n',_KiemTraCaChuoi.TangDem
	j _KiemTraCaChuoi.KiemTraSize

_KiemTraCaChuoi.TangDem:
	addi $t0,$t0,1 #tang dem
	addi $s0,$s0,1 #tang dia chi
	j _KiemTraCaChuoi.Lap

_KiemTraCaChuoi.KiemTraSize:
	beq $t0,$s3,_KiemTraCaChuoi.KhoiTaoDem
	j _KiemTraCaChuoi.KhongBang

_KiemTraCaChuoi.KhoiTaoDem:
	#Tao bien dem so luog ky tu cua chuoi nhap
	li $t0,0
	j _KiemTraCaChuoi.KTCaChuoi

_KiemTraCaChuoi.KTCaChuoi:
	lb $t1,($s1)
	lb $t2,($s2)	
	bne $t1,$t2,_KiemTraCaChuoi.KhongBang
		
	#tang dem
	addi $t0,$t0,1
	#tang dia chi 2 chuoi
	addi $s1,$s1,1
	addi $s2,$s2,1
	
	blt $t0,$s3,_KiemTraCaChuoi.KTCaChuoi
	j _KiemTraCaChuoi.Bang

_KiemTraCaChuoi.Bang:
	li $v0,1
	j _KiemTraCaChuoi.KetThuc
_KiemTraCaChuoi.KhongBang:
	li $v0,0
	j _KiemTraCaChuoi.KetThuc

 _KiemTraCaChuoi.KetThuc:
#Cuoi thu tuc
	#restore thanh ghi
	lw $ra,($sp) #Luu tru so dong de quay tro lai
	lw $t0,4($sp) 
	lw $t1,8($sp)
	lw $t2,12($sp)
	lw $s0,16($sp)
	lw $s1,20($sp)
	lw $s2,24($sp)
	lw $s3,28($sp)


	#xoa vung nho stack
	addi $sp,$sp,32
	#tra ve
	jr $ra

#----- Ham lay size cua dap an -----#
_GetSize:
# dau thu tuc
	addi $sp, $sp, -64
	sw $ra, ($sp)
	sw $s0, 4($sp)#	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $t0, 28($sp)
	sb $t1, 32($sp)
	sw $t2, 36($sp)
	# luu dia chi cua hai chuoi
	move $s0, $a0 # dia chi cua words
	move $s1, $a1 # luu gia tri cua SizeString
	move $s2, $a2 # dia chi cua n
#than thu tuc
	#khoi tao bien dem cho words
	addi $t0, $t0, 0
	#khoi tao bien dem so luong tu
	lw $t2, ($s2)
_GetSize.Lap:
	beq $t0, $s1, _GetSize.End
	lb $t1, ($s0)
	#tang bien dem len
	addi $t0, $t0, 1
	#tang dia chi len
	addi $s0, $s0, 1
	#kiem tra co bang *
	
	
	
	bne $t1, '*', _GetSize.Lap
	addi $t2, $t2, 1
	blt $t0, $s1, _GetSize.Lap
_GetSize.End:
	addi $t2, $t2, 1
	sw $t2, ($s2)
#cuoi thu tuc
	lw $ra, ($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $t0, 28($sp)
	lb $t1, 32($sp)
	lw $t2, 36($sp)
	addi $sp, $sp, 64
	jr $ra

#----- Ham lay dap an tu file -----#
_Getword:
# dau thu tuc
	# kiem tra xem
	addi $sp, $sp, -64
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	sw $t0, 28($sp)
	sw $t1, 32($sp)
	sw $t2, 36($sp)
	sw $t3, 40($sp)
	sb $t4, 44($sp)
	sw $t5, 48($sp)
	sb $t6, 52($sp)
	sb $t7, 56($sp)
	# luu dia chi cua hai chuoi
	move $s0, $a0 # dia chi cua words
	move $s1, $a1 # luu gia tri cua SizeString
	move $s2, $a2 # dia chi cua word
	move $s3, $a3 # luu gia tri cua MaDe
	move $s4, $a0 # luu dia chi cua words cho lan sau
	move $s5, $a1 # luu gia tri cua SizeString mot lan nua
#than thu tuc
	#khoi tao bien dem dau cho word
	addi $t0, $t0, 0
	#khoi tao bien dem cho words
	addi $t1, $t1, 0
	#khoi tao bien dem vi tri cua word
	addi $t2, $t2, 0
	# tim so tu
	move $a0, $s0
	move $a1, $s1
	la $a2, sl
	jal _GetSize
	#luu so luong tu vao
	lw $t3, sl
_Getword.Lap:
	#kiem tra den cuoi chuoi
#	beq $s1, $t1, _Getword.Next
	# luu ky tu
	lb $t4, ($s0)
	# tang bien dem
	addi $t1, $t1, 1
	#kiem tra den cuoi chuoi
	beq $t1, $s5, _Getword.Next

	# tang dia chi
	addi $s0, $s0, 1
	beq $t4, '*', _Getword.Next
	j _Getword.Lap
_Getword.Next:
	addi $t2, $t2, 1
	# kiem tra neu vi tri cua word khac yeu cau
	beq $s3, $t2, _Getword.End1
	sub $t0, $t0, $t0
	add $t0, $t0, $t1
#	addi $t0, $t0, 1
	j _Getword.Lap
_Getword.End1:

	beq $s5, $t1, _Getword.End2
	addi $t1, $t1, -1

_Getword.End2:

	#khoi tao bien dem cho word
	move $t5, $t0
	#khoi tao dia chi ve vi tri can duyet
	add $s4, $s4, $t0
	#luu size  cua word
	sub $t7, $t1, $t0
	sw $t7, SizeWord
_Getword.Lap2:
	lb $t6, ($s4)
	sb $t6, ($s2)
	#tang dia chi string len
	addi $s4, $s4, 1
	#tang dia chi word len
	addi $s2, $s2, 1
	#tang bien dem len
	addi $t5, $t5, 1
	#kiem tra xem i < n
	blt $t5, $t1, _Getword.Lap2
	

#cuoi thu tuc
	lw $ra, ($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $t0, 28($sp)
	lw $t1, 32($sp)
	lw $t2, 36($sp)
	lw $t3, 40($sp)
	lb $t4, 44($sp)
	lw $t5, 48($sp)
	lb $t6, 52 ($sp)
	lb $t7, 56($sp)
	addi $sp, $sp, 64
	jr $ra

#----- Ham khoi tao chuoi ket qua -----#
_CreateOutPutStr:
#Dau thu tuc
	addi $sp,$sp,-24 #Khai bao stack

	sw $ra,($sp) #Luu tru so dong de quay tro lai
	sw $t0,4($sp) 
	sw $t1,8($sp)
	sw $s0,12($sp)
	sw $s1,16($sp)
	sw $s2,20($sp)

#Than thu tuc
	move $s0,$a0 #Lay size de
	la $s1,OutputStr #Lay dia chi mang
	la $s2,UnKnown

	#Khoi tao vong lap
	li $t0,0
	#doc ky tu cua *
	lb $t1,($s2)
	
_CreateOutPutStr.Loop:
	#Luu vao OutputStr
	sb $t1,($s1)
	#Tang dia chi OutputStr
	addi $s1,$s1,1
	#Tang dem
	addi $t0,$t0,1
	
	blt $t0,$s0,_CreateOutPutStr.Loop
	#Gan ky tu ket thuc chuoi
	sb $0,($s1)
	
	
#Cuoi thu tuc
	lw $ra,($sp) #Luu tru so dong de quay tro lai
	lw $t0,4($sp) 
	lw $t1,8($sp)
	lw $s0,12($sp)
	lw $s1,16($sp)
	lw $s2,20($sp)

	addi $sp,$sp,24 #Giai Phong Stack
	jr $ra


#----- Ham kiem tra ten nguoi choi theo dieu kien cho truoc -----#
_CheckName:
#Dau thu tuc
	addi $sp,$sp,-24 #Khai bao stack

	sw $ra,($sp) #Luu tru so dong de quay tro lai
	sw $t0,4($sp) 
	sw $t1,8($sp)
	sw $s0,12($sp)
	sw $s1,16($sp)
	sw $s2,20($sp)

#Than thu tuc
	























