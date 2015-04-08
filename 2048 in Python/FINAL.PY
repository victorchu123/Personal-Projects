import random

# initializes the 2048 board based on user input size
def init():
    n = input("Enter board size : ")
    board = []
    print ""

    for i in range(n):
        board.append([])
    for i in range(n):
        for j in range(n):
            board[i].append(0)
    return board

# prints the 2048 board using lists
def print_board(board):
    s = 0
    for i in range(len(board)):
        for j in range(len(board)):
         if s<board[i][j]:
             s = board[i][j]
    z = len(str(s))
    print ("---"+z*"-")*len(board)
    for i in range(0,len(board)):
         s = "|"
         for j in range(0,len(board[i])):
             if board[i][j] !=0:
                 k = str(board[i][j])
                 s = s + " " + k +" "*(z-len(k)) + " |"
             else:
                 s = s + "  "+" "*(z) + "|"                
         print ("|"+"  " + " "*z)*(len(board)+1)
         print s
         print ("|"+"  " + " "*z)*(len(board)+1)
         print ("---"+z*"-")*len(board)
    print ""
    return

# left add action
def left_add (board,points):
    
    for i in range(len(board)):
        for i2 in range((len(board)-1)):
            if board[i][i2] == board[i][i2+1]:
                board[i][i2] = int(board[i][i2]) + int(board[i][i2+1])
                board[i][i2+1] = 0
                points = points + board[i][i2]
                
    return (board, points)

# right add action
def right_add(board,points):


    for i in range(len(board)):
        for i2 in range((len(board)-1),0,-1):
            if board[i][i2-1] == board[i][i2]:
                board[i][i2] = int(board[i][i2-1]) + int(board[i][i2])
                board[i][i2-1] = 0
                points = points + board[i][i2]
           
    return (board, points)
            
# up add action
def up_add(board,points):
 
    for i2 in range((len(board))):
        for i in range((len(board) -1)):
            if board[i][i2] == board[i+1][i2]:
                board[i][i2] = int(board[i][i2]) + int(board[i+1][i2])
                board[i+1][i2] = 0
                points = points + board[i][i2]            

    return (board, points)

# down add action
def down_add(board,points):
   
    for i2 in range((len(board))):
        for i in range((len(board) -1), 0 ,-1):
            if board[i-1][i2] == board[i][i2]:
                board[i][i2] = int(board[i][i2]) + int(board[i-1][i2])
                board[i-1][i2] = 0
                points = points + board[i][i2]

    return (board, points)

# general add action; calls functions based on direction;
# adds ints if there are the same ints in the same row or column.
# directions determine what is added. refer to 2048 rules.
def add(board, d,points):
    if d == "l":
        (board, points) = left_add(board,points)
        return (board, points)
    if d =="r":
        (board, points) = right_add(board,points)
        return (board, points)
    if d == "u":
        (board, points) = up_add(board,points)
        return (board, points)
    if d == "d":
        (board,points) =down_add(board,points)
        return (board, points)

# left shift action
def left_shift (board):
    ind = 0
    while ind < len(board):
        for i in range((len(board))):
            for i2 in range(len(board)-1):
                store = "undefined"
                if (board[i][i2] == 0):
                    store = int(board[i][i2])
                    board[i][i2] = board[i][i2+1]
                    board[i][i2+1] = store

        ind = ind + 1
        
    return board
    
# right shift action
def right_shift(board):
    ind = 0
    while ind < len(board):
        for i in range((len(board))):
            for i2 in range((len(board)-1),0,-1):
                store = "undefined"
                if board[i][i2] == 0:
                    store = int(board[i][i2])
                    board[i][i2] = board[i][i2-1]
                    board[i][i2-1] = (store)
        ind = ind + 1
        
    return board

