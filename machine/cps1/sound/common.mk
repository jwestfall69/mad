MAD_NAME=mad_cps1
BUILD_FLAGS=-D_HEADLESS_
BUILD_DIR=build/$(ROMSET)
OBJ_DIR=$(BUILD_DIR)/obj
WORK_DIR=$(BUILD_DIR)/work

VASM = vasmz80_mot
VASM_FLAGS = -Fvobj -spaces -chklabels -Iinclude -I../../../common  -quiet
VLINK = vlink
VLINK_FLAGS = -brawbin1 -T$(MAD_NAME).ld
MKDIR = mkdir
DD = dd

OBJS = $(OBJ_DIR)/cpu/z80/src/crc32.o \
       $(OBJ_DIR)/cpu/z80/src/dsub.o \
       $(OBJ_DIR)/cpu/z80/src/error_address.o \
       $(OBJ_DIR)/cpu/z80/src/footer.o \
       $(OBJ_DIR)/cpu/z80/src/util.o \
       $(OBJ_DIR)/cpu/z80/src/tests/mad_rom.o \
       $(OBJ_DIR)/cpu/z80/src/tests/memory.o \
       $(OBJ_DIR)/cpu/z80/src/tests/unexpected_irq.o \
       $(OBJ_DIR)/cpu/z80/src/tests/work_ram.o \
       $(OBJ_DIR)/cpu/z80/src/tests/oki/msm6295_mreq.o \
       $(OBJ_DIR)/cpu/z80/src/tests/yamaha/ym2151_mreq.o

# code from this machine
OBJS += $(OBJ_DIR)/$(MAD_NAME).o \
        $(OBJ_DIR)/vector_table.o \
        $(OBJ_DIR)/version.o \
        $(OBJ_DIR)/tests/bank_switch.o \
        $(OBJ_DIR)/tests/mcpu_latch.o \
        $(OBJ_DIR)/tests/msm6295.o \
        $(OBJ_DIR)/tests/ym2151.o

INCS = $(wildcard include/*.inc) \
       $(wildcard ../../../common/global/include/*.inc) \
       $(wildcard ../../../common/global/include/*/*.inc) \
       $(wildcard ../../../common/cpu/z80/include/*.inc) \
       $(wildcard ../../../common/cpu/z80/include/tests/*.inc)

$(WORK_DIR)/$(MAD_NAME).bin: include/error_codes.inc $(WORK_DIR) $(BUILD_DIR) $(OBJS)
	$(VLINK) $(VLINK_FLAGS) -o $(WORK_DIR)/$(MAD_NAME).bin $(OBJS)
	../../../util/rom-inject-crc-mirror -f $(WORK_DIR)/$(MAD_NAME).bin -e little -t $(ROM_SIZE)
	$(DD) if=$(WORK_DIR)/$(MAD_NAME).bin of=$(BUILD_DIR)/$(ROM)

include/error_codes.inc: include/error_codes.cfg
	../../../util/gen-error-codes -b 6 include/error_codes.cfg include/error_codes.inc

src/version.asm:
	../../../util/gen-version-asm-file -m CPS1 -i ../../../common/global/src/version.asm.in -o src/version.asm

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
