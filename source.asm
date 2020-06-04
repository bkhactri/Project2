.data

#---- Cho nay danh luu thong tin nguoi choi -----#

	inputNamePlayer: .asciiz "Nhap ten cua ban: "
	outputWelcome1: .asciiz "      Chao mung "
	outputWelcome2: .asciiz " den voi HangMan.\n     *** Hay co giu lay mang song ***\n"
	inputAgain: .asciiz "Ten dang nhap khong dung. Vui long nhap lai!!!\n"
	Name: .space 100
	WinCount: .word 0
	Score: .word 0
	Status : .word 0

#---- Day la du lieu de ve cai truong hop doan sai -------#

	# Gia do phia tren
	shelfTop: .asciiz "\n                    _\n                  /_/|\n                  | |+-----o\n"
	# Gia do phia duoi
	shelfBot: .asciiz "            / \\   | ||  /|\n           /      |_|/ / /\n          /___________/ /\n          |___________|/\n"
	# Day treo
	rope:      .asciiz "                  | ||     |\n"
	# Khong co day treo
	notrope:   .asciiz "                  | ||      \n"
	# Dau nguoi
	headMan:   .asciiz "                  | ||     O\n"
	# Than nguoi
	bodyMan1:  .asciiz "             O/o  | ||     |   \n"
	bodyMan2:  .asciiz "             O/o  | ||    /|   \n"
	bodyMan3:  .asciiz "             O/o  | ||    /|\\ \n"
	# Chan nguoi
	legMan1:   .asciiz "            /|___\\| ||___ /    \n"
	legMan2:   .asciiz "            /|___\\| ||___ / \\ \n"
	# Khong hien thi nguoi
	notMan1:   .asciiz "                  | ||          \n"
	notMan2:   .asciiz "             O/o  | ||          \n"
	notMan3:   .asciiz "            /|___\\| ||___      \n"
	frame: .asciiz "==========================================\n"


#----- Day la phan danh cho xu ly game -----------#

	Game: .asciiz "           _-^-_ HANGMAN _-^-_" 
	inputChoose: .asciiz "  ==  Lua chon cach doan cua ban  ==\n1. Doan ki tu \n2. Doan chuoi \nLua chon cua ban: "
	StartWarning: .asciiz "\nTU KHOA DANH CHO BAN LA: "
	Warning : .asciiz "\nCAP NHAT TU KHOA : "
	Replay : .asciiz "\n1.Choi lai \n2.Thoat \nLua chon cua ban: "
	Result : .asciiz "Thanh tich cua ban (ten-diem-so lan thang): "
	Top: .asciiz "Top 10 nguoi choi : \n"
	TheBest: .asciiz "Ban da chien thang tro choi \n"
	GuessTrue: .asciiz "\nBan da doan dung"
	# ====> Nhap dang ky tu
	inputGuessChar: .asciiz "Ban doan ky tu la : "
	# ====> Nhap dang chuoi
	inputGuessString: .asciiz "Ban doan dap an la : "

	strCheck:.space 200 #chuoi nhap
	size: .word 0 #size cua chuoi dap an

	outputExist: .asciiz "\nKi tu nay ban da doan roi  \n"
	downLine: .asciiz "\n"
	outputLost: .asciiz "\n       ******** You lost! ********\n\n"
	outputWin: .asciiz"\n       ******** You win! ********\n\n"
	CheckWarning: .asciiz"\nKET QUA:"
	notExist: .asciiz "\nKi tu khong ton tai. Ban mat 1 mang."
	ntfRemainLive: .asciiz "\n<HP>So mang con lai: "
	NULL: .asciiz "\0"

#------ Day la phan luu thong tin ---------#	

	# ====> OutputStr co the thay doi
	UnKnown : .asciiz "*"
	OutputStr: .space 200
	Life: .word 7

#------ Day la phan doc file ---------#	
#--- Phan nay la de ----#
	QuestFile: .asciiz "De.txt"
	PlayerFile: .asciiz "Nguoichoi.txt"
	fileWords: .space 2048
	Word: .space 200 #Trong day chua de
	SizeWord: .word 0 #Trong day chua size cua du lieu
	SizeString: .word 0 
	sl: .word 0
	n: .word 0 #So luong de
	ID: .word 0 #Ma de
	IDExist : .space 400 #Mang de da ra
	IDcount :.word 0 #So luong de da ra
#--- Phan nay la nguoi choi -----#
	sizearr: .word 0
	sizepro: .word 0
	arr: .space 2048
	fileAllName: .space 2048 #Tat ca du lieu cua file nguoichoi.txt
	temp : .space 200 #Trong day chua du lieu tam de xuat top 10

#--- Phan nay la ord diem nguoi choi -----#
	PointArr: .space 500 #Mang diem cua nguoi choi
	IndexArr: .space 500 #Mang vi tri tuong duong voi diem cua nguoi choi
	SizePoints: .word 0 #So luong diem nguoi choi doc duoc
	
	
.text
	.globl main
main:
	#truyen tham so
	la $a0, PlayerFile
	la $a1, fileAllName
	la $a2, sizepro
	#goi ham doc file
	jal _ReadProfile

	# Nhap ten nguoi choi
	jal _NamePlayer	


	# Doc file
	li $v0,13           	# mo file voi syscall 13
    	la $a0,QuestFile 	# dia chi file
    	li $a1,0        	# bat flag len 0 de doc
    	syscall
    	move $s0,$v0        	# luu vao thanh ghi $s0
	
	# luu vao chuoi
	li $v0, 14		# doc file voi syscall 14
	move $a0,$s0		# noi dung file
	la $a1,fileWords  	# chuoi luu tru file
	la $a2,2048		# chieu dai toi da cua chuoi
	syscall
	
	#lay kich thuoc cua chuoi
	sw $v0, SizeString
	
	#dong file
   	li $v0, 16         		
 	move $a0,$s0      		
    	syscall

	# lay so luong tu trong chuoi
	la $a0, fileWords
	lw $a1, SizeString
	la $a2, n
	
	# goi ham lay so luong tu
	jal _GetSize
	
