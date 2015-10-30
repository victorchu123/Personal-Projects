Programming 8 (Editor)

Files you won't modify:
   tbuf-test.c0   - Tester for text buffers
   lovas-E0.c0    - The E0 text editor implementation

Files you will modify:
   gapbuf.c0 - Copy your solution to Gap Buffer here

   dll_pt.c0 - Copy your solution to DLL here

   tbuf.c0 - Text buffers

Data:
   expected.txt - Expected output from running tbuf-test.c0

==========================================================

Testing in coin
  % coin -d gapbuf.c0 dll_pt.c0 tbuf.c0 

Compiling and running the tbuf tests:
   % cc0 -d -o tbuf-test gapbuf.c0 dll_pt.c0 tbuf.c0 visuals.c0 tbuf-test.c0
   % ./tbuf-test
   START <--> _[................]_ <--> END
   'a': START <--> _a[...............]_ <--> END
   ...
   
Compiling and running the E0 editor:
   % cc0 -d -o E0 gapbuf.c0 dll_pt.c0 tbuf.c0 lovas-E0.c0
   % ./E0

==========================================================

Submitting: 
   Copy tbuf.c0 to your handin directory on WesFiles
