CC=cc

all: rom-byte-split rom-inject-crc-mirror

rom-byte-split: rom-byte-split.c
	$(CC) rom-byte-split.c -o rom-byte-split

rom-inject-crc-mirror: rom-inject-crc-mirror.c
	$(CC) rom-inject-crc-mirror.c -o rom-inject-crc-mirror

clean:
	rm rom-byte-split rom-inject-crc-mirror