ContinuePlay:
	#Lay ra tong so de va random tu 1 -> n de lay ra ma de
	lw $a1, n
   	li $v0, 42  #random
    	syscall
   	
	addi $a0,$a0,1	

	#luu vao bien ma de
	sw $a0,ID

	#Kiem tra xem da choi ma de nay chua
	la $a0,IDExist
	la $a1,IDcount
	la $a2,ID
	jal _CheckFreq
		
	#Neu trung quay lai random lay ra de moi
	move $t0,$v0
	beq $t0,1,ContinuePlay

	# truyen tham so
	la $a0, fileWords
	lw $a1, SizeString
	la $a2, Word
	lw $a3, ID
	# goi ham lay de
	jal _Getword
	
	# truyen tham so
	lw $a0,SizeWord
	jal _CreateOutPutStr	
	
	#Khung tren
	li $v0,4
	la $a0,frame	
	syscall
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
	la $a0,StartWarning
	syscall
	
	li $v0,4
	la $a0,OutputStr
	syscall

	#Xuat xuong dong
	li $v0, 4 	
	la $a0, downLine	
	syscall 
	
	#Dap an de test ne                           (Test xong xoa cho nay di nha)
	#li $v0, 4 	
	#la $a0, Word	
	#syscall 

	# Ham doan ki tu
	jal _GuessChar
	
	# Choi tiep neu thang
	beq $a2,1,Refresh
	
	# Choi lai hoac thoat
	j EndTurn.RepeatOrNot

Refresh: #Lam sach bo nho
	la $a0,Word
	jal _ClearMemory

	la $a0,strCheck
	jal _ClearMemory

	la $a0,OutputStr
	jal _ClearMemory

	
	lw $t0,n
	lw $t1,IDcount
	beq $t0,$t1,RuleTheGame

	j ContinuePlay


# Cho nay lua chon nhap ki tu hay chuoi
Choose:
	li $v0,4
	la $a0,inputChoose
	syscall

	li $v0,5
	syscall

	move $s5,$v0
	beq $s5,1,_GuessChar.InputChar.Continue
	beq $s5,2,GuessString
	j Choose
# Sai 0 
NumIncorrect_0:
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
	j _GuessChar.Lost.Continue	
# Sai 1	
NumIncorrect_1:
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
	j _GuessChar.Lost.Continue	
# Sai 2
NumIncorrect_2:
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
	j _GuessChar.Lost.Continue	
# Sai 3	
NumIncorrect_3:
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
	j _GuessChar.Lost.Continue	
# Sai 4	
NumIncorrect_4:
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

	j _GuessChar.Lost.Continue	
# Sai 5	
NumIncorrect_5:
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

	j _GuessChar.Lost.Continue		
# Sai 6
NumIncorrect_6:
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
	j _GuessChar.Lost.Continue	
# Sai 7
NumIncorrect_7:
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
	# Hien thi gia do phia duoi
	li $v0,4
	la $a0,shelfBot
	syscall
	j _GuessChar.Condi

# PHAN XU LY GAME DUOI DAY NE #
#----- Ham doan ky tu----#
_GuessChar:
	# Dau thu tuc
	addi $sp,$sp,-44
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
_GuessChar.Condi:	
	#Kiem tra dieu kien chay
	beq $t4,$0,_GuessChar.OutLost
	
	#Kiem tra chien thang
	li $t7,'*' # khoi tao *

	move $t5,$0  # khoi tao bien dem
	j _GuessChar.CheckWinLoop

	_GuessChar.CheckWinLoop:
		beq $t5,$t2,_GuessChar.OutWin
		lb $t6,($t3)

		beq $t6,$t7,_GuessChar.Condi.Next1
		addi $t5,$t5,1
		addi $t3,$t3,1
		j _GuessChar.CheckWinLoop
_GuessChar.Condi.Next1:	
	j Choose
_GuessChar.InputChar.Continue:
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
	j _GuessChar.Condi.LoopFind

	_GuessChar.Condi.LoopFind:
		beq $t5,$t2,_GuessChar.Condi.Out.True
		lb $t6,($t3)	

		beq $t6,$t0,_GuessChar.Condi.Out.False
		addi $t5,$t5,1
		addi $t3,$t3,1
		j _GuessChar.Condi.LoopFind

	_GuessChar.Condi.Out.False:
		sub $t3,$t3,$t5
		#Xuat xuong dong
		li $v0, 4 	
		la $a0, downLine	
		syscall
		#Khung tren
		li $v0,4
		la $a0,frame	
		syscall
		#Xuat thong bao ket qua
		li $v0, 4 	
		la $a0, CheckWarning	
		syscall 
		#Xuat thong bao ton tai
		li $v0, 4 	
		la $a0, outputExist	
		syscall 
		#Xuat xuong dong
		li $v0, 4 	
		la $a0, downLine	
		syscall
		#Khung duoi
		li $v0,4
		la $a0,frame	
		syscall 
		j _GuessChar.Condi

	_GuessChar.Condi.Out.True:
		sub $t3,$t3,$t5

		j _GuessChar.Condi.Next

