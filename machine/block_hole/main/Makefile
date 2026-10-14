MAD_NAME=mad_blockhl
BUILD_FLAGS=-D_CPU_KONAMI2_ -D_DEBUG_HARDWARE_
ROM_SIZE=65536
BUILD_DIR=build
OBJ_DIR=$(BUILD_DIR)/obj
WORK_DIR=$(BUILD_DIR)/work
ROM=973l02.e21

VASM = vasm6809_mot
VASM_FLAGS = -konami2 -Fvobj -spaces -chklabels -Iinclude -I../../../common -wfail -quiet
VLINK = vlink
VLINK_FLAGS = -brawbin1 -T$(MAD_NAME).ld
MKDIR = mkdir
DD = dd

# global includes/code
INCS += $(wildcard ../../../common/global/include/*.inc)
INCS += $(wildcard ../../../common/global/include/*/*.inc)
INCS += $(wildcard ../../../common/global/include/*/*/*.inc)
INCS += $(wildcard ../../../common/global/include/*.inc)
INCS += $(wildcard ../../../common/cpu/6x09/include/*.inc)
INCS += $(wildcard ../../../common/cpu/6x09/include/*/*.inc)
INCS += $(wildcard ../../../common/cpu/6x09/include/*/*/*.inc)
INCS += $(wildcard ../../../common/cpu/konami2/include/*.inc)
INCS += $(wildcard ../../../common/cpu/konami2/include/*/*.inc)
INCS += $(wildcard ../../../common/cpu/konami2/include/*/*/*.inc)

OBJS += $(OBJ_DIR)/cpu/6x09/src/header.o
OBJS += $(OBJ_DIR)/cpu/6x09/src/input_update.o
OBJS += $(OBJ_DIR)/cpu/6x09/src/print_error.o
OBJS += $(OBJ_DIR)/cpu/6x09/src/util.o
OBJS += $(OBJ_DIR)/cpu/6x09/src/xy_string.o
OBJS += $(OBJ_DIR)/cpu/6x09/src/debug/error_address_test.o
OBJS += $(OBJ_DIR)/cpu/6x09/src/debug/mad_git_hash.o
OBJS += $(OBJ_DIR)/cpu/6x09/src/handlers/auto_test.o
OBJS += $(OBJ_DIR)/cpu/6x09/src/handlers/error.o
OBJS += $(OBJ_DIR)/cpu/6x09/src/handlers/input_test.o
OBJS += $(OBJ_DIR)/cpu/6x09/src/handlers/memory_viewer.o
OBJS += $(OBJ_DIR)/cpu/6x09/src/handlers/menu.o
OBJS += $(OBJ_DIR)/cpu/6x09/src/handlers/sound_test.o
OBJS += $(OBJ_DIR)/cpu/6x09/src/handlers/tile_8x8_viewer.o
OBJS += $(OBJ_DIR)/cpu/6x09/src/handlers/values_edit.o

OBJS += $(OBJ_DIR)/cpu/konami2/src/footer.o
OBJS += $(OBJ_DIR)/cpu/konami2/src/handlers/memory_tests.o
OBJS += $(OBJ_DIR)/cpu/konami2/src/tests/mad_rom.o
OBJS += $(OBJ_DIR)/cpu/konami2/src/tests/memory.o
OBJS += $(OBJ_DIR)/cpu/konami2/src/tests/work_ram.o

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
OBJS += $(OBJ_DIR)/menus/graphics_viewer.o
OBJS += $(OBJ_DIR)/menus/main.o
OBJS += $(OBJ_DIR)/menus/memory_viewer.o
OBJS += $(OBJ_DIR)/menus/ram_tests.o
OBJS += $(OBJ_DIR)/menus/video_tests.o
OBJS += $(OBJ_DIR)/tests/auto.o
OBJS += $(OBJ_DIR)/tests/input.o
OBJS += $(OBJ_DIR)/tests/palette_ram.o
OBJS += $(OBJ_DIR)/tests/prog_bank.o
OBJS += $(OBJ_DIR)/tests/sprite_ram.o
OBJS += $(OBJ_DIR)/tests/sound.o
OBJS += $(OBJ_DIR)/tests/tile_attr_ram.o
OBJS += $(OBJ_DIR)/tests/tile_ram.o
OBJS += $(OBJ_DIR)/tests/tile_scroll.o
OBJS += $(OBJ_DIR)/tests/video_dac.o
OBJS += $(OBJ_DIR)/viewers/fix_tile.o
OBJS += $(OBJ_DIR)/viewers/layer_a_tile.o
OBJS += $(OBJ_DIR)/viewers/layer_b_tile.o
OBJS += $(OBJ_DIR)/viewers/sprite.o
OBJS += $(OBJ_DIR)/viewers/tile_viewer_common.o

