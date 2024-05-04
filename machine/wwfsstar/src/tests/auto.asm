	include "cpu/68000/macros.inc"
	include "cpu/68000/tests/auto.inc"

	global AUTO_DSUB_LIST
	global AUTO_FUNC_LIST

	section data

AUTO_DSUB_LIST:
	AUTO_ENTRY auto_diag_rom_address_test_dsub, STR_TESTING_DIAG_ROM_ADDRESS
	AUTO_ENTRY auto_diag_rom_crc32_test_dsub, STR_TESTING_DIAG_ROM_CRC32
	AUTO_ENTRY auto_work_ram_tests_dsub, STR_TESTING_WORK_RAM
	AUTO_LIST_END

AUTO_FUNC_LIST:
	AUTO_ENTRY auto_bg_ram_tests, STR_TESTING_FG_RAM
	AUTO_ENTRY auto_fg_ram_tests, STR_TESTING_FG_RAM
; disabling palette tests for now.  Its 12bits with the upper nibble
; of the high byte not wired up on the ram chip.  Seeing some weirdness
; where the lower nibble of the high byte is failing the data ram
; test, but all other tests pass (including march).  Need to see if
; its some issue with my board or if there is some timing issue
; because the rendering system is also accessing the palette data.
;	AUTO_ENTRY auto_palette_ram_tests, STR_TESTING_PALETTE_RAM
	AUTO_ENTRY auto_sprite_ram_tests, STR_TESTING_SPRITE_RAM
	AUTO_LIST_END

STR_TESTING_BG_RAM:		STRING "TESTING BG RAM"
STR_TESTING_DIAG_ROM_ADDRESS:	STRING "TESTING DIAG ROM ADDRESS"
STR_TESTING_DIAG_ROM_CRC32:	STRING "TESTING DIAG ROM CRC32"
STR_TESTING_FG_RAM:		STRING "TESTING FG RAM"
STR_TESTING_PALETTE_RAM:	STRING "TESTING PALETTE RAM"
STR_TESTING_SPRITE_RAM:		STRING "TESTING SPRITE RAM"
STR_TESTING_WORK_RAM:		STRING "TESTING WORK RAM"