_GuessChar.Condi.Next:
	#Flag gan bang 0
	move $t7,$0
	#Khoi tao thanh ghi dem = 0
	move $t5,$0
	#$s0 phan tu mang da
	#$s1 phan tu mang doi chung
	#Tim vi tri ki tu nhap vao
	j _GuessChar.FindInArr

	_GuessChar.FindInArr:
		beq $t5, $t2,_GuessChar.FindInArr.Out
		lb $s0,($t1)
		lb $s1,($t3)

		beq $s0,$t0,_GuessChar.FindInArr.ChangeOutputStr
		j _GuessChar.FindInArr.NChangeOutputStr

		_GuessChar.FindInArr.ChangeOutputStr:
			sb $t0,($t3)
			addi $t7,$t7,1
			j _GuessChar.FindInArr.NChangeOutputStr
		_GuessChar.FindInArr.NChangeOutputStr:
			addi $t5,$t5,1
			addi $t3,$t3,1
			addi $t1,$t1,1
			j _GuessChar.FindInArr
	_GuessChar.FindInArr.Out:
		sub $t3,$t3,$t5
		sub $t1,$t1,$t5
		beq $t7,$0,_GuessChar.Lost
		j _GuessChar.Win
	_GuessChar.Lost:
		#so mang tru 1
		addi $t4, $t4, -1
		#Xuat xuong dong
		li $v0, 4 	
		la $a0, downLine	
		syscall
		#Khung tren
		li $v0,4
		la $a0,frame	
		syscall
		#Xuat thong bao ket qua
		li $v0, 4 	
		la $a0, CheckWarning	
		syscall 
		#Xuat thong bao thua
		li $v0, 4 	
		la $a0, notExist	
		syscall 
		# Kiem tra so lan sai va xuat giao dien
		beq $t4, 6, NumIncorrect_1
		beq $t4, 5, NumIncorrect_2
		beq $t4, 4, NumIncorrect_3
		beq $t4, 3, NumIncorrect_4
		beq $t4, 2, NumIncorrect_5
		beq $t4, 1, NumIncorrect_6
		beq $t4, 0, NumIncorrect_7

	_GuessChar.Lost.Continue:
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
		#Xuat thong bao cap nhat chuoi
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
		#Khung duoi
		li $v0,4
		la $a0,frame	
		syscall 
		j _GuessChar.Condi

	_GuessChar.Win:
		#Xuat xuong dong
		li $v0, 4 	
		la $a0, downLine	
		syscall
		#Khung tren
		li $v0,4
		la $a0,frame	
		syscall
		#Xuat thong bao ket qua
		li $v0, 4 	
		la $a0, CheckWarning	
		syscall
		#Xuat thong bao doan sai
		li $v0,4
		la $a0,GuessTrue
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
		#Khung duoi
		li $v0,4
		la $a0,frame	
		syscall
		j _GuessChar.Condi

_GuessChar.OutLost:
	#tham chieu vao ham va kiem tra choi tiep hay khong
	li $t0,0
	sw $t0,Status
	j EndTurn

_GuessChar.OutWin:
	#tham chieu vao ham va kiem tra choi tiep hay khong
	li $t0,1
	sw $t0,Status
	j EndTurn

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
	addi $sp,$sp,44
	jr $ra



#--- Cho nay nhap chuoi de doan roi dua vao ham kiem tra ---#
GuessString:
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
	li $t0,1
	sw $t0,Status
	j EndTurn

_OutLost.String:
	li $t0,0
	sw $t0,Status
	j EndTurn


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
	addi $sp, $sp, -40
	sw $ra, ($sp)
	sw $s0, 4($sp)
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
	li $t0,0
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
	addi $sp, $sp, 40
	jr $ra

#----- Ham lay dap an tu file -----#
_Getword:
# dau thu tuc
	# kiem tra xem
	addi $sp, $sp, -60
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
	move $s3, $a3 # luu gia tri cua ID
	move $s4, $a0 # luu dia chi cua words cho lan sau
	move $s5, $a1 # luu gia tri cua SizeString mot lan nua
#than thu tuc
	#khoi tao bien dem dau cho word
	li $t0,0
	#khoi tao bien dem cho words
	li $t1,0
	#khoi tao bien dem vi tri cua word
	li $t2,0
	# tim so tu
	move $a0, $s0
	move $a1, $s1
	la $a2, sl
	jal _GetSize
	#luu so luong tu vao
	lw $t3, sl

_Getword.Lap:
	# lay ky tu
	lb $t4, ($s0)
	# tang bien dem
	addi $t1, $t1, 1
	#kiem tra den cuoi chuoi
	beq $t1, $s5, _Getword.Next

	# tang dia chi
	addi $s0, $s0, 1
	addi $s6,$s6,1
	beq $t4, '*', _Getword.Next
	j _Getword.Lap

_Getword.Next:
	addi $t2, $t2, 1
	# kiem tra neu vi tri cua word khac yeu cau
	beq $s3, $t2, _Getword.End1
	sub $t0, $t0, $t0
	add $t0, $t0, $t1
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
	addi $sp, $sp, 60
	jr $ra


#----- Ham tao chuoi ket qua -----#
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
	sub $s1,$s1,$t0
	
#Cuoi thu tuc
	lw $ra,($sp) #Luu tru so dong de quay tro lai
	lw $t0,4($sp) 
	lw $t1,8($sp)
	lw $s0,12($sp)
	lw $s1,16($sp)
	lw $s2,20($sp)

	addi $sp,$sp,24 #Giai Phong Stack
	jr $ra

#----- Ham nhap ten nguoi choi va kiem tra -----#
_NamePlayer:
	#Dau thu tuc
	addi $sp,$sp,-60 #Khai bao stack

	sw $ra,($sp) #Luu tru so dong de quay tro lai
	sw $s0,4($sp) 
	sw $s1,8($sp) 	# < ki tu 0
	sw $s2,12($sp)	# > ki tu 9
	sw $s3,16($sp)	# < ki tu A
	sw $s4,20($sp)	# > ki tu Z
	sw $s5,24($sp)	# < ki tu a
	sw $s6,28($sp)	# > ki tu z
	sb $t0,32($sp)	# lay ki tu vi tri i
	sw $t1,36($sp)	# Kiem tra ki tu --> tra ve 0 hoac 1
	sw $t2,40($sp)	# Kiem tra ki tu --> tra ve 0 hoac 1
	sw $t3,44($sp)	# So sanh 
	sw $t4,48($sp)	# Thanh ghi phu
	sw $t5,52($sp)	# Thanh ghi phu
	sw $t6,56($sp)	# Thanh ghi phu