ifneq (,$(findstring _DEBUG_HARDWARE_,$(BUILD_FLAGS)))
OBJS += $(OBJ_DIR)/cpu/6x09/src/debug/hardware/watchdog_time.o
OBJS += $(OBJ_DIR)/cpu/6x09/src/handlers/memory_write.o
OBJS += $(OBJ_DIR)/debug/hardware/sprite.o
OBJS += $(OBJ_DIR)/menus/debug_hardware.o
# Konami2 CPU tests
# Do to mad rom space contraints its not possible to enable all
# these.  Enabled/disabled tests below will also need to be
# enabled/disabled in src/menus/debug_hardware.asm
#
#OBJS += $(OBJ_DIR)/cpu/konami2/src/tests/cpu/bmove.o
#OBJS += $(OBJ_DIR)/cpu/konami2/src/tests/cpu/bset.o
#OBJS += $(OBJ_DIR)/cpu/konami2/src/tests/cpu/bsetw.o
#OBJS += $(OBJ_DIR)/cpu/konami2/src/tests/cpu/exgtfr.o
#OBJS += $(OBJ_DIR)/cpu/konami2/src/tests/cpu/move.o
OBJS += $(OBJ_DIR)/cpu/konami2/src/tests/cpu/opcode_08.o
#OBJS += $(OBJ_DIR)/cpu/konami2/src/tests/cpu/opcode_idx.o
#OBJS += $(OBJ_DIR)/cpu/konami2/src/tests/cpu/opcode_imm.o
#OBJS += $(OBJ_DIR)/cpu/konami2/src/tests/cpu/opcode_inh.o
endif

$(WORK_DIR)/$(MAD_NAME).bin: include/error_codes.inc $(WORK_DIR) $(BUILD_DIR) $(OBJS) ../README.md
	$(VLINK) $(VLINK_FLAGS) -o $(WORK_DIR)/$(MAD_NAME).bin $(OBJS)
	../../../util/rom-inject-crc-mirror -x -r -m 17 -M -c 16 -f $(WORK_DIR)/$(MAD_NAME).bin -e big -t $(ROM_SIZE)
	$(DD) if=$(WORK_DIR)/$(MAD_NAME).bin of=$(BUILD_DIR)/$(ROM)

include/error_codes.inc: include/error_codes.cfg
	../../../util/gen-error-codes -b 6 include/error_codes.cfg include/error_codes.inc

../README.md: include/error_codes.inc ../../../common/cpu/konami2/include/error_codes.inc
	../../../util/gen-error-codes-markdown-table -i include/error_codes.inc -i ../../../common/cpu/konami2/include/error_codes.inc -c konami2 -t main -m ../README.md

src/version.asm:
	../../../util/gen-version-asm-file -m BLOCKHL -i ../../../common/global/src/version.asm.in -o src/version.asm

$(OBJ_DIR)/%.o: src/%.asm $(INCS)
	@[ -d "$(@D)" ] || $(MKDIR) -p "$(@D)"
	$(VASM) $(VASM_FLAGS) $(BUILD_FLAGS) -o $@ $<

$(OBJ_DIR)/cpu/konami2/src/%.o: ../../../common/cpu/konami2/src/%.asm $(INCS)
	@[ -d "$(@D)" ] || $(MKDIR) -p "$(@D)"
	$(VASM) $(VASM_FLAGS) $(BUILD_FLAGS) -o $@ $<

$(OBJ_DIR)/cpu/6x09/src/%.o: ../../../common/cpu/6x09/src/%.asm $(INCS)
	@[ -d "$(@D)" ] || $(MKDIR) -p "$(@D)"
	$(VASM) $(VASM_FLAGS) $(BUILD_FLAGS) -o $@ $<

$(WORK_DIR):
	$(MKDIR) -p $(WORK_DIR)

.PHONY: src/version.asm

clean:
	rm -fr $(BUILD_DIR)
