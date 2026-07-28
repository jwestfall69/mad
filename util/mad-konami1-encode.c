#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/stat.h>

#include "mad-konami1-encode.h"

void usage(void);
void encode_range(uint8_t *data, uint16_t address, uint16_t size);

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
  //    rom range      |     cpu address range
  // 0x0000 to 0x0000  |  0xc000 to 0xc000 - not encoded
  // 0x0001 to 0x1fff  |  0xc001 to 0xdfff - mad main code
  // 0x2000 to 0x2fff  |  0xe000 to 0xefff - mad data
  // 0x3000 to 0x3fec  |  0xf000 to 0xffec - mad error address code
  // 0x3fed to 0x3ff1  |  0xffed to 0xfff1 - mirror + crc data
  // 0x3ff2 to 0x3fff  |  0xfff2 to 0xffff - vectors
  printf("Encoding Range 0x0001 - 0x1fff (rom) / 0xc001 - 0xdfff (cpu)\n");
  encode_range(data + 0x0001, 0xc000 + 0x0001, 0x1ffe);
  printf("Encoding Range 0x3000 - 0x3fec (rom) / 0xf000 - 0xffec (cpu)\n");
  encode_range(data + 0x3000, 0xc000 + 0x3000, 0x0fec);

  fwrite(data, 1, rom_size, out_rom);
  fclose(out_rom);
}

uint8_t indexed_size(uint8_t post_byte) {

  uint8_t pbm = post_byte & 0x8f;
  //uint8_t indirect = (post_byte & 0x90) == 0x90;

  switch(pbm) {
    case 0x88:  // (+/- 7 bit offset),R
      return 1;
    case 0x89:  // (+/- 15 bit offset),R
      return 2;
    case 0x8c:  // (+/- 7 bit offset),PC
      return 1;
    case 0x8d:  // (+/- 15 bit offset),PC
      return 2;
    case 0x8f:  // indirect ea
      return 2;
    default:
      return 0;
  }
}

// https://github.com/mamedev/mame/blob/46d53f5c849311953f4b48edb63732264e5d0d38/src/mame/konami/konami1.cpp#L62
uint8_t encode_byte(uint8_t byte, uint16_t address) {
  switch (address & 0xa) {
    default:
    case 0x0: return byte ^ 0x22;
    case 0x2: return byte ^ 0x82;
    case 0x8: return byte ^ 0x28;
    case 0xa: return byte ^ 0x88;
  }
    return byte;
}

void encode_range(uint8_t *data, uint16_t address, uint16_t size) {
  uint16_t offset = 0;
  uint8_t opcode, opcode_ext, opcode_post_byte;
  int8_t opcode_size, oparg_size;

  while(offset < size) {
    opcode = data[offset];
    opcode_ext = data[offset + 1];
    opcode_post_byte = data[offset + 2];
    opcode_size = 2;

    if(opcode == 0x10) {
        oparg_size = m6809_oparg_size_10[opcode_ext].oparg_size;
        if(m6809_oparg_size_10[opcode_ext].is_indexed) {
          oparg_size += indexed_size(opcode_post_byte);
        }
    } else if(opcode == 0x11) {
        oparg_size = m6809_oparg_size_11[opcode_ext].oparg_size;
        if(m6809_oparg_size_10[opcode_ext].is_indexed) {
          oparg_size += indexed_size(opcode_post_byte);
        }
    } else {
        opcode_size = 1;
        oparg_size = m6809_oparg_size_main[opcode].oparg_size;
        if(m6809_oparg_size_main[opcode].is_indexed) {
          oparg_size += indexed_size(opcode_ext);
        }
    }

    if(oparg_size == -1) {
      printf("ERROR: Invalid opcode %02x %02x at 0x%x offset in range\n", opcode, opcode_ext, offset);
      exit(EXIT_FAILURE);
    }

    data[offset] = encode_byte(data[offset], address + offset);
    offset++;

    if(opcode_size == 2) {
      data[offset] = encode_byte(data[offset], address + offset);
      offset++;
    }

    offset += oparg_size;
  }
}

void usage(void) {
  printf("Usage: mad-konami1-encode -i <input.rom> -o <output.rom> [-h]\n");
  printf("options:\n");
  printf("  -h                - this help output\n");
  printf("  -i <input.rom>    - unencoded input mad rom\n");
  printf("  -o <output.rom>   - output file to write encoded rom to\n");
}
