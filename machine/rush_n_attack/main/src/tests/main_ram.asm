	include "cpu/z80/include/common.inc"

	global manual_main_ram_tests

	section code

manual_main_ram_tests:
		call	print_passes
		call	print_b2_return_to_menu

		ld	bc, 0
		ld	(R_WORK_RAM_PASSES), bc

		DSUB_MODE_PSUB

	.loop_next_pass:
		SEEK_XY	SCREEN_PASSES_VALUE_X, SCREEN_PASSES_Y
		ld	bc, (R_WORK_RAM_PASSES)
		PSUB	print_hex_word

		PSUB	auto_work_ram_tests

		GET_INPUT

		bit	INPUT_B1_BIT, a
		jr	nz, .test_paused

		bit	INPUT_B2_BIT, a
		jr	nz, .test_exit

		ld	bc, (R_WORK_RAM_PASSES)
		inc	bc
		ld	(R_WORK_RAM_PASSES), bc
		jr	.loop_next_pass


	.test_paused:
		DSUB_MODE_RSUB

		NSUB	screen_init_no_scroll_clear

		SEEK_XY SCREEN_START_X, SCREEN_START_Y
		ld	de, d_str_testing_work_ram
		RSUB	print_string

		SEEK_XY SCREEN_START_X, SCREEN_B1_Y
		ld	de, d_str_b1_pause
		NSUB	print_string

		call	print_passes
		call	print_b2_return_to_menu

		SEEK_XY	SCREEN_PASSES_VALUE_X, SCREEN_PASSES_Y
		ld	bc, (R_WORK_RAM_PASSES)
		NSUB	print_hex_word

		ld	b, INPUT_B1
		call	wait_button_release

		DSUB_MODE_PSUB
		jp	.loop_next_pass

	.test_exit:
		ld	a, 0
		ld	(r_menu_cursor), a

		DSUB_MODE_RSUB

		jp	main_menu

	section data

d_str_b1_pause:
	STRING "B1 - PAUSE"
