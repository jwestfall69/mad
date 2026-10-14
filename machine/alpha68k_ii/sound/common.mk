MAD_NAME=mad_alpha68k_ii

ROM_SIZE=65536
OBJ_DIR=$(BUILD_DIR)/obj
WORK_DIR=$(BUILD_DIR)/work

VASM = vasmz80_mot
VASM_FLAGS = -Fvobj -spaces -chklabels -Iinclude -I../../../common -wfail -quiet
VLINK = vlink
VLINK_FLAGS = -brawbin1 -T$(MAD_NAME).ld
MKDIR = mkdir
DD = dd

# global includes/code
INCS += $(wildcard ../../../common/global/include/*.inc)
INCS += $(wildcard ../../../common/global/include/*/*.inc)
INCS += $(wildcard ../../../common/cpu/z80/include/*.inc)
INCS += $(wildcard ../../../common/cpu/z80/include/tests/*.inc)

OBJS += $(OBJ_DIR)/cpu/z80/src/crc32.o
OBJS += $(OBJ_DIR)/cpu/z80/src/dsub.o
OBJS += $(OBJ_DIR)/cpu/z80/src/error_address.o
OBJS += $(OBJ_DIR)/cpu/z80/src/footer.o
OBJS += $(OBJ_DIR)/cpu/z80/src/util.o
OBJS += $(OBJ_DIR)/cpu/z80/src/tests/unexpected_irq.o
OBJS += $(OBJ_DIR)/cpu/z80/src/tests/mad_rom.o
OBJS += $(OBJ_DIR)/cpu/z80/src/tests/memory.o
OBJS += $(OBJ_DIR)/cpu/z80/src/tests/work_ram.o
OBJS += $(OBJ_DIR)/cpu/z80/src/tests/yamaha/ym2203_ioreq.o

# machine specific includes/code
INCS += $(wildcard include/*.inc)

OBJS += $(OBJ_DIR)/$(MAD_NAME).o
OBJS += $(OBJ_DIR)/vector_table.o
OBJS += $(OBJ_DIR)/version.o
OBJS += $(OBJ_DIR)/tests/ym2203.o

$(WORK_DIR)/$(MAD_NAME).bin: include/error_codes.inc $(WORK_DIR) $(BUILD_DIR) $(OBJS) ../README.md
	$(VLINK) $(VLINK_FLAGS) -o $(WORK_DIR)/$(MAD_NAME).bin $(OBJS)
	../../../util/rom-inject-crc-mirror -f $(WORK_DIR)/$(MAD_NAME).bin -e little -t $(ROM_SIZE)
	$(DD) if=$(WORK_DIR)/$(MAD_NAME).bin of=$(BUILD_DIR)/$(ROM)

include/error_codes.inc: include/error_codes.cfg
	../../../util/gen-error-codes -b 6 include/error_codes.cfg include/error_codes.inc

../README.md: include/error_codes.inc ../../../common/cpu/z80/include/error_codes.inc
	../../../util/gen-error-codes-markdown-table -i include/error_codes.inc -i ../../../common/cpu/z80/include/error_codes.inc -c z80 -t sound -m ../README.md

src/version.asm:
	../../../util/gen-version-asm-file -m ALPHA68KII -i ../../../common/global/src/version.asm.in -o src/version.asm

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
