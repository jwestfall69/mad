MAD_NAME=mad_cps1

BUILD_DIR=build/$(ROMSET)
OBJ_DIR=$(BUILD_DIR)/obj
WORK_DIR=$(BUILD_DIR)/work

VASM = vasmz80_oldstyle
VASM_FLAGS = -Fvobj -chklabels -Iinclude -I../../../common  -quiet
VLINK = vlink
VLINK_FLAGS = -brawbin1 -T$(MAD_NAME).ld
MKDIR = mkdir
DD = dd

OBJS = $(OBJ_DIR)/cpu/z80/src/crc32.o \
       $(OBJ_DIR)/cpu/z80/src/error_address.o \
       $(OBJ_DIR)/cpu/z80/src/psub.o \
       $(OBJ_DIR)/cpu/z80/src/util.o \
       $(OBJ_DIR)/cpu/z80/src/tests/mad_rom.o \
       $(OBJ_DIR)/cpu/z80/src/tests/memory.o \
       $(OBJ_DIR)/cpu/z80/src/tests/unexpected_irq.o \
       $(OBJ_DIR)/cpu/z80/src/tests/oki/msm6295.o

# code from this machine
OBJS += $(OBJ_DIR)/$(MAD_NAME).o \
        $(OBJ_DIR)/footer.o \
        $(OBJ_DIR)/vector_table.o \
        $(OBJ_DIR)/tests/irq.o \
        $(OBJ_DIR)/tests/msm6295.o \
        $(OBJ_DIR)/tests/ram.o

INCS = $(wildcard include/*.inc) \
       $(wildcard ../../../common/cpu/z80/include/*.inc) \
       $(wildcard ../../../common/cpu/z80/include/tests/*.inc)

$(WORK_DIR)/$(MAD_NAME).bin: $(WORK_DIR) $(OBJ_DIR) $(BUILD_DIR) $(OBJS)
	$(VLINK) $(VLINK_FLAGS) -o $(WORK_DIR)/$(MAD_NAME).bin $(OBJS)
	../../../util/rom-inject-crc-mirror -f $(WORK_DIR)/$(MAD_NAME).bin -e little -t $(ROM_SIZE)
	$(DD) if=$(WORK_DIR)/$(MAD_NAME).bin of=$(BUILD_DIR)/$(ROM)

$(OBJ_DIR)/%.o: src/%.asm $(INCS)
	$(VASM) $(VASM_FLAGS) $(BUILD_FLAGS) -o $@ $<

$(OBJ_DIR)/cpu/z80/src/%.o: ../../../common/cpu/z80/src/%.asm $(INCS)
	 $(VASM) $(VASM_FLAGS) $(BUILD_FLAGS) -o $@ $<

$(WORK_DIR):
	$(MKDIR) -p $(WORK_DIR)

$(OBJ_DIR):
	$(MKDIR) -p $(OBJ_DIR)/tests $(OBJ_DIR)/cpu/z80/src/tests/oki

clean:
	rm -fr $(BUILD_DIR)/

