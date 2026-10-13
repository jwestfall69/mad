	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/memory_tests.inc"

	global auto_bg_tile_ram_tests
	global manual_bg_tile_ram_tests

	section code

auto_bg_tile_ram_tests:
		ld	a, $3
		out	(IO_BG_RAM_BANK), a
		ld	ix, d_mt_data
		call	memory_tests_handler

		ld	a, $2
		out	(IO_BG_RAM_BANK), a
		ld	ix, d_mt_data
		call	memory_tests_handler

		ld	a, $1
		out	(IO_BG_RAM_BANK), a
		ld	ix, d_mt_data
		call	memory_tests_handler

		ld	a, $0
		out	(IO_BG_RAM_BANK), a
		ld	ix, d_mt_data
		call	memory_tests_handler
		ret

manual_bg_tile_ram_tests:
		ld	de, d_screen_xys_list
		call	print_xy_string_list
		call	print_passes
		call	print_b2_return_to_menu

		ld	bc, 0		; # of passes

	.loop_next_pass:
		WATCHDOG

		SEEK_XY	SCREEN_PASSES_VALUE_X, SCREEN_PASSES_Y
		push	bc
		RSUB	print_hex_word

		call	auto_bg_tile_ram_tests
		jr	nz, .test_failed

		call	input_update
		ld	a, (r_input_edge)
		bit	INPUT_B2_BIT, a
		jr	nz, .test_exit

		bit	INPUT_B1_BIT, a
		jr	nz, .test_paused

		pop	bc
		inc	bc

		jr	.loop_next_pass

	.test_failed:
		call	error_handler

	.test_paused:
		ld	b, INPUT_B1
		call	wait_button_release
		pop	bc
		jr	.loop_next_pass

	.test_exit:
		pop bc
		ret

	section data

d_mt_data:
	MT_PARAMS BG_TILE_RAM, BG_TILE_RAM_SIZE, BG_TILE_RAM_ADDRESS_LINES, BG_TILE_RAM_BASE_EC, MT_FLAG_NONE

d_screen_xys_list:
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - PAUSE"
	XY_STRING_LIST_END
