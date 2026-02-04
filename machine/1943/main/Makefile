MAD_NAME=mad_1943
BUILD_FLAGS=-D_CPU_Z80_ -D_DEBUG_HARDWARE_
ROM_SIZE=32768
BUILD_DIR=build
OBJ_DIR=$(BUILD_DIR)/obj
WORK_DIR=$(BUILD_DIR)/work
ROM=bme01.12d

VASM = vasmz80_mot
VASM_FLAGS = -Fvobj -spaces -chklabels -Iinclude -I../../../common -wfail -quiet
VLINK = vlink
VLINK_FLAGS = -brawbin1 -T$(MAD_NAME).ld
MKDIR = mkdir
DD = dd

OBJS = $(OBJ_DIR)/cpu/z80/src/crc32.o \
       $(OBJ_DIR)/cpu/z80/src/dsub.o \
       $(OBJ_DIR)/cpu/z80/src/error_address.o \
       $(OBJ_DIR)/cpu/z80/src/footer.o \
       $(OBJ_DIR)/cpu/z80/src/input_update.o \
       $(OBJ_DIR)/cpu/z80/src/memory_fill.o \
       $(OBJ_DIR)/cpu/z80/src/print_error.o \
       $(OBJ_DIR)/cpu/z80/src/util.o \
       $(OBJ_DIR)/cpu/z80/src/xy_string.o \
       $(OBJ_DIR)/cpu/z80/src/debug/error_address_test.o \
       $(OBJ_DIR)/cpu/z80/src/debug/mad_git_hash.o \
       $(OBJ_DIR)/cpu/z80/src/handlers/auto_test.o \
       $(OBJ_DIR)/cpu/z80/src/handlers/error.o \
       $(OBJ_DIR)/cpu/z80/src/handlers/input_test.o \
       $(OBJ_DIR)/cpu/z80/src/handlers/memory_tests.o \
       $(OBJ_DIR)/cpu/z80/src/handlers/memory_viewer.o \
       $(OBJ_DIR)/cpu/z80/src/handlers/menu.o \
       $(OBJ_DIR)/cpu/z80/src/handlers/sound_test.o \
       $(OBJ_DIR)/cpu/z80/src/handlers/tile_8x8_viewer.o \
       $(OBJ_DIR)/cpu/z80/src/handlers/values_edit.o \
       $(OBJ_DIR)/cpu/z80/src/tests/mad_rom.o \
       $(OBJ_DIR)/cpu/z80/src/tests/memory.o \
       $(OBJ_DIR)/cpu/z80/src/tests/work_ram.o

# code from this machine
OBJS += $(OBJ_DIR)/$(MAD_NAME).o \
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
        $(OBJ_DIR)/tests/auto.o \
        $(OBJ_DIR)/tests/input.o \
        $(OBJ_DIR)/tests/sound.o \
        $(OBJ_DIR)/tests/tile_ram.o \
        $(OBJ_DIR)/viewers/bg1_tile.o \
        $(OBJ_DIR)/viewers/bg2_tile.o \
        $(OBJ_DIR)/viewers/sprite.o \
        $(OBJ_DIR)/viewers/fix_tile.o

ifneq (,$(findstring _DEBUG_HARDWARE_,$(BUILD_FLAGS)))
OBJS += $(OBJ_DIR)/cpu/z80/src/debug/hardware/watchdog_time.o \
        $(OBJ_DIR)/cpu/z80/src/handlers/memory_write.o \
        $(OBJ_DIR)/debug/hardware/sprite.o \
        $(OBJ_DIR)/menus/debug_hardware.o
endif

INCS = $(wildcard ../../../common/global/include/*.inc) \
       $(wildcard ../../../common/global/include/*/*.inc) \
       $(wildcard ../../../common/global/include/*/*/*.inc) \
       $(wildcard ../../../common/global/include/*.inc) \
       $(wildcard ../../../common/cpu/z80/include/*.inc) \
       $(wildcard ../../../common/cpu/z80/include/*/*.inc) \
       $(wildcard ../../../common/cpu/z80/include/*/*/*.inc) \
       $(wildcard include/*.inc) \
       $(wildcard include/*/*.inc) \
       $(wildcard include/*/*/*.inc)

$(WORK_DIR)/$(MAD_NAME).bin: include/error_codes.inc $(WORK_DIR) $(BUILD_DIR) $(OBJS) ../README.md
	$(VLINK) $(VLINK_FLAGS) -o $(WORK_DIR)/$(MAD_NAME).bin $(OBJS)
	../../../util/rom-inject-crc-mirror -f $(WORK_DIR)/$(MAD_NAME).bin -e little -t $(ROM_SIZE)
	$(DD) if=$(WORK_DIR)/$(MAD_NAME).bin of=$(BUILD_DIR)/$(ROM)

include/error_codes.inc: include/error_codes.cfg
	../../../util/gen-error-codes -b 6 include/error_codes.cfg include/error_codes.inc

../README.md: include/error_codes.inc ../../../common/cpu/z80/include/error_codes.inc
	../../../util/gen-error-codes-markdown-table -i include/error_codes.inc -i ../../../common/cpu/z80/include/error_codes.inc -c z80 -t main -b 6000 -m ../README.md

src/version.asm:
	../../../util/gen-version-asm-file -m 1943 -i ../../../common/global/src/version.asm.in -o src/version.asm

$(OBJ_DIR)/%.o: src/%.asm $(INCS)
	@[ -d "$(@D)" ] || $(MKDIR) -p "$(@D)"
	$(VASM) $(VASM_FLAGS) $(BUILD_FLAGS) -o $@ $<

$(OBJ_DIR)/cpu/z80/src/%.o: ../../../common/cpu/z80/src/%.asm $(INCS)
	@[ -d "$(@D)" ] || $(MKDIR) -p "$(@D)"
	$(VASM) $(VASM_FLAGS) $(BUILD_FLAGS) -o $@ $<

$(WORK_DIR):
	$(MKDIR) -p $(WORK_DIR)

.PHONY: src/version.asm

clean:
	rm -fr $(BUILD_DIR)
