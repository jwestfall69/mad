MAD_NAME=mad_vendetta
BUILD_FLAGS=
ROM_SIZE=262144
BUILD_DIR=build
OBJ_DIR=$(BUILD_DIR)/obj
WORK_DIR=$(BUILD_DIR)/work
ROM=081t01.17c

VASM = vasm6809_mot
VASM_FLAGS = -konami2 -Fvobj -spaces -chklabels -Iinclude -I../../../common  -quiet
VLINK = vlink
VLINK_FLAGS = -brawbin1 -T$(MAD_NAME).ld
MKDIR = mkdir
DD = dd

OBJS = $(OBJ_DIR)/cpu/konami2/src/footer.o \
       $(OBJ_DIR)/cpu/konami2/src/input_update.o \
       $(OBJ_DIR)/cpu/konami2/src/print_error.o \
       $(OBJ_DIR)/cpu/konami2/src/util.o \
       $(OBJ_DIR)/cpu/konami2/src/xy_string.o \
       $(OBJ_DIR)/cpu/konami2/src/handlers/auto_test.o \
       $(OBJ_DIR)/cpu/konami2/src/handlers/error.o \
       $(OBJ_DIR)/cpu/konami2/src/handlers/memory_tests.o \
       $(OBJ_DIR)/cpu/konami2/src/handlers/memory_viewer.o \
       $(OBJ_DIR)/cpu/konami2/src/handlers/menu.o \
       $(OBJ_DIR)/cpu/konami2/src/tests/input.o \
       $(OBJ_DIR)/cpu/konami2/src/tests/mad_rom.o \
       $(OBJ_DIR)/cpu/konami2/src/tests/memory.o \
       $(OBJ_DIR)/cpu/konami2/src/tests/work_ram.o \
       $(OBJ_DIR)/cpu/konami2/src/tests/cpu/exgtfr.o \
       $(OBJ_DIR)/cpu/konami2/src/tests/cpu/bmove.o \
       $(OBJ_DIR)/cpu/konami2/src/tests/cpu/bset.o \
       $(OBJ_DIR)/cpu/konami2/src/tests/cpu/bsetw.o \
       $(OBJ_DIR)/cpu/konami2/src/tests/cpu/move.o \
       $(OBJ_DIR)/cpu/konami2/src/tests/cpu/opcode_idx.o \
       $(OBJ_DIR)/cpu/konami2/src/tests/cpu/opcode_imm.o \
       $(OBJ_DIR)/cpu/konami2/src/tests/cpu/opcode_inh.o

# code from this machine
OBJS += $(OBJ_DIR)/$(MAD_NAME).o \
        $(OBJ_DIR)/error_address.o \
        $(OBJ_DIR)/errors.o \
        $(OBJ_DIR)/print.o \
        $(OBJ_DIR)/screen.o \
        $(OBJ_DIR)/vector_table.o \
        $(OBJ_DIR)/version.o \
        $(OBJ_DIR)/menus/cpu_tests.o \
        $(OBJ_DIR)/menus/main.o \
        $(OBJ_DIR)/menus/memory_viewer.o \
        $(OBJ_DIR)/tests/auto.o \
        $(OBJ_DIR)/tests/input.o \
        $(OBJ_DIR)/tests/palette_ram.o \
        $(OBJ_DIR)/tests/sprite_ram.o \
        $(OBJ_DIR)/tests/tile1_ram.o \
        $(OBJ_DIR)/tests/tile2_ram.o

INCS = $(wildcard include/*.inc) \
       $(wildcard ../../../common/global/include/*.inc) \
       $(wildcard ../../../common/cpu/konami2/include/*.inc) \
       $(wildcard ../../../common/cpu/konami2/include/tests/*.inc)
       $(wildcard ../../../common/cpu/konami2/include/tests/*/*.inc)

$(WORK_DIR)/$(MAD_NAME).bin: include/error_codes.inc $(WORK_DIR) $(OBJ_DIR) $(BUILD_DIR) $(OBJS)
	$(VLINK) $(VLINK_FLAGS) -o $(WORK_DIR)/$(MAD_NAME).bin $(OBJS)
	../../../util/rom-inject-crc-mirror -x -r -m 17 -c 16 -f $(WORK_DIR)/$(MAD_NAME).bin -e big -t $(ROM_SIZE)
	$(DD) if=$(WORK_DIR)/$(MAD_NAME).bin of=$(BUILD_DIR)/$(ROM)

include/error_codes.inc: include/error_codes.cfg
	../../../util/gen-error-codes -b 6 include/error_codes.cfg include/error_codes.inc

src/version.asm:
	../../../util/gen-version-asm-file -m VENDETTA -i ../../../common/global/src/version.asm.in -o src/version.asm

$(OBJ_DIR)/%.o: src/%.asm $(INCS)
	$(VASM) $(VASM_FLAGS) $(BUILD_FLAGS) -o $@ $<

$(OBJ_DIR)/cpu/konami2/src/%.o: ../../../common/cpu/konami2/src/%.asm $(INCS)
	 $(VASM) $(VASM_FLAGS) $(BUILD_FLAGS) -o $@ $<

$(WORK_DIR):
	$(MKDIR) -p $(WORK_DIR)

$(OBJ_DIR):
	$(MKDIR) -p $(OBJ_DIR)/tests $(OBJ_DIR)/menus/ $(OBJ_DIR)/cpu/konami2/src/tests/cpu $(OBJ_DIR)/cpu/konami2/src/handlers/

.PHONY: src/version.asm

clean:
	rm -fr $(BUILD_DIR)/

