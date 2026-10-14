MAD_NAME=mad_cps2
BUILD_DIR=build/$(ROMSET)
OBJ_DIR=$(BUILD_DIR)/obj
WORK_DIR=$(BUILD_DIR)/work
BUILD_FLAGS += -D_ROMSET_STR_LENGTH_=$(shell echo -n '$(ROMSET)' | wc -c)

VASM = vasmm68k_mot
VASM_FLAGS = -Fvobj -m68000 -spaces -chklabels -Iinclude -I../../../common -wfail -quiet
VLINK = vlink
VLINK_FLAGS = -brawbin1 -T$(MAD_NAME).ld
MKDIR = mkdir
DD = dd
COPY = cp

# global includes/code
INCS += $(wildcard ../../../common/global/include/*.inc)
INCS += $(wildcard ../../../common/global/include/*/*.inc)
INCS += $(wildcard ../../../common/global/include/*/*/*.inc)
INCS += $(wildcard ../../../common/global/include/*.inc)
INCS += $(wildcard ../../../common/cpu/68000/include/*.inc)
INCS += $(wildcard ../../../common/cpu/68000/include/*/*.inc)
INCS += $(wildcard ../../../common/cpu/68000/include/*/*/*.inc)

OBJS += $(OBJ_DIR)/cpu/68000/src/crc32.o
OBJS += $(OBJ_DIR)/cpu/68000/src/dsub.o
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
OBJS += $(OBJ_DIR)/cpu/68000/src/handlers/memory_tests.o
OBJS += $(OBJ_DIR)/cpu/68000/src/handlers/memory_viewer.o
OBJS += $(OBJ_DIR)/cpu/68000/src/handlers/menu.o
OBJS += $(OBJ_DIR)/cpu/68000/src/handlers/sound_test.o
OBJS += $(OBJ_DIR)/cpu/68000/src/handlers/tile_8x8_viewer.o
OBJS += $(OBJ_DIR)/cpu/68000/src/handlers/tile_16x16_viewer.o
OBJS += $(OBJ_DIR)/cpu/68000/src/handlers/values_edit.o
OBJS += $(OBJ_DIR)/cpu/68000/src/tests/mad_rom.o
OBJS += $(OBJ_DIR)/cpu/68000/src/tests/memory.o

# machine specific includes/code
INCS += $(wildcard include/*.inc)
INCS += $(wildcard include/*/*.inc)
INCS += $(wildcard include/*/*/*.inc)

OBJS += $(OBJ_DIR)/$(MAD_NAME).o
OBJS += $(OBJ_DIR)/error_address.o
OBJS += $(OBJ_DIR)/errors.o
OBJS += $(OBJ_DIR)/print.o
OBJS += $(OBJ_DIR)/screen.o
OBJS += $(OBJ_DIR)/vector_table.o
OBJS += $(OBJ_DIR)/version.o
OBJS += $(OBJ_DIR)/menus/debug.o
OBJS += $(OBJ_DIR)/menus/main.o
OBJS += $(OBJ_DIR)/menus/graphics_viewer.o
OBJS += $(OBJ_DIR)/menus/memory_viewer.o
OBJS += $(OBJ_DIR)/menus/ram_tests.o
OBJS += $(OBJ_DIR)/menus/video_tests.o
OBJS += $(OBJ_DIR)/tests/auto.o
OBJS += $(OBJ_DIR)/tests/gfx_ram.o
OBJS += $(OBJ_DIR)/tests/input.o
OBJS += $(OBJ_DIR)/tests/object_ram.o
OBJS += $(OBJ_DIR)/tests/qsound_ram.o
OBJS += $(OBJ_DIR)/tests/sound.o
OBJS += $(OBJ_DIR)/tests/work_ram.o
OBJS += $(OBJ_DIR)/tests/video_dac.o
OBJS += $(OBJ_DIR)/viewers/scroll2_tile.o
OBJS += $(OBJ_DIR)/viewers/scroll1_tile.o
OBJS += $(OBJ_DIR)/viewers/sprite.o
OBJS += $(OBJ_DIR)/viewers/tile_viewer_common.o

ifneq (,$(findstring _DEBUG_HARDWARE_,$(BUILD_FLAGS)))
OBJS += $(OBJ_DIR)/cpu/68000/src/debug/hardware/watchdog_time.o
OBJS += $(OBJ_DIR)/cpu/68000/src/handlers/memory_write.o
OBJS += $(OBJ_DIR)/debug/hardware/sprite.o
OBJS += $(OBJ_DIR)/menus/debug_hardware.o
endif

$(WORK_DIR)/$(MAD_NAME).bin: include/error_codes.inc $(WORK_DIR) $(BUILD_DIR) $(OBJS) ../README.md util/mad-cps2-encrypt
	$(VLINK) $(VLINK_FLAGS) -o $(WORK_DIR)/$(MAD_NAME).bin $(OBJS)
	# suicide rom
	$(COPY)  $(WORK_DIR)/$(MAD_NAME).bin $(WORK_DIR)/$(MAD_NAME).nokey
	../../../util/rom-inject-crc-mirror -f $(WORK_DIR)/$(MAD_NAME).nokey -e big -t $(ROM_SIZE)
	$(DD) if=$(WORK_DIR)/$(MAD_NAME).nokey of=$(BUILD_DIR)/suicide-$(ROM) conv=swab
	# encrypted rom
	$(DD) if=$(WORK_DIR)/$(MAD_NAME).bin of=$(WORK_DIR)/$(MAD_NAME).bin.swab conv=swab
	./util/build/mad-cps2-encrypt -k keys/$(KEY_FILE) -i $(WORK_DIR)/$(MAD_NAME).bin.swab -o $(WORK_DIR)/$(MAD_NAME).bin.swab.enc
	$(DD) if=$(WORK_DIR)/$(MAD_NAME).bin.swab.enc of=$(WORK_DIR)/$(MAD_NAME).enc conv=swab
	../../../util/rom-inject-crc-mirror -f $(WORK_DIR)/$(MAD_NAME).enc -e big -t $(ROM_SIZE)
	$(DD) if=$(WORK_DIR)/$(MAD_NAME).enc of=$(BUILD_DIR)/encrypted-$(ROM) conv=swab

include/error_codes.inc: include/error_codes.cfg
	../../../util/gen-error-codes -b 7 include/error_codes.cfg include/error_codes.inc

util/mad-cps2-encrypt:
	make -C util

../README.md: include/error_codes.inc ../../../common/cpu/68000/include/error_codes.inc
	../../../util/gen-error-codes-markdown-table -i include/error_codes.inc -i ../../../common/cpu/68000/include/error_codes.inc -c 68000 -t main -m ../README.md

src/version.asm:
	../../../util/gen-version-asm-file -m CPS2 -r $(ROMSET) -i ../../../common/global/src/version.asm.in -o src/version.asm

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
