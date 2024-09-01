#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/stat.h>

// negative offsets from end
#define DEFAULT_CRC32_OFFSET        4
#define DEFAULT_MIRROR_OFFSET       5

#define DEFAULT_START_OFFSET        0

#define CRC32_BIG_ENDIAN            0
#define CRC32_LITTLE_ENDIAN         1

int check_size(uint32_t size);
uint32_t crc32_calc(const void *data, size_t n_bytes);
uint32_t crc32_for_byte(uint32_t r);
void usage(void);

int main(int argc, char **argv) {

  FILE *rom = NULL;
  char *data;
  uint32_t crc32;
  uint16_t crc32_offset = DEFAULT_CRC32_OFFSET;
  uint8_t mirror = 0;
  uint16_t mirror_offset = DEFAULT_MIRROR_OFFSET;
  int32_t target_size = -1;
  int32_t opt;
  uint8_t reverse = 0;
  uint32_t start_offset = DEFAULT_START_OFFSET;
  uint32_t start_size = 0;
  struct stat sb;
  int32_t endian = -1;

  while((opt = getopt(argc, argv, "c:e:f:hm:rs:t:")) != -1) {
    switch (opt) {

      case 'c':
          crc32_offset = atoi(optarg);
          break;

      case 'e':
        if(strcmp("big", optarg) == 0) {
          endian = CRC32_BIG_ENDIAN;
        } else if(strcmp("little", optarg) == 0) {
          endian = CRC32_LITTLE_ENDIAN;
        } else {
          printf("ERROR: -e arg must either be \'big\' for big-endian or \'little\' for little-endian\n");
          exit(EXIT_FAILURE);
        }
        break;

      case 'f':
        if(lstat(optarg, &sb) == -1) {
          printf("ERROR: Unable to stat file %s\n", optarg);
          exit(EXIT_FAILURE);
        }

        start_size = sb.st_size;
        if(!check_size(start_size)) {
          printf("ERROR: File %s has an invalid size (%d bytes), must be a power of 2\n", optarg, start_size);
          exit(EXIT_FAILURE);
        }

	if((rom = fopen(optarg, "r+")) == NULL) {
          printf("ERROR: Unable to open file %s\n", optarg);
          exit(EXIT_FAILURE);
        }
        printf("Using ROM: %s\n", optarg);
        break;

      case 'm':
          mirror_offset = atoi(optarg);
          break;

      case 'r':
          reverse = 1;
          break;

      case 't':
        target_size = atoi(optarg);
        if(!check_size(target_size)) {
          printf("ERROR: Target size of %d bytes is invalid, must be a power of 2\n", target_size);
          exit(EXIT_FAILURE);
        }
        break;

      case 's':
        start_offset = atoi(optarg);
        break;

      case 'h':
      default:
        usage();
        exit(EXIT_FAILURE);
        break;
    }
  }

  if(rom == NULL) {
    printf("ERROR: -f <rom file> option is required\n");
    exit(EXIT_FAILURE);
  }

  if(target_size <= 0) {
    printf("ERROR: -t <target_size> option is required\n");
    exit(EXIT_FAILURE);
  }

  if(endian == -1) {
    printf("ERROR: -e <big|little> option is required\n");
    exit(EXIT_FAILURE);
  }

  if(target_size < start_size) {
    printf("ERROR: start_size (%d) is larger then target_size (%d)\n", start_size, target_size);
    exit(EXIT_FAILURE);
  }

  if(start_offset > start_size) {
    printf("ERROR: start_offset (%d) is larger then start_size(%d)\n", start_offset, start_size);
    exit(EXIT_FAILURE);
  }

  data = malloc(target_size);

  if(data == NULL) {
    printf("ERROR: malloc(%d) failed!?\n", target_size);
    exit(EXIT_FAILURE);
  }

  if(fread(data, 1, start_size, rom) != start_size) {
    printf("ERROR: fread error on rom file\n");
    exit(EXIT_FAILURE);
  }

  int32_t offset = start_size;
  while(offset < target_size) {
    memcpy(data + offset, data, start_size);
    offset += start_size;
  }

  printf("Start Size:    0x%x\n", start_size);
  printf("Target Size:   0x%x\n", target_size);
  printf("CRC32 Offset:  0x%02x from end\n", crc32_offset);
  printf("Mirror Offset: 0x%02x from end\n", mirror_offset);

  // don't calc crc of the mirror/crc part of the rom
  crc32 = crc32_calc(data + start_offset, (start_size - start_offset) - mirror_offset);
  printf("CRC32 Range:   0x%x - 0x%x\n", start_offset, start_size - mirror_offset);
  printf("CRC32:         0x%8x\n", crc32);

  if(endian == CRC32_BIG_ENDIAN) {
    crc32 = htobe32(crc32);
  } else {
    crc32 = htole32(crc32);
  }

  // in reverse mode the last copy is the active one
  if(reverse) {
    data[target_size - mirror_offset] = mirror;
    memcpy((data + target_size) - crc32_offset, &crc32, 4);

    offset = target_size - (2 * start_size);

    // fill in mirror numbers in reverse going from low to high
    while(offset >= 0) {
      mirror++;
      data[(start_size + offset) - mirror_offset] = mirror;
      offset -= start_size;
    }

  } else {
    // fill in the first one manaully since crc32 is only in it
    data[start_size - mirror_offset] = mirror;
    memcpy((data + start_size) - crc32_offset, &crc32, 4);

    offset = start_size;

    // fill in mirror numbers
    while(offset < target_size) {
      mirror++;
      data[(start_size + offset) - mirror_offset] = mirror;
      offset += start_size;
    }
  }

  printf("Mirrors:       0x%x\n", mirror);

  rewind(rom);
  fwrite(data, 1, target_size, rom);
  fclose(rom);
}

int check_size(uint32_t size) {
  return ((size & (size - 1)) == 0);
}

uint32_t crc32_for_byte(uint32_t r) {
  for(int j = 0; j < 8; ++j) {
    r = (r & 1? 0: (uint32_t)0xEDB88320L) ^ r >> 1;
  }
  return r ^ (uint32_t)0xFF000000L;
}

uint32_t crc32_calc(const void *data, size_t n_bytes) {
  uint32_t table[256];
  uint32_t crc = 0;

  for(size_t i = 0; i < 256; ++i) {
    table[i] = crc32_for_byte(i);
  }

  for(size_t i = 0; i < n_bytes; ++i) {
    crc = table[(uint8_t)crc ^ ((uint8_t*)data)[i]] ^ crc >> 8;
  }

  return crc;
}

void usage(void) {
  printf("Usage: inject-crc-mirror [options]\n\n");
  printf("options:\n");
  printf("  -f <romfile>               - <romfile> to add crc32/mirror to [required]\n");
  printf("  -t <target_size>           - how large the <romfile> should become [required]\n");
  printf("  -e <big|little>            - use big or little endian when writing crc32 value [required]\n");
  printf("  -r                         - reverse mode, the last copy is the active one in the rom\n");
  printf("  -s <crc32 start offset>    - offset from beginning of rom to start crc32 calc [default: %d]\n", DEFAULT_START_OFFSET);
  printf("  -c <crc32 write offset>    - offset from end of rom of where to write the crc32 data [default: %d]\n", DEFAULT_CRC32_OFFSET);
  printf("  -m <mirror write offset>   - offset from end of rom of where to write the mirror data [default: %d]\n", DEFAULT_MIRROR_OFFSET);
}
