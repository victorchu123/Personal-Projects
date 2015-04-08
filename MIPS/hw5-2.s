# Author: Joseph Koshakow, Lee Wolfowitz, Victor Chu
# Creation date: 10/28/14
# Hw5


 #Define data to be used in the ".data" section.

	.data

prompt:    .asciiz "\n Command:"        #input prompt
end:    .asciiz "\n Good-bye!: "  		#exit prompt
prints:    .asciiz ", "					#space and comma for print
sizes:    .asciiz "Size of list = "		#size string
errorMsg: .asciiz "Invalid Command! Try again!" #error msg

array:		.space	400			#array that number of lists will be stored in

.text

#$s0 has array size
#$s1 has the array address
#$s2 contains 1 if you want to print index, and 0 if you don't

		
main:
		li    $v0, 4     #Prompt user for input
        la    $a0, prompt
        syscall
        li    $v0, 5            #Read n from console
        syscall
        add   $t0, $v0, $zero   #store copy of input (n) in $t0
		addi  $s0, $zero, 0		#store initial size (0) in $s0
		la    $s1, array		#stores the array address in $s1
		addi  $t1, $zero, 40	#store 40 in $t1
		addi  $t2, $zero, 50	#store 50 in $t2
		addi  $t3, $zero, 60	#store 60 in $t3
		addi  $t4, $zero, 20	#store 20 in $t4
		addi  $t5, $zero, 30	#store 30 in $t5
		addi  $t6, $zero, 10	#store 10 in $t6
		beq   $t0, $t1, size	#if input is 40 go to size
		beq   $t0, $t2, print	#if input is 50 go to print
		beq   $t0, $t3, quit	#if input is 60 go to quit
		rem   $t7, $t0, $t6		#store n mod 10 in $t7 for function calls
		addi  $a1, $t7, 0		#store n mod 10 in $a1
		blt   $t0, $t6, error   #if n<10 go to error
		blt   $t0, $t4, insert  #if n<20 (i.e. 10<=n<20) go to insert
		blt   $t0, $t5, delete	#if n<30 (i.e. 20<=n<30) go to delete
		blt   $t0, $t1, finde	#if n<40 (i.e. 30<=n<40) go to finde
		j     main				#jump to main

error: 
		li    $v0, 4           #print errormsg
	    la    $a0, errorMsg
	    syscall
	    j 	  submain 		   #jump to submain



finde:	addi  $a2, $zero, 0		#store 0 in $a2
		addi  $a3, $s0, -1		#store len-1 in $a3
		j     find

submain:
		li    $v0, 4     #Prompt user for input
        la    $a0, prompt
        syscall
        li    $v0, 5            #Read n from console
        syscall
        add   $t0, $v0, $zero   #store copy of input (n) in $t0
		addi  $t1, $zero, 40	#store 40 in $t1
		addi  $t2, $zero, 50	#store 50 in $t2
		addi  $t3, $zero, 60	#store 60 in $t3
		addi  $t4, $zero, 20	#store 20 in $t4
		addi  $t5, $zero, 30	#store 30 in $t5
		addi  $t6, $zero, 10	#store 10 in $t6
		beq   $t0, $t1, size	#if input is 40 go to size
		beq   $t0, $t2, print	#if input is 50 go to print
		beq   $t0, $t3, quit	#if input is 60 go to quit
		rem   $t7, $t0, $t6		#store n mod 10 in $t7 for function calls
		addi  $a1, $t7, 0		#store n mod 10 in $a1
		blt   $t0, $t6, error   #if n<10 go to error
		blt   $t0, $t4, insert  #if n<20 (i.e. 10<=n<20) go to insert
		blt   $t0, $t5, delete	#if n<30 (i.e. 20<=n<30) go to delete
		blt   $t0, $t1, finde	#if n<40 (i.e. 30<=n<40) go to finde
		j     submain
		
		
