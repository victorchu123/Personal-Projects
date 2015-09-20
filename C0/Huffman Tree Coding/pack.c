#include <stdlib.h>
#include <stdio.h>
#include <string.h>

// input file format:
// sequence of 1's and 0's, terminated by a 2
// all other characters are ignored.

// output file format:
// first byte is the number of bits to read from the last byte
// rest of file is bytes encoding the 0s and 1s

int main(int argc, char** argv) {
  
  if (argc != 2) {
    printf("usage: pack <bitfile>\n file should be a sequence of 0s and 1s terminated by a 2\n any other character is ignored\n");
    return -1;
  }

  char* infilename = argv[1];
  char* outfilename = malloc(sizeof(char) * strlen(infilename) + 5);
  strcpy(outfilename, infilename);
  strcat(outfilename, ".pack");

  FILE* input = fopen(infilename, "r");
  if (input == NULL) {
    printf("input file doesn't exist\n");
    return -1;
  }

  // count bits mod 8
  int num_bits_mod_eight = 0;
  {
    char cur_bit = '\0';
    while (cur_bit != '2') {
      cur_bit = fgetc(input);
      if (cur_bit == '0' || cur_bit == '1') {
        num_bits_mod_eight = (num_bits_mod_eight + 1) % 8;
      }
      // otherwise ignore
    }
    fclose(input);
    input = fopen(infilename,"r");
  }

  FILE* output = fopen(outfilename,"w");
  if (output == NULL) {
    printf("output file couldn't be opened\n");
    return -1;
  }

  // read 8 (not 0!) bits from the last byte if num bits is divisible by 8
  // otherwise it's the number mod 8
  fprintf(output,"%c",(num_bits_mod_eight == 0 ? 8 : num_bits_mod_eight));

  char cur_bit;
  int cur_byte_pos = 0;
  int cur_byte = 0;

  while (cur_bit != '2') {
    cur_bit = fgetc(input);
    
    if (cur_bit == '0' || cur_bit == '1') {

      if (cur_bit == '1') {
        cur_byte = cur_byte + (1 << cur_byte_pos);
      }

      if (cur_byte_pos == 7) {
        fwrite(&cur_byte,sizeof(char),1,output);
        cur_byte = 0;
        cur_byte_pos = 0;
      }
      else {
        cur_byte_pos = cur_byte_pos + 1;
      }
    }
    else {
      // ignore any other character, including the newlines produced by encode
    }
  }

  if (cur_byte_pos != 0) {
    // FIXME decode this to trailing 0's
    fwrite(&cur_byte,sizeof(char),1,output);
  }

  return 0;
}
