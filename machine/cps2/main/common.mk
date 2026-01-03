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

OBJS = $(OBJ_DIR)/cpu/68000/src/crc32.o \
       $(OBJ_DIR)/cpu/68000/src/dsub.o \
       $(OBJ_DIR)/cpu/68000/src/footer.o \
       $(OBJ_DIR)/cpu/68000/src/input_update.o \
       $(OBJ_DIR)/cpu/68000/src/memory_fill.o \
       $(OBJ_DIR)/cpu/68000/src/print_error.o \
       $(OBJ_DIR)/cpu/68000/src/util.o \
       $(OBJ_DIR)/cpu/68000/src/xy_string.o \
       $(OBJ_DIR)/cpu/68000/src/debug/ec_dupe_check.o \
       $(OBJ_DIR)/cpu/68000/src/debug/error_address_test.o \
       $(OBJ_DIR)/cpu/68000/src/debug/mad_git_hash.o \
       $(OBJ_DIR)/cpu/68000/src/handlers/auto_test.o \
       $(OBJ_DIR)/cpu/68000/src/handlers/error.o \
       $(OBJ_DIR)/cpu/68000/src/handlers/memory_tests.o \
       $(OBJ_DIR)/cpu/68000/src/handlers/memory_viewer.o \
       $(OBJ_DIR)/cpu/68000/src/handlers/menu.o \
       $(OBJ_DIR)/cpu/68000/src/handlers/sound.o \
       $(OBJ_DIR)/cpu/68000/src/handlers/tile8_viewer.o \
       $(OBJ_DIR)/cpu/68000/src/handlers/tile16_viewer.o \
       $(OBJ_DIR)/cpu/68000/src/handlers/values_edit.o \
       $(OBJ_DIR)/cpu/68000/src/tests/input.o \
       $(OBJ_DIR)/cpu/68000/src/tests/mad_rom.o \
       $(OBJ_DIR)/cpu/68000/src/tests/memory.o

# code from this machine
OBJS += $(OBJ_DIR)/$(MAD_NAME).o \
        $(OBJ_DIR)/error_address.o \
        $(OBJ_DIR)/errors.o \
        $(OBJ_DIR)/print.o \
        $(OBJ_DIR)/screen.o \
        $(OBJ_DIR)/vector_table.o \
        $(OBJ_DIR)/version.o \
        $(OBJ_DIR)/menus/debug.o \
        $(OBJ_DIR)/menus/main.o \
        $(OBJ_DIR)/menus/graphics_viewer.o \
        $(OBJ_DIR)/menus/memory_viewer.o \
        $(OBJ_DIR)/menus/ram_tests.o \
        $(OBJ_DIR)/menus/video_tests.o \
        $(OBJ_DIR)/tests/auto.o \
        $(OBJ_DIR)/tests/gfx_ram.o \
        $(OBJ_DIR)/tests/input.o \
        $(OBJ_DIR)/tests/object_ram.o \
        $(OBJ_DIR)/tests/qsound_ram.o \
        $(OBJ_DIR)/tests/sound.o \
        $(OBJ_DIR)/tests/work_ram.o \
        $(OBJ_DIR)/tests/video_dac.o \
        $(OBJ_DIR)/viewers/scroll2_tile.o \
        $(OBJ_DIR)/viewers/scroll1_tile.o \
        $(OBJ_DIR)/viewers/sprite.o \
        $(OBJ_DIR)/viewers/tile_viewer_common.o

ifneq (,$(findstring _DEBUG_HARDWARE_,$(BUILD_FLAGS)))
OBJS += $(OBJ_DIR)/cpu/68000/src/debug/hardware/watchdog_time.o \
        $(OBJ_DIR)/cpu/68000/src/handlers/memory_write.o \
        $(OBJ_DIR)/debug/hardware/sprite.o \
        $(OBJ_DIR)/menus/debug_hardware.o
endif

INCS = $(wildcard ../../../common/global/include/*.inc) \
       $(wildcard ../../../common/global/include/*/*.inc) \
       $(wildcard ../../../common/global/include/*/*/*.inc) \
       $(wildcard ../../../common/global/include/*.inc) \
       $(wildcard ../../../common/cpu/68000/include/*.inc) \
       $(wildcard ../../../common/cpu/68000/include/*/*.inc) \
       $(wildcard ../../../common/cpu/68000/include/*/*/*.inc) \
       $(wildcard include/*.inc) \
       $(wildcard include/*/*.inc) \
       $(wildcard include/*/*/*.inc)

$(WORK_DIR)/$(MAD_NAME).bin: include/error_codes.inc $(WORK_DIR) $(BUILD_DIR) $(OBJS) ../README.md
	$(VLINK) $(VLINK_FLAGS) -o $(WORK_DIR)/$(MAD_NAME).bin $(OBJS)
	# suicide rom
	$(COPY)  $(WORK_DIR)/$(MAD_NAME).bin $(WORK_DIR)/$(MAD_NAME).nokey
	../../../util/rom-inject-crc-mirror -f $(WORK_DIR)/$(MAD_NAME).nokey -e big -t $(ROM_SIZE)
	$(DD) if=$(WORK_DIR)/$(MAD_NAME).nokey of=$(BUILD_DIR)/suicide-$(ROM) conv=swab
	# encrypted rom
	$(DD) if=$(WORK_DIR)/$(MAD_NAME).bin of=$(WORK_DIR)/$(MAD_NAME).bin.swab conv=swab
	../../../util/rom-cps2-encrypt -k keys/$(KEY_FILE) -i $(WORK_DIR)/$(MAD_NAME).bin.swab -o $(WORK_DIR)/$(MAD_NAME).bin.swab.enc
	$(DD) if=$(WORK_DIR)/$(MAD_NAME).bin.swab.enc of=$(WORK_DIR)/$(MAD_NAME).enc conv=swab
	../../../util/rom-inject-crc-mirror -f $(WORK_DIR)/$(MAD_NAME).enc -e big -t $(ROM_SIZE)
	$(DD) if=$(WORK_DIR)/$(MAD_NAME).enc of=$(BUILD_DIR)/encrypted-$(ROM) conv=swab

include/error_codes.inc: include/error_codes.cfg
	../../../util/gen-error-codes -b 7 include/error_codes.cfg include/error_codes.inc

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