find:
		bne   $s0, $zero, L0	#if size isn't 0 go to L0
		addi  $v1, $zero, 0		#store 0 in $v1 for return
		li    $v0, 1			#print int syscall
		addi  $a0, $v1, 0		#move result into $a0 to be printed
		syscall
		j     submain			#go back to submain
L0:     add   $t1, $a2, $a3		#store imin+imax in $t1
		addi  $t2, $zero, 2		#store 2 in $t2
		div   $t1, $t2			#store (imin+imax)/2 in $Lo
		mflo  $t1				#store (imin+imax)/2 (mid) in $t1 
		blt   $a3, $a2, dnffinish #if imax<imid finish
		mul   $t2, $t1, 4		#stores 4(mid) in $t2
		add	  $t2, $t2, $s1		#stores the address of mid in $t2
		lw    $t3, 0($t2)		#loads A[mid] into $t3
		bgt   $t3, $a1, L1		#if A[mid] > $a1 go to L1
		blt   $t3, $a1, L2		#if A[mid] < $a1 go to L2
		j     ffinish			#if A[mid] = $a1 then finish

L1:     addi $a3, $t1, -1		#store mid-1 in $a3(imax) for recursive call
		j    find				#recursive call
L2:     addi $a2, $t1, 1		#store mid+1 in $a2(imin) for recursive call
		j    find				#recursive call

ffinish:  
		addi  $v1, $t1, 1		#stores mid+1 in $v1 for return
		mul   $t1, $t1, 4		#stores 4(mid+1) in $t1
		add   $t1, $t1, $s1		#stores the address of mid+1 (i) in $t1
		addi  $t2, $s0, -1		#stores len-1 in $t2
		mul   $t2, $t2, 4		#stores 4(len-1) in $t2
		add  $t2, $t2, $s1		#stores the address of len-1 in $t2
duploop:
		bgt   $t1, $t2, L4		#when i>address of length finish
		lw    $t3, 0($t1)		#load A[i] into $t3
		bne   $t3, $a1, L4		#if A[i] != $a1 finish
		addi  $v1, $v1, 1		#add 1 to $v1
		addi  $t1, $t1, 4		#increase i by 4 (i.e. i+1)
		j     duploop			#go back to duploop
L4:		addi  $v1, $v1, -1		#decrease $v1 by 1
		li    $v0, 1			#print int syscall
		move  $a0, $v1			#move result into $a0 to be printed
		syscall
		j     submain			#go back to submain
dnffinish:
		bne   $a1, $zero, L3	#if $a1 != 0 go to L3
		addi  $v1, $zero, 0		#store 0 in $v1 for return
		j     L5
L3:		addi  $v1, $t1, 1		#store mid+1 in $v1 for return
L5:		li    $v0, 1			#print int syscall
		move  $a0, $v1			#move result into $a0 to be printed
		syscall
		j     submain			#go back to submain

isearch:
		addi $t1, $s1, 0		#store the address of the first element (i) in $t1
		beq  $s0, $zero, isfinish	#if size is zero just insert in first space
		addi $t2, $s0, -1		#stores len-1 in $t2
		mul  $t2, $t2, 4		#stores 4(len-1) in $t2
		add  $t2, $t2, $s1		#stores the address of the last element in $t2
isloop:
		bgt  $t1, $t2, isfinish	#when i>len-1 (address') finish
		lw   $t3, 0($t1)		#load A[i]
		bgt  $t3, $a1, isfinish	#when A[i] > $a1 finish
		addi $t1, $t1, 4		#add 4 to $t1 (i.e. i+1)
		j    isloop
isfinish:
		addi $v1, $t1, 0		#add the address to insert in $v1
		jr   $ra
		
