MAD_NAME=mad_contra
BUILD_FLAGS=-D_CPU_6809_ -D_HEADLESS_
ROM_SIZE=32768
BUILD_DIR=build
OBJ_DIR=$(BUILD_DIR)/obj
WORK_DIR=$(BUILD_DIR)/work
ROM=633e01.12a

VASM = vasm6809_mot
VASM_FLAGS = -Fvobj -spaces -chklabels -Iinclude -I../../../common -wfail -quiet
VLINK = vlink
VLINK_FLAGS = -brawbin1 -T$(MAD_NAME).ld
MKDIR = mkdir
DD = dd

# global includes/code
INCS += $(wildcard ../../../common/global/include/*.inc)
INCS += $(wildcard ../../../common/cpu/6809/include/*.inc)
INCS += $(wildcard ../../../common/cpu/6809/include/tests/*.inc)
INCS += $(wildcard ../../../common/cpu/6809/include/tests/*/*.inc)

OBJS += $(OBJ_DIR)/cpu/6809/src/error_address.o
OBJS += $(OBJ_DIR)/cpu/6809/src/footer.o
OBJS += $(OBJ_DIR)/cpu/6809/src/tests/mad_rom.o
OBJS += $(OBJ_DIR)/cpu/6809/src/tests/memory.o
OBJS += $(OBJ_DIR)/cpu/6809/src/tests/work_ram.o
OBJS += $(OBJ_DIR)/cpu/6809/src/tests/yamaha/ym2151.o

# machine specific includes/code
INCS += $(wildcard include/*.inc)

OBJS += $(OBJ_DIR)/$(MAD_NAME).o
OBJS += $(OBJ_DIR)/vector_table.o
OBJS += $(OBJ_DIR)/version.o
OBJS += $(OBJ_DIR)/tests/ym2151.o

$(WORK_DIR)/$(MAD_NAME).bin: include/error_codes.inc $(WORK_DIR) $(BUILD_DIR) $(OBJS) ../README.md
	$(VLINK) $(VLINK_FLAGS) -o $(WORK_DIR)/$(MAD_NAME).bin $(OBJS)
	../../../util/rom-inject-crc-mirror -x -r -m 17 -c 16 -f $(WORK_DIR)/$(MAD_NAME).bin -e big -t $(ROM_SIZE)
	$(DD) if=$(WORK_DIR)/$(MAD_NAME).bin of=$(BUILD_DIR)/$(ROM)

include/error_codes.inc: include/error_codes.cfg
	../../../util/gen-error-codes -b 6 include/error_codes.cfg include/error_codes.inc

../README.md: include/error_codes.inc ../../../common/cpu/6809/include/error_codes.inc
	../../../util/gen-error-codes-markdown-table -i include/error_codes.inc -i ../../../common/cpu/6809/include/error_codes.inc -c 6809 -t sound -m ../README.md

src/version.asm:
	../../../util/gen-version-asm-file -m CONTRA -i ../../../common/global/src/version.asm.in -o src/version.asm

$(OBJ_DIR)/%.o: src/%.asm $(INCS)
	@[ -d "$(@D)" ] || $(MKDIR) -p "$(@D)"
	$(VASM) $(VASM_FLAGS) $(BUILD_FLAGS) -o $@ $<

$(OBJ_DIR)/cpu/6809/src/%.o: ../../../common/cpu/6809/src/%.asm $(INCS)
	@[ -d "$(@D)" ] || $(MKDIR) -p "$(@D)"
	$(VASM) $(VASM_FLAGS) $(BUILD_FLAGS) -o $@ $<

$(WORK_DIR):
	$(MKDIR) -p $(WORK_DIR)

.PHONY: src/version.asm

clean:
	rm -fr $(BUILD_DIR)