_NamePlayer.Input:
	li $s1, '0'
	addi $t1, $s1, -1
	move $s1, $t1
	li $s2, '9'
	addi $t2, $s2, 1
	move $s2, $t2
	li $s3, 'A'
	addi $t3, $s3, -1
	move $s3, $t3
	li $s4, 'Z'
	addi $t4, $s4, 1
	move $s4, $t4
	li $s5, 'a'
	addi $t5, $s5, -1
	move $s5, $t5
	li $s6, 'z'
	addi $t6, $s6, 1
	move $s6, $t6
	
	#xuat tb1
	li $v0,4
	la $a0,inputNamePlayer
	syscall
	#nhap ten
	li $v0,8
	la $a0,Name
	li $a1,100
	syscall

	li $v0,0
	la $s0,Name
_NamePlayer.Check:
	lb $t0,($s0)
	# Kiem tra vi tri ket thuc
	beq $t0,'\n',_NamePlayer.CheckEnd
	# Kiem tra dau cach
	beq $t0,' ',_NamePlayer.CheckContinue
	# Kiem tra so
	slt $t1,$t0,$s2
	slt $t2,$s1,$t0
	add $t3,$t1,$t2
	beq $t3,2,_NamePlayer.CheckContinue
	# Kiem tra chu hoa
	slt $t1,$t0,$s4
	slt $t2,$s3,$t0
	add $t3,$t1,$t2
	beq $t3,2,_NamePlayer.CheckContinue
	# Kiem tra chu thuong
	slt $t1,$t0,$s6
	slt $t2,$s5,$t0
	add $t3,$t1,$t2
	beq $t3,2,_NamePlayer.CheckContinue
	j _NamePlayer.InputAgain

_NamePlayer.InputAgain:
	li $v0,4
	la $a0,inputAgain
	syscall
	j _NamePlayer.Input

_NamePlayer.CheckContinue:
	addi $s0,$s0,1
	j _NamePlayer.Check

_NamePlayer.CheckEnd:
	li $t0,'\0' 
	sb $t0,($s0)

	li $v0,4
	la $a0,outputWelcome1
	syscall
	
	li $v0,4
	la $a0,Name
	syscall

	li $v0,4
	la $a0,outputWelcome2
	syscall
# Cuoi thu tuc
	lw $ra,($sp) #Luu tru so dong de quay tro lai
	lw $s0,4($sp) 
	lw $s1,8($sp) 	
	lw $s2,12($sp)	
	lw $s3,16($sp)	
	lw $s4,20($sp)	
	lw $s5,24($sp)
	lw $s6,28($sp)
	lb $t0,32($sp)
	lw $t1,36($sp)
	lw $t2,40($sp)
	lw $t3,44($sp)
	lw $t4,48($sp)
	lw $t5,52($sp)
	lw $t6,56($sp)
	addi $sp,$sp,60
	jr $ra


#----- Cho nay xuat thang thua va dieu khien huong ctrinh sau khi ket thuc luot choi -----#
EndTurn:
	lw $t0,Status
	# Tao bien phu kiem tra thang
	addi $a2,$t0,0
	beq $t0,1,EndTurn.Win
	j EndTurn.Lost

EndTurn.Win:
	#Khung tren
	li $v0,4
	la $a0,frame	
	syscall
	#Xuat thong bao thang
	li $v0,4
	la $a0,outputWin	
	syscall
	#Khung duoi
	li $v0,4
	la $a0,frame	
	syscall
	#Cap nhat diem
	lw $t0,SizeWord
	lw $t1,Score
	add $t1,$t1,$t0
	sw $t1,Score
	#Cap nhat so lan thang lien tiep
	lw $t2,WinCount
	addi $t2,$t2,1
	sw $t2,WinCount
	# Load lai de moi
	li $t1,0
	sw $t1,SizeWord
	sw $t1,ID

	j End

RuleTheGame:
	li $v0,4
	la $a0,TheBest
	syscall
	j EndTurn.RepeatOrNot

EndTurn.Lost:
	#Khung tren
	li $v0,4
	la $a0,frame	
	syscall
	#Xuat thong bao thua
	li $v0,4
	la $a0,outputLost	
	syscall
	#Khung duoi
	li $v0,4
	la $a0,frame	
	syscall

	j End

