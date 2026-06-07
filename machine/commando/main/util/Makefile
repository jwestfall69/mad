BUILD_DIR=build
MKDIR = mkdir
CC=cc

all: $(BUILD_DIR)/mad-commando-encode

$(BUILD_DIR)/mad-commando-encode: mad-commando-encode.c z80-opcodes.h $(BUILD_DIR)
	$(CC) mad-commando-encode.c -o $(BUILD_DIR)/mad-commando-encode

$(BUILD_DIR):
	$(MKDIR) -p $(BUILD_DIR)

clean:
	rm -rf build
