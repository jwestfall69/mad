DIAG=wwfwfest_diag
ROM_SIZE=524288
ROMA=31e14-0.ic18
ROMB=31e13-0.ic19

BUILD_DIR=build
OBJ_DIR=$(BUILD_DIR)/obj
WORK_DIR=$(BUILD_DIR)/work

VASM = vasmm68k_mot
VASM_FLAGS = -Fvobj -m68000 -spaces -chklabels -Iinclude -I../../common/include  -quiet
VLINK = vlink
VLINK_FLAGS = -brawbin1 -Tdiag_rom.ld
MKDIR = mkdir
DD = dd

OBJS = $(OBJ_DIR)/cpu/68000/crc32.o \
       $(OBJ_DIR)/cpu/68000/dsub.o \
       $(OBJ_DIR)/cpu/68000/input_update.o \
       $(OBJ_DIR)/cpu/68000/memory_fill.o \
       $(OBJ_DIR)/cpu/68000/menu_input_generic.o \
       $(OBJ_DIR)/cpu/68000/print_error.o \
       $(OBJ_DIR)/cpu/68000/util.o \
       $(OBJ_DIR)/cpu/68000/xy_string.o \
       $(OBJ_DIR)/cpu/68000/handlers/error.o \
       $(OBJ_DIR)/cpu/68000/handlers/memory_tests.o \
       $(OBJ_DIR)/cpu/68000/handlers/memory_viewer.o \
       $(OBJ_DIR)/cpu/68000/handlers/menu.o \
       $(OBJ_DIR)/cpu/68000/tests/auto.o \
       $(OBJ_DIR)/cpu/68000/tests/diag_rom.o \
       $(OBJ_DIR)/cpu/68000/tests/input.o \
       $(OBJ_DIR)/cpu/68000/tests/memory.o

# code from this machine
OBJS += $(OBJ_DIR)/$(DIAG).o \
        $(OBJ_DIR)/errors.o \
        $(OBJ_DIR)/footer.o \
        $(OBJ_DIR)/main_menu.o \
        $(OBJ_DIR)/memory_viewer_menu.o \
        $(OBJ_DIR)/print.o \
        $(OBJ_DIR)/screen.o \
        $(OBJ_DIR)/vector_table.o \
        $(OBJ_DIR)/tests/auto.o \
        $(OBJ_DIR)/tests/bg1_ram.o \
        $(OBJ_DIR)/tests/bg2_ram.o \
        $(OBJ_DIR)/tests/fg_ram.o \
        $(OBJ_DIR)/tests/input.o \
        $(OBJ_DIR)/tests/sprite_ram.o \
        $(OBJ_DIR)/tests/work_ram.o

INCS = $(wildcard include/*.inc) \
       $(wildcard ../../common/include/cpu/68000/*.inc) \
       $(wildcard ../../common/include/cpu/68000/tests/*.inc)

$(WORK_DIR)/$(DIAG).bin: $(WORK_DIR) $(OBJ_DIR) $(BUILD_DIR) $(OBJS)
	$(VLINK) $(VLINK_FLAGS) -o $(WORK_DIR)/$(DIAG).bin $(OBJS)
	../../util/rom-inject-crc-mirror -f $(WORK_DIR)/$(DIAG).bin -t $(ROM_SIZE)
	../../util/rom-byte-split $(WORK_DIR)/$(DIAG).bin $(BUILD_DIR)/$(ROMA) $(BUILD_DIR)/$(ROMB)

$(OBJ_DIR)/%.o: src/%.asm $(INCS)
	$(VASM) $(VASM_FLAGS) -o $@ $<

$(OBJ_DIR)/cpu/68000/%.o: ../../common/src/cpu/68000/%.asm $(INCS)
	 $(VASM) $(VASM_FLAGS) -o $@ $<

$(WORK_DIR):
	$(MKDIR) -p $(WORK_DIR)

$(OBJ_DIR):
	$(MKDIR) -p $(OBJ_DIR)/tests $(OBJ_DIR)/cpu/68000/handlers $(OBJ_DIR)/cpu/68000/tests

clean:
	rm -fr $(BUILD_DIR)/

