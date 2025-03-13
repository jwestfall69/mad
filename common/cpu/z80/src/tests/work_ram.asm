	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/z80/include/macros.inc"
	include "cpu/z80/include/dsub.inc"
	include "cpu/z80/include/xy_string.inc"

	include "error_codes.inc"
	include "machine.inc"
	include "mad.inc"

	global auto_work_ram_tests_dsub

	ifnd _HEADLESS_

	include "input.inc"
	global manual_work_ram_tests

	endif

	section code

auto_work_ram_tests_dsub:
		exx

		ld	hl, WORK_RAM_START
		PSUB	memory_output_test
		jr	z, .test_passed_output
		ld	a, EC_WORK_RAM_OUTPUT
		jp	error_address

	.test_passed_output:
		ld	hl, WORK_RAM_START
		PSUB	memory_write_test
		jr	z, .test_passed_write
		ld	a, EC_WORK_RAM_WRITE
		jp	error_address

	.test_passed_write:
		ld	hl, WORK_RAM_START
		ld	de, WORK_RAM_SIZE
		ld	b, $00
		PSUB	memory_data_pattern_test
		jr	nz, .test_failed_data

		ld	hl, WORK_RAM_START
		ld	de, WORK_RAM_SIZE
		ld	b, $55
		PSUB	memory_data_pattern_test
		jr	nz, .test_failed_data

		ld	hl, WORK_RAM_START
		ld	de, WORK_RAM_SIZE
		ld	b, $aa
		PSUB	memory_data_pattern_test
		jr	nz, .test_failed_data

		ld	hl, WORK_RAM_START
		ld	de, WORK_RAM_SIZE
		ld	b, $ff
		PSUB	memory_data_pattern_test
		jr	nz, .test_failed_data

		ld	hl, WORK_RAM_START
		ld	b, WORK_RAM_ADDRESS_LINES
		PSUB	memory_address_test
		jr	z, .test_passed_address
		ld	a, EC_WORK_RAM_ADDRESS
		jp	error_address

	.test_passed_address:
		ld	hl, WORK_RAM_START
		ld	de, WORK_RAM_SIZE
		PSUB	memory_march_test
		jr	z, .test_passed_march
		ld	a, EC_WORK_RAM_MARCH
		jp	error_address

	.test_passed_march:
		DSUB_RETURN

	.test_failed_data:
		ld	a, EC_WORK_RAM_DATA
		jp	error_address

	ifnd _HEADLESS_

manual_work_ram_tests:
		ld	de, d_screen_xys_list
		call	print_xy_string_list

		ld	bc, 0
		ld	(R_WORK_RAM_PASSES), bc

		DSUB_MODE_PSUB

	.loop_next_pass:
		SEEK_XY	SCREEN_PASSES_VALUE_X, SCREEN_PASSES_Y
		ld	bc, (R_WORK_RAM_PASSES)
		PSUB	print_hex_word

		PSUB	auto_work_ram_tests

		ld	b, INPUT_B2
		PSUB	check_button_press
		cp	1
		jr	z, .test_exit

		ld	bc, (R_WORK_RAM_PASSES)
		inc	bc
		ld	(R_WORK_RAM_PASSES), bc
		jr	.loop_next_pass

	.test_exit:
		ld	a, 0
		ld	(r_menu_cursor), a

		DSUB_MODE_RSUB

		jp	main_menu

	section data

d_screen_xys_list:
	XY_STRING SCREEN_START_X, SCREEN_PASSES_Y, "PASSES"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END

	endif
