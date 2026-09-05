MAD_NAME=mad_finalizr
BUILD_FLAGS=-D_CPU_6809_ -D_DEBUG_HARDWARE_
ROM_SIZE=16384
ROM_TYPE=27c128
BUILD_DIR=build
OBJ_DIR=$(BUILD_DIR)/obj
WORK_DIR=$(BUILD_DIR)/work
ROM=523k03.13c

VASM = vasm6809_mot
VASM_FLAGS = -Fvobj -spaces -chklabels -Iinclude -I../../../common -wfail -quiet
VLINK = vlink
VLINK_FLAGS = -brawbin1 -T$(MAD_NAME).ld
MKDIR = mkdir
DD = dd

OBJS  = $(OBJ_DIR)/cpu/6x09/src/header.o \
        $(OBJ_DIR)/cpu/6x09/src/input_update.o \
        $(OBJ_DIR)/cpu/6x09/src/print_error.o \
        $(OBJ_DIR)/cpu/6x09/src/util.o \
        $(OBJ_DIR)/cpu/6x09/src/xy_string.o \
        $(OBJ_DIR)/cpu/6x09/src/debug/error_address_test.o \
        $(OBJ_DIR)/cpu/6x09/src/debug/mad_git_hash.o \
        $(OBJ_DIR)/cpu/6x09/src/handlers/auto_test.o \
        $(OBJ_DIR)/cpu/6x09/src/handlers/error.o \
        $(OBJ_DIR)/cpu/6x09/src/handlers/input_test.o \
        $(OBJ_DIR)/cpu/6x09/src/handlers/memory_viewer.o \
        $(OBJ_DIR)/cpu/6x09/src/handlers/menu.o \
        $(OBJ_DIR)/cpu/6x09/src/handlers/sound_test.o \
        $(OBJ_DIR)/cpu/6x09/src/handlers/tile_8x8_viewer.o \
        $(OBJ_DIR)/cpu/6x09/src/handlers/values_edit.o

OBJS += $(OBJ_DIR)/cpu/6809/src/footer.o \
        $(OBJ_DIR)/cpu/6809/src/memory_fill.o \
        $(OBJ_DIR)/cpu/6809/src/handlers/memory_tests.o \
        $(OBJ_DIR)/cpu/6809/src/tests/mad_rom.o \
        $(OBJ_DIR)/cpu/6809/src/tests/memory.o \
        $(OBJ_DIR)/cpu/6809/src/tests/work_ram.o

OBJS += $(OBJ_DIR)/$(MAD_NAME).o \
        $(OBJ_DIR)/error_address.o \
        $(OBJ_DIR)/errors.o \
        $(OBJ_DIR)/print.o \
        $(OBJ_DIR)/screen.o \
        $(OBJ_DIR)/util.o \
        $(OBJ_DIR)/vector_table.o \
        $(OBJ_DIR)/version.o \
        $(OBJ_DIR)/menus/debug.o \
        $(OBJ_DIR)/menus/graphics_viewer.o \
        $(OBJ_DIR)/menus/main.o \
        $(OBJ_DIR)/menus/memory_viewer.o \
        $(OBJ_DIR)/tests/input.o \
        $(OBJ_DIR)/tests/ram.o \
        $(OBJ_DIR)/tests/sound_m58715.o \
        $(OBJ_DIR)/tests/sound_sn76489a.o \
        $(OBJ_DIR)/tests/tile_scroll.o \
        $(OBJ_DIR)/viewers/k005885_tile_a.o \
        $(OBJ_DIR)/viewers/k005885_sprite.o


ifneq (,$(findstring _DEBUG_HARDWARE_,$(BUILD_FLAGS)))
OBJS += $(OBJ_DIR)/cpu/6x09/src/debug/hardware/ram_find.o \
        $(OBJ_DIR)/cpu/6x09/src/handlers/memory_write.o \
        $(OBJ_DIR)/debug/hardware/k005885_reg.o \
        $(OBJ_DIR)/debug/hardware/k005885_sprite.o \
        $(OBJ_DIR)/menus/debug_hardware.o
endif

INCS = $(wildcard ../../../common/global/include/*.inc) \
       $(wildcard ../../../common/global/include/*/*.inc) \
       $(wildcard ../../../common/global/include/*/*/*.inc) \
       $(wildcard ../../../common/global/include/*.inc) \
       $(wildcard ../../../common/cpu/6x09/include/*.inc) \
       $(wildcard ../../../common/cpu/6x09/include/*/*.inc) \
       $(wildcard ../../../common/cpu/6x09/include/*/*/*.inc) \
       $(wildcard ../../../common/cpu/6809/include/*.inc) \
       $(wildcard ../../../common/cpu/6809/include/*/*.inc) \
       $(wildcard ../../../common/cpu/6809/include/*/*/*.inc) \
       $(wildcard include/*.inc) \
       $(wildcard include/*/*.inc) \
       $(wildcard include/*/*/*.inc)

$(WORK_DIR)/$(MAD_NAME).bin: include/error_codes.inc $(WORK_DIR) $(BUILD_DIR) $(OBJS) ../README.md
	$(VLINK) $(VLINK_FLAGS) -o $(WORK_DIR)/$(MAD_NAME).bin $(OBJS)
	../../../util/mad-konami1-encode -i $(WORK_DIR)/$(MAD_NAME).bin -o $(WORK_DIR)/$(MAD_NAME).bin.enc
	../../../util/rom-inject-crc-mirror -x -r -m 17 -c 16 -f $(WORK_DIR)/$(MAD_NAME).bin.enc -e big -t $(ROM_SIZE)
	$(DD) if=$(WORK_DIR)/$(MAD_NAME).bin.enc of=$(BUILD_DIR)/$(ROM)

include/error_codes.inc: include/error_codes.cfg
	../../../util/gen-error-codes -b 6 include/error_codes.cfg include/error_codes.inc

../README.md: include/error_codes.inc ../../../common/cpu/6809/include/error_codes.inc
	../../../util/gen-error-codes-markdown-table -i include/error_codes.inc -i ../../../common/cpu/6809/include/error_codes.inc -c 6809 -t main -m ../README.md

src/version.asm:
	../../../util/gen-version-asm-file -m FINALIZR -i ../../../common/global/src/version.asm.in -o src/version.asm

$(OBJ_DIR)/%.o: src/%.asm $(INCS)
	@[ -d "$(@D)" ] || $(MKDIR) -p "$(@D)"
	$(VASM) $(VASM_FLAGS) $(BUILD_FLAGS) -o $@ $<

$(OBJ_DIR)/cpu/6809/src/%.o: ../../../common/cpu/6809/src/%.asm $(INCS)
	@[ -d "$(@D)" ] || $(MKDIR) -p "$(@D)"
	$(VASM) $(VASM_FLAGS) $(BUILD_FLAGS) -o $@ $<

$(OBJ_DIR)/cpu/6x09/src/%.o: ../../../common/cpu/6x09/src/%.asm $(INCS)
	@[ -d "$(@D)" ] || $(MKDIR) -p "$(@D)"
	$(VASM) $(VASM_FLAGS) $(BUILD_FLAGS) -o $@ $<

$(WORK_DIR):
	$(MKDIR) -p $(WORK_DIR)

.PHONY: src/version.asm

onerom: $(WORK_DIR)/$(MAD_NAME).bin
	onerom program --plugin usb --slot file=$(BUILD_DIR)/$(ROM),type=$(ROM_TYPE)

clean:
	rm -fr $(BUILD_DIR)
