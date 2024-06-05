	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/handlers/menu.inc"

	include "machine.inc"
	include "mad_rom.inc"

	global main_menu

	section code

main_menu:
		move.b	#0, MENU_CURSOR

	.loop_menu:
		RSUB	screen_init

		SEEK_XY	3, 3
		lea	STR_MENU_TITLE, a0
		RSUB	print_string

		lea	MENU_LIST, a0
		jsr	menu_handler

		bra	.loop_menu

	section data

STR_DEBUG_MENU:			STRING "DEBUG MENU"
STR_INPUT_TEST:			STRING "INPUT TEST"
STR_MEMORY_VIEWER:		STRING "MEMORY VIEWER"
STR_PALETTE_RAM_TEST:		STRING "PALETTE RAM TEST"
STR_PALETTE_EXT_RAM_TEST:	STRING "PALETTE EXT RAM TEST"
STR_SOUND_TEST:			STRING "SOUND TEST"
STR_SPRITE_RAM_TEST:		STRING "SPRITE RAM TEST"
STR_TILE1_RAM_TEST:		STRING "TILE1 RAM TEST"
STR_TILE2_RAM_TEST:		STRING "TILE2 RAM TEST"
STR_TILE3_RAM_TEST:		STRING "TILE3 RAM TEST"
STR_WORK_RAM_TEST:		STRING "WORK RAM TEST"
STR_VIDEO_DAC_TEST:		STRING "VIDEO DAC TEST"

STR_MENU_TITLE:			STRING "MAIN MENU"

	align 2

MENU_LIST:
	MENU_ENTRY manual_work_ram_tests, STR_WORK_RAM_TEST
	MENU_ENTRY manual_palette_ram_tests, STR_PALETTE_RAM_TEST
	MENU_ENTRY manual_palette_ext_ram_tests, STR_PALETTE_EXT_RAM_TEST
	MENU_ENTRY manual_sprite_ram_tests, STR_SPRITE_RAM_TEST
	MENU_ENTRY manual_tile1_ram_tests, STR_TILE1_RAM_TEST
	MENU_ENTRY manual_tile2_ram_tests, STR_TILE2_RAM_TEST
	MENU_ENTRY manual_tile3_ram_tests, STR_TILE3_RAM_TEST
	MENU_ENTRY input_test, STR_INPUT_TEST
	MENU_ENTRY sound_test, STR_SOUND_TEST
	MENU_ENTRY video_dac_test, STR_VIDEO_DAC_TEST
	MENU_ENTRY memory_viewer_menu, STR_MEMORY_VIEWER
	MENU_ENTRY debug_menu, STR_DEBUG_MENU
	MENU_LIST_END
