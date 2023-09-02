DIAG=cps1_diag

BUILD_DIR=build/$(ROMSET)
OBJ_DIR=$(BUILD_DIR)/obj
WORK_DIR=$(BUILD_DIR)/work

VASM = vasmm68k_mot
VASM_FLAGS = -Fvobj -m68000 -spaces -chklabels -Iinclude -I../../common/include  -quiet
VLINK = vlink
VLINK_FLAGS = -brawbin1 -Tdiag_rom.ld
MKDIR = mkdir
DD = dd

OBJS = $(OBJ_DIR)/cpu/68000/auto_test.o \
       $(OBJ_DIR)/cpu/68000/crc32.o \
       $(OBJ_DIR)/cpu/68000/dsub.o \
       $(OBJ_DIR)/cpu/68000/error_handler.o \
       $(OBJ_DIR)/cpu/68000/input.o \
       $(OBJ_DIR)/cpu/68000/main_menu_handler.o \
       $(OBJ_DIR)/cpu/68000/memory.o \
       $(OBJ_DIR)/cpu/68000/print_error.o \
       $(OBJ_DIR)/cpu/68000/util.o \
       $(OBJ_DIR)/cpu/68000/xy_string.o 

# code from this machine
OBJS += $(OBJ_DIR)/auto_test_table.o \
        $(OBJ_DIR)/diag_rom.o \
        $(OBJ_DIR)/error_table.o \
        $(OBJ_DIR)/footer.o \
        $(OBJ_DIR)/main_menu.o \
        $(OBJ_DIR)/main_menu_table.o \
        $(OBJ_DIR)/print.o \
        $(OBJ_DIR)/util.o \
        $(OBJ_DIR)/vector_table.o \
        $(OBJ_DIR)/$(DIAG).o

INCS = $(wildcard include/*.inc) \
       $(wildcard ../../common/include/cpu/68000/*.inc)

$(WORK_DIR)/$(DIAG).bin: $(WORK_DIR) $(OBJ_DIR) $(BUILD_DIR) $(OBJS)
	$(VLINK) $(VLINK_FLAGS) -o $(WORK_DIR)/$(DIAG).bin $(OBJS)
	../../util/rom-inject-crc-mirror -f $(WORK_DIR)/$(DIAG).bin -t $(ROM_SIZE)
ifdef ROMB
	../../util/rom-byte-split $(WORK_DIR)/$(DIAG).bin $(BUILD_DIR)/$(ROMA) $(BUILD_DIR)/$(ROMB)
else ifdef ROMA
	$(DD) if=$(WORK_DIR)/$(DIAG).bin of=$(BUILD_DIR)/$(ROMA) conv=swab
else
	@echo "ERROR"
endif

$(OBJ_DIR)/%.o: src/%.asm $(INCS)
	$(VASM) $(VASM_FLAGS) $(ROMSET_CFLAGS) -o $@ $< 

$(OBJ_DIR)/cpu/68000/%.o: ../../common/src/cpu/68000/%.asm $(INCS)
	 $(VASM) $(VASM_FLAGS) $(ROMSET_CFLAGS) -o $@ $<

$(WORK_DIR):
	$(MKDIR) -p $(WORK_DIR)

$(OBJ_DIR):
	$(MKDIR) -p $(OBJ_DIR)/cpu/68000

clean:
	rm -fr $(BUILD_DIR)/

