#include <stdlib.h>
#include <stdio.h>
#include <string.h>

// input file format: see pack.c

// output file format: 0's and 1's, with some newlines
// because we only have readline in c0

int main(int argc, char** argv) {
  
  if (argc != 2) {
    printf("usage: unpack <binary file>\n result file will be a sequence of 0s and 1s\n with some newlines put in\n");
    return -1;
  }

  char* infilename = argv[1];
  char* outfilename = malloc(sizeof(char) * strlen(infilename) + 7);
  strcpy(outfilename, infilename);
  strcat(outfilename, ".unpack");

  FILE* input = fopen(infilename, "r");
  if (input == NULL) {
    printf("input file doesn't exist\n");
    return -1;
  }

  FILE* output = fopen(outfilename,"w");
  if (output == NULL) {
    printf("output file couldn't be opened\n");
    return -1;
  }

  // number of bits to read from the last byte is stored in the first byte of the file
  int last_byte_bits = 0;
  fread(&last_byte_bits, sizeof(char), 1, input);

  int times = 0;
  int next_byte = 0; // next_byte is the one whose result is eof_if_zero
  int eof_if_zero = fread(&next_byte, sizeof(char), 1, input);

  while (eof_if_zero != 0) {
    
    // we need to read one ahead to know if we're on the last one

    int cur_byte = next_byte;
    eof_if_zero = fread(&next_byte, sizeof(char), 1, input);

    {
      // extract last_byte_bits bits if cur_byte is the last byte
      // or 8 otherwise
      int i;
      for (i = 0; i < ((eof_if_zero == 0) ? last_byte_bits : 8); i++) {
        int bit = (cur_byte >> i) & 0x00000001;
        fprintf(output,"%c", (bit == 1 ? '1' : '0'));
      }
    }

    // print some newlines

    if (times == 20) {
      fprintf(output,"\n");
      times = 0;
    }
    else {
      times++;
    }
  }

  fprintf(output,"\n");

  return 0;
}