insert:
		jal   isearch				#get the index to insert
		
		addi  $t2, $v1, 0		
		#stores the address of where we should insert into $t2
		beq   $s0, $zero, ifinish	
		#if the array size is zero just insert element
		
		addi  $t3, $s0, -1		#stores len-1 in $t3
		mul   $t4, $t3, 4		#stores 4(len-1) in $t4
		add   $t4, $t4, $s1		#stores the address of len-1 (i) in $t4
iloop:
		blt   $t4, $t2, ifinish	#when i<the address of the index finish
		lw    $t6, 0($t4)		#stores A[i] in $t6
		sw	  $t6, 4($t4)		#stores A[i] in A[i+1]
		addi  $t4, $t4, -4		#decrement i (i-1, i.e. i-4)
		j     iloop				#go back to iloop
ifinish:
		sw    $a1, 0($t2)		#insert the argument into A[index]
		addi  $s0, $s0, 1		#increase size by 1
		j     submain			#go back to submain

delsearch:
		addi $t1, $s1, 0		#store the address of the first element (i) in $t1
		beq  $s0, $zero, nonfinish	#if size is zero return -1
		addi $t2, $s0, -1		#stores len-1 in $t2
		mul  $t2, $t2, 4		#stores 4(len-1) in $t2
		add  $t2, $t2, $s1		#stores the address of the last element in $t2
delsloop:
		bgt  $t1, $t2, nonfinish	#when i>len-1 (address') finish
		lw   $t3, 0($t1)		#load A[i] into $t3
		beq  $t3, $a1, delsfinish	#when A[i] = $a1 finish
		addi $t1, $t1, 4		#add 4 to $t1 (i.e. i+1)
		j    delsloop
nonfinish:
		addi $v1, $zero, -1		#store -1 in $v1 for return
		jr   $ra				#return to caller
delsfinish:
		addi $v1, $t1, 0		#add the address to insert in $v1
		jr   $ra				#return to caller

delete:
		jal  delsearch			#find the index to delete
		addi $t1, $v1, 0		#store address to delete in $t1
		addi $t2, $zero, -1		#store -1 in $t2
		beq  $t1, $t2, submain	#if the element isn't in the list go back to submain
		addi $t4, $s0, -1		#store len-1 in $t4
		mul  $t4, $t4, 4		#store 4(len-1) in $t4
		add  $t4, $t4, $s1		#store the address of the last element in $t4
dloop:
		beq  $t1, $t4, dfinish	#when i = address of the last element finish
		lw   $t5, 4($t1)		#store A[i+1] in $t4
		sw   $t5, 0($t1)		#store A[i+1] in A[i]
		addi $t1, $t1, 4		#add 4 to $t3 (i.e. i+1)
		j    dloop				#go back to dloop
dfinish:
		addi $s0, $s0, -1		#decrease size by 1
		j    submain			#go back to submain

size:
		li    $v0, 4           #Print size string
        la    $a0, sizes
        syscall
		li    $v0, 1			#syscall for print int
		addi  $a0, $s0, 0		#move $s0 (size into $a0)
		syscall
		j     submain			#return to submain

print:
		addi  $t1, $s1, 0		#add the address of first element in $t1(i)
		addi  $t2, $s0, 0		#add the size of the array to $t2
		mul   $t2, $t2, 4		#store 4(size) in $t2
		add   $t2, $t2, $s1		
		#store the address of the index after the last element in $t2
		addi  $t3, $t2, -4		#store address of last element in $t2
ploop:
		beq   $t1, $t2, submain	#when we've gone through entire array go back to submain
		li    $v0, 1			#syscall for print int
		lw    $a0, 0($t1)		#store A[i] into $a0
		syscall
		beq   $t1, $t3, submain	#don't print the ", " after last element
		li    $v0, 4           #Print ", "
        la    $a0, prints
        syscall
		addi  $t1, $t1, 4		#increment i by 4
		j     ploop				#go back to ploop

quit:
		li    $v0, 4           #Print end string
        la    $a0, end
        syscall
		li    $v0, 10          #exit
        syscall