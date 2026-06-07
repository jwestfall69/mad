// Commando encodes the opcodes on the main cpu roms.  opargs and data
// read from the rom are not encoded.
// https://github.com/mamedev/mame/blob/a60cb3f24d392cc9df9aa1ef4840fbab2a655d0b/src/mame/capcom/commando.cpp#L1034

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/stat.h>

#include "z80-opcodes.h"

void usage(void);
void encode_range(uint8_t *start, uint16_t size);

int main(int argc, char **argv) {

  FILE *in_rom = NULL;
  FILE *out_rom = NULL;
  uint8_t *data;
  int32_t opt, rom_size;
  struct stat sb;

  while((opt = getopt(argc, argv, "hi:o:")) != -1) {
    switch (opt) {
      case 'h':
        usage();
        break;

      case 'i':
        if(lstat(optarg, &sb) == -1) {
          printf("ERROR: Unable to stat file %s\n", optarg);
          exit(EXIT_FAILURE);
        }

        rom_size = sb.st_size;
        if((in_rom = fopen(optarg, "r")) == NULL) {
          printf("ERROR: Unable to open input file %s\n", optarg);
          exit(EXIT_FAILURE);
        }
        printf("Using Input ROM: %s (%d bytes)\n", optarg, rom_size);
        break;

      case 'o':
        if((out_rom = fopen(optarg, "w")) == NULL) {
          printf("ERROR: Unable to open output file %s\n", optarg);
          exit(EXIT_FAILURE);
        }
        printf("Using Output ROM: %s\n", optarg);
        break;
    }
  }

  if(in_rom == NULL || out_rom == NULL) {
    printf("ERROR: -i <in.rom> and -o <out.rom> options are required\n");
    exit(EXIT_FAILURE);
  }

  data = (uint8_t *)malloc(rom_size);

  if(data == NULL) {
    printf("ERROR: malloc(%d) failed!?\n", rom_size);
    exit(EXIT_FAILURE);
  }

  if(fread(data, 1, rom_size, in_rom) != rom_size) {
        printf("ERROR: fread error on rom file\n");
    exit(EXIT_FAILURE);
  }
  fclose(in_rom);

  // opcodes need to be encoded, while oparg/data is left as it
  // 0x0000 to 0x0001 - not encoded
  // 0x0002 to 0x2fff - mad main code
  // 0x3000 to 0x5fff - mad data
  // 0x6000 to 0x7ffa - mad error address code
  // 0x7ffb to 0x7fff - mirror + crc data
  printf("Encoding Range 0x0002 - 0x2fff\n");
  encode_range(data + 0x0002, 0x2ffe);
  printf("Encoding Range 0x6000 - 0x7ffa\n");
  encode_range(data + 0x6000, 0x1ffa);

  fwrite(data, 1, rom_size, out_rom);
  fclose(out_rom);
}

void encode_range(uint8_t *start, uint16_t size) {
  uint16_t offset = 0;
  uint8_t opcode, opcode_ext;
  int8_t opcode_size, oparg_size;

  while(offset < size) {
    opcode = start[offset];
    opcode_ext = start[offset + 1];
    opcode_size = 2;

    if(opcode == 0xcb) {
        oparg_size = z80_oparg_size_cb[opcode_ext];
    } else if(opcode == 0xdd) {
        oparg_size = z80_oparg_size_dd[opcode_ext];
    } else if(opcode == 0xed) {
        oparg_size = z80_oparg_size_ed[opcode_ext];
    } else if(opcode == 0xfd) {
        oparg_size = z80_oparg_size_fd[opcode_ext];
    } else {
        opcode_size = 1;
        oparg_size = z80_oparg_size_main[opcode];
    }

    if(oparg_size == -1) {
      printf("ERROR: Invalid opcode %02x %02x at 0x%x offset in range\n", opcode, opcode_ext, offset);
      exit(EXIT_FAILURE);
    }

    start[offset] = (opcode & 0x11) | ((opcode & 0xe0) >> 4) | ((opcode & 0x0e) << 4);
    offset++;

    if(opcode_size == 2) {
      start[offset] = (opcode_ext & 0x11) | ((opcode_ext & 0xe0) >> 4) | ((opcode_ext & 0x0e) << 4);
      offset++;
    }

    offset += oparg_size;
  }
}

void usage(void) {
  printf("Usage: mad-commando-encode -i <input.rom> -o <output.rom> [-h]\n");
  printf("options:\n");
  printf("  -h                - this help output\n");
  printf("  -i <input.rom>    - unencoded input mad rom\n");
  printf("  -o <output.rom>   - output file to write encoded rom to\n");
}
