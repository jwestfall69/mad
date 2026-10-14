MAD_NAME=mad_dec0
BUILD_FLAGS += -D_ROMSET_STR_LENGTH_=$(shell echo -n '$(ROMSET)' | wc -c)

VASM = vasmm68k_mot
VASM_FLAGS = -Fvobj -m68000 -spaces -chklabels -Iinclude -I../../../common -wfail -quiet
VLINK = vlink
VLINK_FLAGS = -brawbin1 -T$(MAD_NAME).ld
MKDIR = mkdir
DD = dd

# global includes/code
INCS += $(wildcard ../../../common/global/include/*.inc)
INCS += $(wildcard ../../../common/cpu/68000/include/*.inc)
INCS += $(wildcard ../../../common/cpu/68000/include/tests/*.inc)

OBJS += $(OBJ_DIR)/cpu/68000/src/crc32.o
OBJS += $(OBJ_DIR)/cpu/68000/src/dsub.o
OBJS += $(OBJ_DIR)/cpu/68000/src/error_address.o
OBJS += $(OBJ_DIR)/cpu/68000/src/footer.o
OBJS += $(OBJ_DIR)/cpu/68000/src/input_update.o
OBJS += $(OBJ_DIR)/cpu/68000/src/memory_fill.o
OBJS += $(OBJ_DIR)/cpu/68000/src/print_error.o
OBJS += $(OBJ_DIR)/cpu/68000/src/util.o
OBJS += $(OBJ_DIR)/cpu/68000/src/xy_string.o
OBJS += $(OBJ_DIR)/cpu/68000/src/debug/ec_dupe_check.o
OBJS += $(OBJ_DIR)/cpu/68000/src/debug/error_address_test.o
OBJS += $(OBJ_DIR)/cpu/68000/src/debug/mad_git_hash.o
OBJS += $(OBJ_DIR)/cpu/68000/src/handlers/auto_test.o
OBJS += $(OBJ_DIR)/cpu/68000/src/handlers/error.o
OBJS += $(OBJ_DIR)/cpu/68000/src/handlers/input_test.o
OBJS += $(OBJ_DIR)/cpu/68000/src/handlers/memory_viewer.o
OBJS += $(OBJ_DIR)/cpu/68000/src/handlers/memory_tests.o
OBJS += $(OBJ_DIR)/cpu/68000/src/handlers/menu.o
OBJS += $(OBJ_DIR)/cpu/68000/src/handlers/sound_test.o
OBJS += $(OBJ_DIR)/cpu/68000/src/handlers/tile_8x8_viewer.o
OBJS += $(OBJ_DIR)/cpu/68000/src/tests/mad_rom.o
OBJS += $(OBJ_DIR)/cpu/68000/src/tests/memory.o
OBJS += $(OBJ_DIR)/cpu/68000/src/tests/work_ram.o

# machine specific includes/code
INCS += $(wildcard include/*.inc)

OBJS += $(OBJ_DIR)/$(MAD_NAME).o
OBJS += $(OBJ_DIR)/errors.o
OBJS += $(OBJ_DIR)/print.o
OBJS += $(OBJ_DIR)/screen.o
OBJS += $(OBJ_DIR)/vector_table.o
OBJS += $(OBJ_DIR)/version.o
OBJS += $(OBJ_DIR)/debug/fg_tile_viewer.o
OBJS += $(OBJ_DIR)/menus/debug.o
OBJS += $(OBJ_DIR)/menus/main.o
OBJS += $(OBJ_DIR)/menus/memory_viewer.o
OBJS += $(OBJ_DIR)/tests/auto.o
OBJS += $(OBJ_DIR)/tests/input.o
OBJS += $(OBJ_DIR)/tests/palette_ram.o
OBJS += $(OBJ_DIR)/tests/palette_ext_ram.o
OBJS += $(OBJ_DIR)/tests/sound.o
OBJS += $(OBJ_DIR)/tests/sprite_ram.o
OBJS += $(OBJ_DIR)/tests/tile1_ram.o
OBJS += $(OBJ_DIR)/tests/tile2_ram.o
OBJS += $(OBJ_DIR)/tests/tile3_ram.o
OBJS += $(OBJ_DIR)/tests/video_dac.o

$(WORK_DIR)/$(MAD_NAME).bin: include/error_codes.inc $(WORK_DIR) $(BUILD_DIR) $(OBJS)
	$(VLINK) $(VLINK_FLAGS) -o $(WORK_DIR)/$(MAD_NAME).bin $(OBJS)
	../../../util/rom-inject-crc-mirror -f $(WORK_DIR)/$(MAD_NAME).bin -e big -t $(ROM_SIZE)
	../../../util/rom-byte-split $(WORK_DIR)/$(MAD_NAME).bin $(BUILD_DIR)/$(ROMA) $(BUILD_DIR)/$(ROMB)

include/error_codes.inc: include/error_codes.cfg
	../../../util/gen-error-codes -b 7 include/error_codes.cfg include/error_codes.inc

src/version.asm:
	../../../util/gen-version-asm-file -m DEC0 -r $(ROMSET) -i ../../../common/global/src/version.asm.in -o src/version.asm

$(OBJ_DIR)/%.o: src/%.asm $(INCS)
	@[ -d "$(@D)" ] || $(MKDIR) -p "$(@D)"
	$(VASM) $(VASM_FLAGS) $(BUILD_FLAGS) -o $@ $<

$(OBJ_DIR)/cpu/68000/src/%.o: ../../../common/cpu/68000/src/%.asm $(INCS)
	@[ -d "$(@D)" ] || $(MKDIR) -p "$(@D)"
	$(VASM) $(VASM_FLAGS) $(BUILD_FLAGS) -o $@ $<

$(WORK_DIR):
	$(MKDIR) -p $(WORK_DIR)

.PHONY: src/version.asm

clean:
	rm -fr $(BUILD_DIR)
