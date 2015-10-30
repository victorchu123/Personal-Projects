
Programming 9 (Compression)

File you will hand in:
   huffman.c0
   sizes.txt [bonus task]

Data structure instantiations:
   hashtable-client.c0
   pq-client.c0
   stack-client.c0

Data structure libraries:
   lib/hashtable.c0
   lib/heaps.c0
   lib/stack.c0

Data:
   freqs/                 - frequency tables
   texts/                 - texts to compress

Files for the extra credit task:
  unpack.c
  pack.c

Files you don't need to look at:
   Makefile               - A short way to compile; just type make
   main-decode.c0         - Main for decoding
   main-encode.c0         - Main for encoding
   other stuff in lib/

==========================================================

To compile your code with contracts on:
   % make debug
   OR
   % cc0 -d hashtable-client.c0 pq-client.c0 stack-client.c0 lib/*.c0 huffman.c0 main-encode.c0 -o encode
   % cc0 -d hashtable-client.c0 pq-client.c0 stack-client.c0 lib/*.c0 huffman.c0 main-decode.c0 -o decode

To compile your code with contracts off:
   % make

   OR

   % cc0 hashtable-client.c0 pq-client.c0 stack-client.c0 lib/*.c0 huffman.c0 main-encode.c0 -o encode
   % cc0 hashtable-client.c0 pq-client.c0 stack-client.c0 lib/*.c0 huffman.c0 main-decode.c0 -o decode


Encoding a file:
   % ./encode -f freqs/<file> -i texts/<file>

Decoding a file:
   % ./decode -f freqs/<file> -i <bitfile>

