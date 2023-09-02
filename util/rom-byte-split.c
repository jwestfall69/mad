#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/stat.h>

int check_size(uint32_t size);
void usage(void);

int main(int argc, char **argv) {

  FILE *in_fd, *out1_fd, *out2_fd = NULL;
  char *in_data, *out1_data, *out2_data;
  uint32_t in_size, out_size;
  uint32_t out_index, in_index;
  struct stat sb;

  if(argc != 4) {
    usage();
    exit(EXIT_FAILURE);
  }

  if(lstat(argv[1], &sb) == -1) {
    printf("ERROR: Unable to stat file %s\n", argv[1]);
    exit(EXIT_FAILURE);
  }

  in_size = sb.st_size;
  out_size = in_size / 2;

  if(!check_size(in_size)) {
    printf("ERROR: File %s has an invalid size (%d bytes), should be a power of 2\n", argv[1], in_size);
    exit(EXIT_FAILURE);
  }

  if((in_fd = fopen(argv[1], "r")) == NULL) {
    printf("ERROR: Unable to open file %s for reading\n", argv[1]);
    exit(EXIT_FAILURE);
  }

  if((out1_fd = fopen(argv[2], "w")) == NULL) {
    printf("ERROR: Unable to open file %s for writing\n", argv[2]);
    exit(EXIT_FAILURE);
  }

  if((out2_fd = fopen(argv[3], "w")) == NULL) {
    printf("ERROR: Unable to open file %s for writing\n", argv[3]);
    exit(EXIT_FAILURE);
  }

  in_data = malloc(in_size);
  out1_data = malloc(out_size);
  out2_data = malloc(out_size);

  if(in_data == NULL || out1_data == NULL || out2_data == NULL) {
    printf("ERROR: malloc(%d) failed!?\n", in_size);
    exit(EXIT_FAILURE);
  }

  printf("Input ROM: %s (%d bytes)\n", argv[1], in_size);
  printf("Output ROM #1: %s (%d bytes)\n", argv[2], out_size);
  printf("Output ROM #2: %s (%d bytes)\n", argv[3], out_size);

  if(fread(in_data, 1, in_size, in_fd) != in_size) {
    printf("ERROR: fread failed to read %s\n", argv[1]);
    exit(EXIT_FAILURE);
  }
  fclose(in_fd);

  in_index = 0;
  for(out_index = 0; out_index < out_size; out_index++) {
    out1_data[out_index] = in_data[in_index++];
    out2_data[out_index] = in_data[in_index++];
  }

  fwrite(out1_data, 1, out_size, out1_fd);
  fwrite(out2_data, 1, out_size, out2_fd);

  fclose(out1_fd);
  fclose(out2_fd);
}

int check_size(uint32_t size) {
  return ((size & (size - 1)) == 0);
}

void usage(void) {
  printf("Usage: rom-byte-split <input.bin> <output1.bin> <output2.bin>\n");
}
