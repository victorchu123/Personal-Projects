default:
	cc0 hashtable-client.c0 pq-client.c0 stack-client.c0 lib/*.c0 huffman.c0 main-encode.c0 -o encode
	cc0 hashtable-client.c0 pq-client.c0 stack-client.c0 lib/*.c0 huffman.c0 main-decode.c0 -o decode

debug:
	cc0 -d hashtable-client.c0 pq-client.c0 stack-client.c0 lib/*.c0 huffman.c0 main-encode.c0 -o encode
	cc0 -d hashtable-client.c0 pq-client.c0 stack-client.c0 lib/*.c0 huffman.c0 main-decode.c0 -o decode

pack:
	gcc -Wall pack.c -o pack
	gcc -Wall unpack.c -o unpack
