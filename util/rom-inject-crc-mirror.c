#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/stat.h>

// negative offsets from end
#define DEFAULT_CRC_OFFSET          4
#define DEFAULT_MIRROR_OFFSET       5

#define DEFAULT_START_OFFSET        0

#define CRC_BIG_ENDIAN              0
#define CRC_LITTLE_ENDIAN           1

#define CRC_TYPE_CRC16              0
#define CRC_TYPE_CRC32              1

int check_size(uint32_t size);
uint16_t crc16_calc(const void *data, size_t n_bytes);
uint32_t crc32_calc(const void *data, size_t n_bytes);
uint32_t crc32_for_byte(uint32_t r);
void usage(void);

int main(int argc, char **argv) {

  FILE *rom = NULL;
  char *data;
  uint32_t crc32;
  uint16_t crc16;
  uint16_t crc_offset = DEFAULT_CRC_OFFSET;
  uint8_t crc_type = CRC_TYPE_CRC32;
  uint8_t mirror = 0;
  uint16_t mirror_offset = DEFAULT_MIRROR_OFFSET;
  int32_t target_size = -1;
  int32_t opt;
  uint8_t reverse = 0;
  uint32_t start_offset = DEFAULT_START_OFFSET;
  uint32_t start_size = 0;
  struct stat sb;
  int32_t endian = -1;

  while((opt = getopt(argc, argv, "c:e:f:hm:rs:t:x")) != -1) {
    switch (opt) {

      case 'c':
          crc_offset = atoi(optarg);
          break;

      case 'e':
        if(strcmp("big", optarg) == 0) {
          endian = CRC_BIG_ENDIAN;
        } else if(strcmp("little", optarg) == 0) {
          endian = CRC_LITTLE_ENDIAN;
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

      case 'x':
        crc_type = CRC_TYPE_CRC16;
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
  printf("CRC Offset:    0x%02x from end\n", crc_offset);
  printf("Mirror Offset: 0x%02x from end\n", mirror_offset);


  if(crc_type == CRC_TYPE_CRC32) {
    // don't calc crc of the mirror/crc part of the rom
    crc32 = crc32_calc(data + start_offset, (start_size - start_offset) - mirror_offset);
    printf("CRC32 Range:   0x%x - 0x%x\n", start_offset, start_size - mirror_offset);
    printf("CRC32:         0x%08x\n", crc32);

    if(endian == CRC_BIG_ENDIAN) {
      crc32 = htobe32(crc32);
    } else {
      crc32 = htole32(crc32);
    }
  } else {
    // don't calc crc of the mirror/crc part of the rom
    crc16 = crc16_calc(data + start_offset, (start_size - start_offset) - mirror_offset);
    printf("CRC16 Range:   0x%x - 0x%x\n", start_offset, start_size - mirror_offset);
    printf("CRC16:         0x%04x\n", crc16);

    if(endian == CRC_BIG_ENDIAN) {
      crc16 = htobe16(crc16);
    } else {
      crc16 = htole16(crc16);
    }
  }

  // in reverse mode the last copy is the active one
  if(reverse) {
    data[target_size - mirror_offset] = mirror;

    if(crc_type == CRC_TYPE_CRC32) {
      memcpy((data + target_size) - crc_offset, &crc32, 4);
    } else {
      memcpy((data + target_size) - crc_offset, &crc16, 2);
    }

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

    if(crc_type == CRC_TYPE_CRC32) {
      memcpy((data + start_size) - crc_offset, &crc32, 4);
    } else {
      memcpy((data + start_size) - crc_offset, &crc16, 2);
    }
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

uint16_t crc16_calc(const void *data, size_t n_bytes) {
  uint32_t crc = 0;

  for(int i = 0; i < n_bytes; i++) {
    crc = crc ^ (((uint8_t*)data)[i] << 8);
    for(int i = 0; i < 8; i++) {
      crc = crc << 1;
      if(crc & 0x10000) {
        crc = (crc ^ 0x1021) & 0xFFFF;
      }
    }
  }
  return (uint16_t)crc;
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
  printf("  -s <crc start offset>      - offset from beginning of rom to start crc calc [default: %d]\n", DEFAULT_START_OFFSET);
  printf("  -c <crc write offset>      - offset from end of rom of where to write the crc data [default: %d]\n", DEFAULT_CRC_OFFSET);
  printf("  -m <mirror write offset>   - offset from end of rom of where to write the mirror data [default: %d]\n", DEFAULT_MIRROR_OFFSET);
  printf("  -x                         - use crc16 (xmodem) instead of crc32\n");
}
