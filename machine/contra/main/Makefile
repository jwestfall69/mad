MAD_NAME=mad_contra
BUILD_FLAGS=
ROM_SIZE=65536
BUILD_DIR=build
OBJ_DIR=$(BUILD_DIR)/obj
WORK_DIR=$(BUILD_DIR)/work
ROM=633m03.18a

VASM = vasm6809_mot
VASM_FLAGS = -Fvobj -6309 -spaces -chklabels -Iinclude -I../../../common  -quiet
VLINK = vlink
VLINK_FLAGS = -brawbin1 -T$(MAD_NAME).ld
MKDIR = mkdir
DD = dd

OBJS = $(OBJ_DIR)/cpu/6309/src/crc32.o \
       $(OBJ_DIR)/cpu/6309/src/input_update.o \
       $(OBJ_DIR)/cpu/6309/src/memory_fill.o \
       $(OBJ_DIR)/cpu/6309/src/print_error.o \
       $(OBJ_DIR)/cpu/6309/src/util.o \
       $(OBJ_DIR)/cpu/6309/src/xy_string.o \
       $(OBJ_DIR)/cpu/6309/src/handlers/error.o \
       $(OBJ_DIR)/cpu/6309/src/handlers/memory_tests.o \
       $(OBJ_DIR)/cpu/6309/src/handlers/memory_viewer.o \
       $(OBJ_DIR)/cpu/6309/src/handlers/menu.o \
       $(OBJ_DIR)/cpu/6309/src/handlers/sound.o \
       $(OBJ_DIR)/cpu/6309/src/handlers/tile8_viewer.o \
       $(OBJ_DIR)/cpu/6309/src/tests/auto.o \
       $(OBJ_DIR)/cpu/6309/src/tests/input.o \
       $(OBJ_DIR)/cpu/6309/src/tests/memory.o \
       $(OBJ_DIR)/cpu/6309/src/tests/mad_rom.o \
       $(OBJ_DIR)/cpu/6309/src/tests/work_ram.o

# code from this machine
OBJS += $(OBJ_DIR)/$(MAD_NAME).o \
        $(OBJ_DIR)/errors.o \
        $(OBJ_DIR)/footer.o \
        $(OBJ_DIR)/print.o \
        $(OBJ_DIR)/screen.o \
        $(OBJ_DIR)/vector_table.o \
        $(OBJ_DIR)/menus/main.o \
        $(OBJ_DIR)/menus/memory_viewer.o \
        $(OBJ_DIR)/tests/auto.o \
        $(OBJ_DIR)/tests/input.o \
        $(OBJ_DIR)/tests/palette_ram.o \
        $(OBJ_DIR)/tests/sprite1_ram.o \
        $(OBJ_DIR)/tests/sprite2_ram.o \
        $(OBJ_DIR)/tests/tile1_ram.o \
        $(OBJ_DIR)/tests/tile2_ram.o \
        $(OBJ_DIR)/tests/tile3_ram.o

INCS = $(wildcard include/*.inc) \
       $(wildcard ../../../common/cpu/6309/include/*.inc) \
       $(wildcard ../../../common/cpu/6309/include/tests/*.inc)
       $(wildcard ../../../common/cpu/6309/include/tests/*/*.inc)

$(WORK_DIR)/$(MAD_NAME).bin: include/error_codes.inc $(WORK_DIR) $(OBJ_DIR) $(BUILD_DIR) $(OBJS)
	$(VLINK) $(VLINK_FLAGS) -o $(WORK_DIR)/$(MAD_NAME).bin $(OBJS)
	../../../util/rom-inject-crc-mirror -r -m 19 -c 18 -f $(WORK_DIR)/$(MAD_NAME).bin -e big -t $(ROM_SIZE)
	$(DD) if=$(WORK_DIR)/$(MAD_NAME).bin of=$(BUILD_DIR)/$(ROM)

include/error_codes.inc: include/error_codes.cfg
	../../../util/gen-error-codes -b 6 include/error_codes.cfg include/error_codes.inc

$(OBJ_DIR)/%.o: src/%.asm $(INCS)
	$(VASM) $(VASM_FLAGS) $(BUILD_FLAGS) -o $@ $<

$(OBJ_DIR)/cpu/6309/src/%.o: ../../../common/cpu/6309/src/%.asm $(INCS)
	 $(VASM) $(VASM_FLAGS) $(BUILD_FLAGS) -o $@ $<

$(WORK_DIR):
	$(MKDIR) -p $(WORK_DIR)

$(OBJ_DIR):
	$(MKDIR) -p $(OBJ_DIR)/debug $(OBJ_DIR)/menus $(OBJ_DIR)/tests $(OBJ_DIR)/cpu/6309/src/debug $(OBJ_DIR)/cpu/6309/src/handlers $(OBJ_DIR)/cpu/6309/src/tests

clean:
	rm -fr $(BUILD_DIR)/