# up shift action
def up_shift(board):
    ind = 0
    while ind < len(board):
        for i2 in range((len(board))):
            for i in range((len(board) - 1)):
                store = "undefined"
                if board[i][i2] == 0:
                    store = int(board[i+1][i2])
                    board[i+1][i2] = board[i][i2]
                    board[i][i2] = (store)
        ind = ind + 1
        
    return board

# down shift action
def down_shift(board):
    ind = 0
    while ind < len(board):
        for i2 in range(len(board)):
            for i in range((len(board)-1)):
                store = "undefined"
                if ((board[i][i2] == 0 and board[i+1][i2]== 0) or (board[i][i2]!= 0 and board[i+1][i2]==0)):
                    store = int(board[i+1][i2])
                    board[i+1][i2] = board[i][i2]
                    board[i][i2] = (store)
        ind = ind + 1
    return board

# general shift action; calls functions based on direction;
# shifts ints if there are the same ints in the same row or column.
# directions determine what is added. refer to 2048 rules.
def shift(board, d):
    if d == "l":
        left_shift(board)
        return board
    if d =="r":
        right_shift(board)
        return board
    if d == "u":
        up_shift(board)
        return board
    if d == "d":
        down_shift(board)
        return board

# checks the case for a win based on 2048 requirements; 
# ex. one case is when board is has an int 2048
def win(board,maxi):
    count = 0
    for i in range(len(board)):
        for i2 in range(len(board)):
            if board[i2][i] == maxi:
                count = count + 1
    if (count > 0):
        return True
    else:
        return False
            
# checks the case for a loss based on 2048 requirements; 
# ex. one case is when board is full and no possible 
# moves left
def lose(board):
    count = 0
    true = 0

    for i in range(len(board)):
        for i2 in range(len(board)):
            if board[i2][i] == 0:
                count = count + 1

    for i in range(len(board)):
        for i2 in range((len(board)-1)):
            if board[i][i2] == board[i][i2+1]:
                true = true + 1

    for i in range(len(board)):
        for i2 in range((len(board)-1),0,-1):
            if board[i][i2-1] == board[i][i2]:
                true = true + 1

    for i2 in range((len(board))):
        for i in range((len(board) -1)):
            if board[i][i2] == board[i+1][i2]:
                true = true + 1

    for i2 in range((len(board))):
        for i in range((len(board) -1), 0 ,-1):
            if board[i-1][i2] == board[i][i2]:
                true = true + 1
    
    if ((count > 0) or (true > 0)):
        return False

    elif (true == 0):
        return True

# generates random number for the new generated number
# ex. one random number pops up on the board as part
# of 2048 rules
def randomgen(board,mini,maxi):
    L1 = []
    L2 = []

    for z in range(len(board)):
        for i in range(len(board)):
            if board[i][z] == 0:
                L1.append([i,z])

    if L1 != []:
        x = random.randint(0,len(L1)-1)
        board[L1[x][0]][L1[x][1]] = mini

#main interface; keeps track of wins/losses, points, and actions
def main ():
    turn = 0
    points = 0
    board = init()
    mini= input("Enter the minimum value:")
    maxi= input("Enter the maximum value:")

    while (win(board,maxi)== False and lose(board)== False):
        d = "undefined"
        turn = turn + 1
        randomgen(board,mini,maxi)

        while (d != "l" and d != "r" and d != "u" and d != "d" ):
            if (win(board,maxi)== False and lose(board)== False):
                print "TURN:",turn
                print "YOUR SCORE:", points
                print_board(board)
                d = raw_input("Enter direction [right(r), left(l), up(u), down(d)]:")
                if (d != "l" and d != "r" and d != "u" and d != "d"):
                    print "Invalid direction!"
            else:
                d = "l"
                break

        j = shift(board,d)
        (board, points) =add(board,d,points)
        board = shift(board,d)

    if (win(board,maxi) == True and lose(board) == False):
        print "You win!"
        print_board(board)

    if (lose(board) == True and win(board,maxi)== False):
        print "You lose!"
        print_board(board)

    print "Bye!"

main()
