CC=cc
CXX=c++

all: mad-konami1-encode rom-byte-split rom-inject-crc-mirror

mad-konami1-encode: mad-konami1-encode.c mad-konami1-encode.h
	$(CC) mad-konami1-encode.c -o mad-konami1-encode

rom-byte-split: rom-byte-split.c
	$(CC) rom-byte-split.c -o rom-byte-split

rom-inject-crc-mirror: rom-inject-crc-mirror.c
	$(CC) rom-inject-crc-mirror.c -o rom-inject-crc-mirror

clean:
	rm -f mad-konami1-encode rom-byte-split rom-inject-crc-mirror