EndTurn.RepeatOrNot:
	#Xuat tb kq
	li $v0,4
	la $a0,Result
	syscall

	#Xuat ten
	li $v0,4
	la $a0,Name
	syscall
	li $v0,11
	la $a0,'-'
	syscall
	#Xuat diem
	li $v0,1
	lw $a0,Score
	syscall
	li $v0,11
	la $a0,'-'
	syscall
	#Xuat so lan thang
	li $v0,1
	lw $a0,WinCount
	syscall

	#truyen tham so vao ham
	la $a0, Name
	lw $a1, Score
	lw $a2, WinCount
	la $a3, arr
	#ham lien ket thong tin nguoi choi
	jal _LinkProfile

	# luu size cua profile
	sw $v0, sizearr

	#truyen tham so
	la $a0, fileAllName
	la $a1, sizepro
	la $a2, arr
	lw $a3, sizearr
	#goi lien ket toan bo danh sach thong tin nguoi choi
	jal _LinkfullProfile


	#truyen tham so
	la $a0, PlayerFile
	la $a1, fileAllName
	lw $a2, sizepro
	#goi ham doc file
	jal _WriteProfile

	
    	# truyen tham so vao ham lay mang diem
	la $a0, fileAllName
	lw $a1, sizepro
	la $a2, PointArr
	la $a3, SizePoints
	# goi ham lay so luong tu
	jal _GetPoint

	#Sort de lay danh sach thu tu giam dan diem 
	la $a0,PointArr
	la $a1,IndexArr
	la $a2,SizePoints
	jal _Sort


	li $v0,11
	la $a0,'\n' 
	syscall
	
	#Xuat top 10 cao diem nhat
	la $a0,IndexArr
	lw $a1,SizePoints
	jal _PrintTopTen

	# Refreshb lai diem va so lan thang lien tiep
	li $t1,0
	sw $t1,Score
	sw $t1,WinCount
	
	#Reset bo nho
	la $a0,Word
	jal _ClearMemory
	#Reset bo nho
	la $a0,strCheck
	jal _ClearMemory
	#Reset bo nho
	la $a0,OutputStr
	jal _ClearMemory

	la $a0,IDExist
	jal _ClearMemory
	#Xuat thong bao choi tiep hay khong
	li $v0,4
	la $a0,Replay	
	syscall	
	#Nhap lua chon
	li $v0,5
	syscall

	
	beq $v0,1,ContinuePlay

	j ExitGame



#----- Ham nay xoa bo nho cua ram ------#
_ClearMemory:
#Dau thu tuc
	addi $sp,$sp,-20 #Khai bao stack
	sw $ra,($sp) #Luu tru so dong de quay tro lai
	sw $t0,4($sp) 
	sw $t1,8($sp)
	sw $t2,12($sp)
	sw $s0,16($sp)
#Than thu tuc
	#Luu dia chi bien can xoa bo nho
	move $s0,$a0
	lb $t0,NULL
	li $t2,0
_ClearMemory.Loop:
	lb $t1,($s0)
	bne $t1,'\0',_ClearMemory.Clear
	j _ClearMemory.End

_ClearMemory.Clear:
	sb $t0,	($s0)
	addi $s0,$s0,1
	addi $t2,$t2,1
	j _ClearMemory.Loop

_ClearMemory.End:
	sub $s0,$s0,$t2
#Cuoi thu tuc
	lw $ra,($sp) #Luu tru so dong de quay tro lai
	lw $t0,4($sp) 
	lw $t1,8($sp)
	lw $t2,12($sp)
	lw $s0,16($sp)
	addi $sp,$sp,20 #Giai Phong Stack
	jr $ra
	

#---- Ham tinh kich thuoc so ----#
_SizeNum:
#dau thu tuc
	addi $sp ,$sp, -32
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $t0, 12($sp)
	sw $t1, 16($sp)
	
#than thuc tuc
	#gan cac gia tri
	move $s0, $a0
	#khoi tao bien dem
	li $t0,0
	#khoi tao bien co gia tri 10
	li $t1,10
_SizeNum.Lap:
	div $s0, $t1
	mflo $s0
	#tang gia tri cua bien dem
	addi $t0, $t0, 1
	bne $s0, 0, _SizeNum.Lap
	move $v0, $t0
