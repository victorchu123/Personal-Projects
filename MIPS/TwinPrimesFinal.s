# Victor Chu
# Lee Wolfowitz
# Minh Truong

.data
    Prime:    .asciiz    " is Prime\n" #message to indicate a prime number"
    NotPrime:    .asciiz " is not prime\n" #message to indicate not a prime number"
    numOfTwinPrimes:     .asciiz "\n First pair of twin primes after 1 million: " #message for end result
    space: .asciiz " " #message for a space
    checkPrime: .asciiz "\n checking for prime: " #message for checking which prime 

.text

main:
    
    li $t8, 1000 #loads 1000 into $t8
    mul $t2, $t8, 1000 # $t2 = 1000 * 1000
    move $t7, $t2 # initializes a counter $t7 = $t2
    mul $s2, $t2, 2 # $s2 = $t2 * 2

loop: 

    beq $t7, $s2, finish # branch to finish when $t7 = $s2
    move $t3, $t6 #moves $t6 value to $t3
    move $t6, $t5 #moves $t5 value into $t6
    move $a0, $t7 #moves $t7 value to $a0
    addi $t7, $t7, 1 #$t7++ 
    j isPrime #jumps to isPrime
    
isPrime:

    li $t4, 2  # loads immediate value 2 into $t4
    beq $a0, 1, notPrime # if n = 1 go to notPrime
    move $s4, $a0

loop2: 
    beq $t4, $a0, prime # branch to prime when $t4 < $a0
    div $a0, $t4 # $a0 % $t4 stored in $HI
    mfhi $t1 # $t1 = $HI 
    beq $t1, 0, notPrime  # branch to notPrime $t1 = 0
    addi $t4, $t4, 1 # $t4 = $t4 + 1 
    j loop2 # jump to loop2

prime: 

    li $t5, 1 # loads immediate value 1 into $t5
    beq $t5, $t3, add1 #branches to add1 when $t5 = $t3
    j loop #jumps to loop

notPrime: 

    li $t5, 0 # loads immediate value 0 into $t5
    j loop #jumps to loop

add1:
    addi $t9, $t9, 1 # $t9++
    j finish #jumps to finish

finish:

    li $v0, 4 #print_string from $v0
    la $a0, numOfTwinPrimes #loads address of numofTwinPrimes into $a0
    syscall
    li $v0, 1 # print_int from $v0
    addi $s4, $s4, -2 # $s4 = $s4 - 2
    move $a0, $s4 # $a0 = $s4
    syscall
    li $v0, 4 #print_string from $v0
    la $a0, space #loads address of numofTwinPrimes into $a0
    syscall
    addi $s5, $s4, 2 # $s5 = $s4    
    li $v0, 1 # print_int from $v0
    move $a0, $s5 # $a0 = $s5
    syscall
    li $v0, 10 #exits 
    syscall