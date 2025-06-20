MAD_NAME=mad_rollerg
BUILD_FLAGS=
ROM_SIZE=131072
BUILD_DIR=build
OBJ_DIR=$(BUILD_DIR)/obj
WORK_DIR=$(BUILD_DIR)/work
ROM=999m02.g7

VASM = vasm6809_mot
VASM_FLAGS = -konami2ext -Fvobj -spaces -chklabels -Iinclude -I../../../common  -quiet
VLINK = vlink
VLINK_FLAGS = -brawbin1 -T$(MAD_NAME).ld
MKDIR = mkdir
DD = dd

OBJS = $(OBJ_DIR)/cpu/konami2/src/footer.o \
       $(OBJ_DIR)/cpu/konami2/src/input_update.o \
       $(OBJ_DIR)/cpu/konami2/src/print_error.o \
       $(OBJ_DIR)/cpu/konami2/src/util.o \
       $(OBJ_DIR)/cpu/konami2/src/xy_string.o \
       $(OBJ_DIR)/cpu/konami2/src/debug/error_address_test.o \
       $(OBJ_DIR)/cpu/konami2/src/debug/mad_git_hash.o \
       $(OBJ_DIR)/cpu/konami2/src/handlers/auto_test.o \
       $(OBJ_DIR)/cpu/konami2/src/handlers/error.o \
       $(OBJ_DIR)/cpu/konami2/src/handlers/memory_tests.o \
       $(OBJ_DIR)/cpu/konami2/src/handlers/memory_viewer.o \
       $(OBJ_DIR)/cpu/konami2/src/handlers/menu.o \
       $(OBJ_DIR)/cpu/konami2/src/handlers/sound.o \
       $(OBJ_DIR)/cpu/konami2/src/handlers/sprite_k053247_viewer.o \
       $(OBJ_DIR)/cpu/konami2/src/handlers/tile8_viewer.o \
       $(OBJ_DIR)/cpu/konami2/src/tests/input.o \
       $(OBJ_DIR)/cpu/konami2/src/tests/mad_rom.o \
       $(OBJ_DIR)/cpu/konami2/src/tests/memory.o \
       $(OBJ_DIR)/cpu/konami2/src/tests/work_ram.o

# code from this machine
OBJS += $(OBJ_DIR)/$(MAD_NAME).o \
        $(OBJ_DIR)/error_address.o \
        $(OBJ_DIR)/errors.o \
        $(OBJ_DIR)/print.o \
        $(OBJ_DIR)/screen.o \
        $(OBJ_DIR)/vector_table.o \
        $(OBJ_DIR)/version.o \
        $(OBJ_DIR)/menus/debug.o \
        $(OBJ_DIR)/menus/graphics_viewer.o \
        $(OBJ_DIR)/menus/main.o \
        $(OBJ_DIR)/menus/memory_viewer.o \
        $(OBJ_DIR)/menus/ram_tests.o \
        $(OBJ_DIR)/menus/video_tests.o \
        $(OBJ_DIR)/tests/auto.o \
        $(OBJ_DIR)/tests/input.o \
        $(OBJ_DIR)/tests/palette_ram.o \
        $(OBJ_DIR)/tests/prog_bank.o \
        $(OBJ_DIR)/tests/sound.o \
        $(OBJ_DIR)/tests/sprite_ram.o \
        $(OBJ_DIR)/tests/tile_ram.o \
        $(OBJ_DIR)/tests/video_dac.o \
        $(OBJ_DIR)/viewers/sprite.o \
        $(OBJ_DIR)/viewers/tile.o

OBJS += $(OBJ_DIR)/cpu/konami2/src/debug/hardware/watchdog_time.o \
        $(OBJ_DIR)/cpu/konami2/src/handlers/memory_write.o \
        $(OBJ_DIR)/debug/hardware/sprite_debug.o \
        $(OBJ_DIR)/menus/debug_hardware.o

INCS = $(wildcard include/*.inc) \
       $(wildcard ../../../common/global/include/*.inc) \
       $(wildcard ../../../common/cpu/konami2/include/*.inc) \
       $(wildcard ../../../common/cpu/konami2/include/tests/*.inc) \
       $(wildcard ../../../common/cpu/konami2/include/tests/*/*.inc)

$(WORK_DIR)/$(MAD_NAME).bin: include/error_codes.inc $(WORK_DIR) $(BUILD_DIR) $(OBJS) ../README.md
	$(VLINK) $(VLINK_FLAGS) -o $(WORK_DIR)/$(MAD_NAME).bin $(OBJS)
	../../../util/rom-inject-crc-mirror -x -r -m 17 -c 16 -f $(WORK_DIR)/$(MAD_NAME).bin -e big -t $(ROM_SIZE)
	$(DD) if=$(WORK_DIR)/$(MAD_NAME).bin of=$(BUILD_DIR)/$(ROM)

include/error_codes.inc: include/error_codes.cfg
	../../../util/gen-error-codes -b 6 include/error_codes.cfg include/error_codes.inc

../README.md: include/error_codes.inc ../../../common/cpu/konami2/include/error_codes.inc
	../../../util/gen-error-codes-markdown-table -i include/error_codes.inc -i ../../../common/cpu/konami2/include/error_codes.inc -c konami2 -t main -m ../README.md

src/version.asm:
	../../../util/gen-version-asm-file -m ROLLERG -i ../../../common/global/src/version.asm.in -o src/version.asm

$(OBJ_DIR)/%.o: src/%.asm $(INCS)
	@[ -d "$(@D)" ] || $(MKDIR) -p "$(@D)"
	$(VASM) $(VASM_FLAGS) $(BUILD_FLAGS) -o $@ $<

$(OBJ_DIR)/cpu/konami2/src/%.o: ../../../common/cpu/konami2/src/%.asm $(INCS)
	@[ -d "$(@D)" ] || $(MKDIR) -p "$(@D)"
	$(VASM) $(VASM_FLAGS) $(BUILD_FLAGS) -o $@ $<

$(WORK_DIR):
	$(MKDIR) -p $(WORK_DIR)

.PHONY: src/version.asm

clean:
	rm -fr $(BUILD_DIR)
