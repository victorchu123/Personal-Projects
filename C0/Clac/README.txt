Programming 4 (Clac)

Files you won't modify:
   lib/stacks_int.c0     - Stacks containing integers
   lib/queues_string.c0  - Queues containing strings
   lib/tokenize.c0       - Library for populating queues of strings
   clac-main.c0          - Runs clac

Files you will modify:
   clac.c0               - Clac interpreter

Data:
   def/add.clac    - An example program

==========================================================

Compiling and running the Claculator:
   $ cc0 -d -o clac lib/*.c0 clac.c0 clac-main.c0

Running interactively:
   $ ./clac

Running on a file:
   $ ./clac def/add.clac

==========================================================

To handin, copy 
- clac.c0  
- poly1.clac [Task 2]
- poly2.clac [Bonus Task 3]
to your handin directory on WesFiles