#cuoi thu tuc
	lw $ra, ($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $t0, 12($sp)
	lw $t1, 16($sp)
	addi $sp ,$sp, 32
	jr $ra


#---Ham lien ket cac du lieu ghi file thanh dang ten-diem-solanthang-----#
_LinkProfile:
#dau thu tuc
	# dau thu tuc
	addi $sp, $sp, -60
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
	sb $t3, 40($sp)
	sb $t4, 44($sp)
	sb $t5, 48($sp)
	sb $t6, 52($sp)
	sw $t7, 56($sp)
#than thu tuc
	# luu dia chi cua chuoi va mang
	move $s0, $a0 # dia chi cua name
	move $s1, $a1 # gia tri cua score
	move $s2, $a2 # gia tri cua so luot choi
	move $s3, $a3 # dia chi cua thong tin nguoi choi
	#truyen tham so vao ham
	move $a0, $s1
	jal _SizeNum
	#luu so chu so cua score
	move $s4, $v0
	#truyen tham so vao ham
	move $a0, $s2
	jal _SizeNum
	#luu so chu so cua so luot choi
	move $s5, $v0
	# khoi tao bien dem cho name
	li $t0,0
_LinkProfile.Lap:
	#lay gia tri
	lb $t3, ($s0)
	#luu vao thong tin nguoi choi
	sb $t3, ($s3)
	#tang dia chi cua thong tin nguoi choi len
	addi $s3, $s3, 1
	#tang dia chi name len
	addi $s0, $s0, 1
	#tang bien dem len
	addi $t0, $t0, 1
	lb $t4, ($s0)
	bne $t4, '\0', _LinkProfile.Lap
	#khoi tao ki tu - vao thong tin nguoi choi
	li $t5, '-'
	#them ki tu - vao thong tin nguoi choi
	sb $t5, ($s3)
	# tang bien dem len
	addi $t0, $t0, 1
	#khoi tao lai thanh ghi
	sub $t4, $t4, $t4
	#khoi tao dia chi den cuoi score
	add $s3, $s3, $s4
	#khoi tao ben co gia tri 10
	li $t1,10
_LinkProfile.Diem:
	div $s1, $t1
	mflo $s1
	mfhi $t4
	#chuyen ve dang ki tu
	add $t4, $t4, 48
	#gan vao thong tin nguoi choi
	sb $t4, ($s3)
	#giam dia chi cua thong tin nguoi choi xuong
	subi $s3, $s3, 1
	#tang gia tri cua bien dem
	addi $t0, $t0, 1
	bne $s1, 0, _LinkProfile.Diem
	#tang dia chi len dau cua so luot choi
	add $s3, $s3, $s4
	addi $s3, $s3, 1
	#them ki tu - vao thong tin nguoi choi
	sb $t5, ($s3)
	# tang bien dem len
	addi $t0, $t0, 1
	#tang dia chi len dau cua so luot choi
	add $s3, $s3, $s5
_LinkProfile.So:
	div $s2, $t1
	mflo $s2
	mfhi $t4
	#chuyen ve dang ki tu
	add $t4, $t4, 48
	#gan vao thong tin nguoi choi
	sb $t4, ($s3)
	#giam dia chi cua thong tin nguoi choi xuong
	subi $s3, $s3, 1
	#tang gia tri cua bien dem
	addi $t0, $t0, 1
	bne $s2, 0, _LinkProfile.So
	# tra ve size cua profile
	move $v0, $t0
	
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
	lb $t3, 40($sp)
	lb $t4, 44($sp)
	lb $t5, 48($sp)
	lb $t6, 52 ($sp)
	lw $t7, 56($sp)
	addi $sp, $sp, 60
	jr $ra

#---- Ham doc file -----#
_ReadProfile:
# dau thu tuc
	addi $sp, $sp, -16
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
#than thu tuc
	#mo file len
	move $s0, $a0 # luu dia chi chua file nguoi choi
	move $s1, $a1 # dia chi cua string
	move $s2, $a2 # luu gia tri cua size cua string
	
	#doc file danh sach nguoi choi hien tai
	li $v0,13           	# open_file syscall code = 13
    	move $a0, $s0     	# get the file name
    	li $a1,0           	# file flag = read (0)
    	syscall
    	move $s0,$v0        	# save the file descriptor. $s0 = file
	
	#read the file
	li $v0, 14		# read_file syscall code = 14
	move $a0,$s0		# file descriptor
	move $a1, $s1  	# The buffer that holds the string of the WHOLE file
	la $a2,2048		# hardcoded buffer length
	syscall
	#lay size cua string
	sw $v0, ($s2)
	#Close the file
    	li $v0, 16         		# close_file syscall code
   	move $a0,$s0      		# file descriptor to close
    	syscall
#cuoi thu tuc
	lw $ra, ($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addi $sp, $sp, 16
	jr $ra


#---- Ham ghi file ----#
_WriteProfile:
#dau thu tuc
	addi $sp, $sp, -16
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
#than thu tuc
	move $s0, $a0 # luu dia chi chua file nguoi choi
	move $s1, $a1 # dia chi cua string
	move $s2, $a2 # luu gia tri cua size cua string
	#open file 
    	li $v0,13           	# open_file syscall code = 13
   	move $a0, $s0    	# get the file name
   	li $a1,1           	# file flag = write (1)
    	syscall
    	move $s0,$v0        	# save the file descriptor. $s0 = file
	
    	#Write the file
   	li $v0,15		# write_file syscall code = 15
    	move $a0,$s0		# file descriptor
    	move $a1, $s1 		# the string that will be written
    	move $a2, $s2		# length of the toWrite string
    	syscall
    	
	#MUST CLOSE FILE IN ORDER TO UPDATE THE FILE
    	li $v0,16         		# close_file syscall code
    	move $a0,$s0      		# file descriptor to close
    	syscall
#cuoi thu tuc
	lw $ra, ($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addi $sp, $sp, 16
	jr $ra


#--- Ham ket noi du lieu tao thanh du lieu ghi file moi -----#
_LinkfullProfile:
# dau thu tuc
	addi $sp, $sp, -60
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
	sb $t3, 40($sp)
	sb $t4, 44($sp)
	sb $t5, 48($sp)
	sb $t6, 52($sp)
	sw $t7, 56($sp)
#than thu tuc
	# luu dia chi cua chuoi va mang
	move $s0, $a0 # dia chi cua string 
	move $s1, $a1 # dia chi size cua string
	move $s2, $a2 # dia chi cua profile
	move $s3, $a3 # size cua profile
	# lay size cua string
	lw $t1, ($s1)
	#khoi tao bien dem
	li $t0,0
	#tang dia chi ve cuoi cua string
	add $s0, $s0, $t1
	beq $t1, 0,  _LinkfullProfile.Lap
	#khoi tao ky tu *
	li $t3, '*'
	#them * vao string neu string co du lieu
	sb $t3, ($s0)
	#tang size string len
	addi $t1, $t1, 1
	#tang dia chi cua string len
	addi $s0, $s0, 1
_LinkfullProfile.Lap:
	lb $t4, ($s2)
	sb $t4, ($s0)
	#tang dia chi cua profile len
	addi $s2, $s2, 1
	#tang dia chi cua string len
	addi $s0, $s0, 1
	#tang bien dem len
	addi $t0, $t0, 1
	#tang size cua string len
	addi $t1, $t1, 1
	blt $t0, $s3, _LinkfullProfile.Lap
	sw $t1, ($s1)

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
	lb $t3, 40($sp)
	lb $t4, 44($sp)
	lb $t5, 48($sp)
	lb $t6, 52 ($sp)
	lw $t7, 56($sp)
	addi $sp, $sp, 60
	jr $ra

#----- Ham lay tat ca cac diem tu file nguoichoi ----#
_GetPoint:
#dau thu tuc
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
	sw $t7, 56($sp)
	sw $s6, 60($sp)
#than thu tuc
	# luu dia chi cua chuoi va mang
	move $s0, $a0 # dia chi cua words
	move $s1, $a1 # luu gia tri cua SizeString
	move $s2, $a2 # dia chi cua mang diem
	move $s3, $a3 # luu gia trí SizePoints
	move $s4, $a0 # luu dia chi cua words mot lan nua
	

	la $s6,IndexArr
	# khoi tao bien dem
	li $t0,0
	# khoi tao diem dau cua diem
	li $t1,0
	# khoi tao diem cuoi cua diem
	li $t2,0
	# khoi tao bien dem so luong cua diem
	li $t5,0
	# khoi tao bien so can nhan bang 10
	li $t7, 10
_GetPoint.Lap:
	# luu ky tu
	lb $t4, ($s0)
	# tang bien dem len
	addi $t0, $t0, 1
	# tang dia chi len
	addi $s0, $s0, 1
	blt $s1, $t0, _GetPoint.End
	bne $t4, '-', _GetPoint.Lap

	beq $t1, 0, _GetPoint.Next1

	#tra t2 ve 0
	sub $t2,$t2,$t2
	#luu lai vi tri cua cuoi cua diem
	add $t2, $t2, $t0
	subi $t2, $t2, 1
	# tang dia chi len vi tri dau cua diem
	add $s4, $s4, $t1
	# khoi tao bien diem

	li $s5, 0

	# khoi tao bien dem ki tu cua diem
	sub $t3, $t3, $t3

	add $t3, $t3, $t1 
	j _GetPoint.Lap1

_GetPoint.Next1:
	#luu lai vi tri cua dau cua diem
	add $t1, $t1, $t0
	j _GetPoint.Lap
_GetPoint.Lap1:
	#gan ki tu
	lb $t6, ($s4)

	#nhan bien diem voi 10
	mult $s5, $t7
	mflo $s5
	add $s5, $s5, $t6
	subi $s5, $s5, 48
	# tang bien dem len
	addi $t3, $t3, 1
	# tang dia chi len
	addi $s4, $s4, 1
	blt $t3, $t2, _GetPoint.Lap1
	sw $s5, ($s2)
	# tang bien dem so luong diem len
	addi $t5, $t5, 1
	#Luu vao mang index
	sw $t5,($s6)
	#Tang dia chi mang vi tri
	addi $s6,$s6,4
	# tang bien dem dia chi dem len
	addi $s2, $s2, 4
	# ha dia chi ve vi tri cu
	sub $s4, $s4, $t2
	# ha dem diem dau ve vi tri 0
	sub $t1, $t1, $t1
	# ha dem diem cuoi ve vi tri 0
	sub $t2, $t2, $t2
	# ha dem vi tri dem ve 0
	sub $t3, $t3, $t3
	# ha gia tri ve gia tri 0
	sub $s5, $s5, $s5
	j _GetPoint.Lap
_GetPoint.End:
	sw $t5, ($s3)
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
	lw $t7, 56($sp)
	lw $s6, 60($sp)
	addi $sp, $sp, 64
	jr $ra



#=--- Ham Sap Xep diem nguoi choi giam dan ----#
_Sort:
#Dau thu tuc
	addi $sp,$sp,-56 #Khai bao stack

	sw $ra,($sp) #Luu tru so dong de quay tro lai
	sw $t0,4($sp) 
	sw $t1,8($sp)
	sw $t2,12($sp)	
	sw $t3,16($sp)
	sw $t4,20($sp)
	sw $t5,24($sp)	
	sw $t6,28($sp)
	sw $s0,32($sp)
	sw $s1,36($sp)
	sw $s2,40($sp)
	sw $s3,44($sp)
	sw $s4,48($sp)
	sw $s5,52($sp)
	
#Than thu tuc

	#Lay dia chi mang diem
	move $s0,$a0
	#Lay dia chi them 1 lan
	move $s1,$a0

	#Lay dia chi mang index
	move $s4,$a1
	#Lay dia chi them 1 lan
	move $s5,$a1

	#lay gia tri n
	lw $s2,($a2) #n
	lw $s3,($a2) #n-1
	addi $s3,$s3,-1
	
	#Khoi tao bien dem
	li $t0,0 #i
	li $t6,4

_Sort.BigLoop:
	addi $t0,$t0,1
	move $t1,$t0
	addi $t0,$t0,-1
	move $s1,$a0
	move $s5,$a1
	add $s1,$s1,$t6
	add $s5,$s5,$t6
	

_Sort.SmallLoop:
	#Kiem tra neu arr[i] > arr[i+1] thi doi cho
	lw $t3,($s0)
	lw $t4,($s1)
	blt $t3,$t4,_Sort.Swap
	j _Sort.Skip

_Sort.Swap:
	move $t5,$t3 #temp = point[i]
	move $t3,$t4 #point[i]=point[i+1]
	sw $t3,($s0) 
	move $t4,$t5#point[i+1]=temp
	sw $t4,($s1)
	#Doi cho ca index
	lw $t3,($s4)
	lw $t4,($s5)

	move $t5,$t3 #temp = index[i]
	move $t3,$t4 #index[i]=index[i+1]
	sw $t3,($s4) 
	move $t4,$t5#index[i+1]=temp
	sw $t4,($s5)

_Sort.Skip:
	#tang dia chi mang
	addi $s1,$s1,4
	addi $s5,$s5,4
	#tang j
	addi $t1,$t1,1
	#kiem tra i<n tiep tuc lap
	blt $t1,$s2,_Sort.SmallLoop

	#tang dia chi mang
	addi $s0,$s0,4
	addi $s4,$s4,4
	#tang i
	addi $t0,$t0,1
	#tang bo nho dia chi thu i
	addi $t6,$t6,4
	#kiem tra i<n tiep tuc lap
	blt $t0,$s3,_Sort.BigLoop


#Cuoi thu tuc	
	#restore thanh ghi
	lw $ra,($sp) 
	lw $t0,4($sp) 
	lw $t1,8($sp)
	lw $t2,12($sp)	
	lw $t3,16($sp)
	lw $t4,20($sp)
	lw $t5,24($sp)	
	lw $t6,28($sp)
	lw $s0,32($sp)
	lw $s1,36($sp)
	lw $s2,40($sp)
	lw $s3,44($sp)
	lw $s4,48($sp)
	lw $s5,52($sp)
	#xoa vung nho stack
	addi $sp,$sp,56
	#tra ve
	jr $ra


#==== HAM TEST XUAT MANG =====#
#Dau thu tuc
XuatMang:
	addi $sp,$sp,-16 #khai bao stack
	#backup thanh ghi
	sw $ra,($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	sw $t0,12($sp)
#Than thu tuc
	#Lay dia chi mang
	move $s0,$a0
	#Lay gia tri n
	lw $s1,($a1)
	#Khoi tao vong lap
	li $t0,0 # i = 0
XuatMang.Lap:
	#xuat a[i]
	li $v0,1
	lw $a0,($s0)
	syscall
	
	#xuat khoang trang
	li $v0,11
	li $a0,' '
	syscall

	#Tang dia chi mang
	addi $s0,$s0,4
	#Tang i
	addi $t0,$t0,1

	#Kiem tra i < n
	blt $t0,$s1,XuatMang.Lap
#Cuoi thu tuc
	#restore thanh ghi
	lw $ra,($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	lw $t0,12($sp)

	#xoa stack
	addi $sp,$sp,16
	#Tra ve
	jr $ra



#--- Ham lay ten-diem-solanthang cua nguoi choi ----#
_Gettemp:
#Dau thu tuc
	addi $sp,$sp,-16 #khai bao stack
	#backup thanh ghi
	sw $ra,($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	sw $t0,12($sp)	
#Than thu tuc
	move $s0,$a0 #Luu vi tri can lay
	

	la $a0,fileAllName
	lw $a1,sizepro
	la $a2,temp
	move $a3,$s0
	jal _Getword

	#In ra man hinh
	li $v0,4
	la $a0,temp
	syscall

	li $v0,11
	la $a0,'\n'
	syscall

	la $a0,temp
	jal _ClearMemory

#Cuoi thu tuc
	#restore thanh ghi
	lw $ra,($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	lw $t0,12($sp)
	#xoa stack
	addi $sp,$sp,16
	#Tra ve
	jr $ra



#--- Ham in top 10 ----#
_PrintTopTen:
#Dau thu tuc
	addi $sp,$sp,-20 #khai bao stack
	#backup thanh ghi
	sw $ra,($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	sw $t0,12($sp)	
	sw $t1,16($sp)

#Than thu tuc
	move $s0,$a0 #lay dia chi mang index
	move $s1,$a1 #lay so luong nguoi choi da co ghi file
	#Khoi tao vong lap
	li $t0,1
	li $t1,10
	beq $s1,$t1,_PrintTopTen.IsTen
		
	li $v0,4
	la $a0,Top
	syscall

_PrintTopTen.LessThanTen:

	li $v0,1
	move $a0,$t0
	syscall

	li $v0,11
	la $a0,' '
	syscall

	#truyen vi tri can lay ket qua
	lw $a0,($s0)
	#goi ham lay va xuat
	jal _Gettemp

	addi $t0,$t0,1 #tang bien dem
	addi $s0,$s0,4 #tang dia chi mang
	ble $t0,$s1,_PrintTopTen.LessThanTen
	j _PrintTopTen.End

_PrintTopTen.IsTen:

	li $v0,1
	move $a0,$t0
	syscall
	
	li $v0,11
	la $a0,' '
	syscall

	#truyen vi tri can lay ket qua
	lw $a0,($s0)
	#goi ham lay va xuat
	jal _Gettemp
	
	addi $t0,$t0,1 #tang bien dem
	addi $s0,$s0,4 #tang dia chi mang
	ble $t0,$t1,_PrintTopTen.IsTen
	j _PrintTopTen.End

_PrintTopTen.End:
#Cuoi thu tuc
	#restore thanh ghi
	lw $ra,($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	lw $t0,12($sp)
	lw $t1,16($sp)
	#xoa stack
	addi $sp,$sp,20
	#Tra ve
	jr $ra

#--- Ham kiem tra xem xem ma de da xuat hien hay chua ----#
_CheckFreq:
#Dau thu tuc
	addi $sp,$sp,-24 #khai bao stack
	#backup thanh ghi
	sw $ra,($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	sw $s2,12($sp)
	sw $t0,16($sp)	
	sw $t1,20($sp)

#Than thu tuc
	move $s0,$a0 #dia chi mang
	lw $s1,($a1) #so luong ma de ra choi
	lw $s2,($a2) #ID
	
	beq,$s1,0,_CheckFreq.NotExist1#Neu so luong de da ra = 0 thi no chua xuat hien
	#khoi tao vong lap
	li $t0,0

_CheckFreq.Loop:
	lw $t1,($s0)
	beq $s2,$t1,_CheckFreq.Exist #Neu bang thi ton tai
	addi $s0,$s0,4
	addi $t0,$t0,1
	blt $t0,$s1,_CheckFreq.Loop
	j _CheckFreq.NotExist1

_CheckFreq.Exist:
	
	li $v0,1#Ton tai tra ve 1 de kiem tra ben ngoai
	j _CheckFreq.End

_CheckFreq.NotExist1:
	addi $t0,$t0,1 
	sw $t0,($a1)#Cap nhat so luong de da ra
	sw $s2,($s0)#Cap nhat de vao mang de da ra
	li $v0,0#Khong Ton tai tra ve 0 de kiem tra ben ngoai

_CheckFreq.End:
	
#Cuoi thu tuc
	#restore thanh ghi
	lw $ra,($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	lw $s2,12($sp)
	lw $t0,16($sp)	
	lw $t1,20($sp)
	#xoa stack
	addi $sp,$sp,24
	#Tra ve
	jr $ra

#Thoat game
ExitGame:
	li $v0,10
	syscall
