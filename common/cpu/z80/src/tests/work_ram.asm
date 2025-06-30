	include "cpu/z80/include/common.inc"

	global auto_work_ram_tests_dsub

	ifnd _HEADLESS_

	global manual_work_ram_tests

	endif

	section code

auto_work_ram_tests_dsub:
		exx

	ifnd _HEADLESS_
		SEEK_LN	SCREEN_START_Y
		PSUB	print_clear_line

		SEEK_XY SCREEN_START_X, SCREEN_START_Y
		ld	de, d_str_testing_work_ram
		PSUB	print_string
	endif

		ld	hl, WORK_RAM
		PSUB	memory_output_test
		jp	nz, .test_failed_output

		ld	hl, WORK_RAM
		PSUB	memory_write_test
		jp	nz, .test_failed_write

		ld	hl, WORK_RAM
		ld	de, WORK_RAM_SIZE
		ld	b, $00
		PSUB	memory_data_pattern_test
		jp	nz, .test_failed_data

		ld	hl, WORK_RAM
		ld	de, WORK_RAM_SIZE
		ld	b, $55
		PSUB	memory_data_pattern_test
		jp	nz, .test_failed_data

		ld	hl, WORK_RAM
		ld	de, WORK_RAM_SIZE
		ld	b, $aa
		PSUB	memory_data_pattern_test
		jp	nz, .test_failed_data

		ld	hl, WORK_RAM
		ld	de, WORK_RAM_SIZE
		ld	b, $ff
		PSUB	memory_data_pattern_test
		jp	nz, .test_failed_data

		ld	hl, WORK_RAM
		ld	b, WORK_RAM_ADDRESS_LINES
		PSUB	memory_address_test
		jp	nz, .test_failed_address

		ld	hl, WORK_RAM
		ld	de, WORK_RAM_SIZE
		PSUB	memory_march_test
		jp	nz, .test_failed_march
		DSUB_RETURN

	; NOTE: PSUB'ing print_error_work_ram_memory
	; actually makes us nest too deep causing us to
	; lose the return point for auto_work_ram_tests_psub.
	; However this doesn't matter because in the case
	; of a failed work ram test we won't be returning
	.test_failed_address:
	ifnd _HEADLESS_

		PSUB	print_error_work_ram_memory

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ld	de, d_str_work_ram_address
		PSUB	print_string

		ld	b, EC_WORK_RAM_ADDRESS
	;	PSUB	sound_play_byte
	endif

		ld	a, EC_WORK_RAM_ADDRESS
		jp	error_address

	.test_failed_data:
	ifnd _HEADLESS_

		PSUB	print_error_work_ram_memory

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ld	de, d_str_work_ram_data
		PSUB	print_string

		ld	b, EC_WORK_RAM_DATA
	;	PSUB	sound_play_byte
	endif

		ld	a, EC_WORK_RAM_DATA
		jp	error_address

	.test_failed_march:
	ifnd _HEADLESS_
		PSUB	print_error_work_ram_memory

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ld	de, d_str_work_ram_march
		PSUB	print_string

		ld	b, EC_WORK_RAM_MARCH
	;	PSUB	sound_play_byte
	endif

		ld	a, EC_WORK_RAM_MARCH
		jp	error_address

	.test_failed_output:
	ifnd _HEADLESS_
		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ld	de, d_str_work_ram_output
		PSUB	print_string

		ld	b, EC_WORK_RAM_OUTPUT
	;	PSUB	sound_play_byte
	endif

		ld	a, EC_WORK_RAM_OUTPUT
		jp	error_address

	.test_failed_write:
	ifnd _HEADLESS_
		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ld	de, d_str_work_ram_write
		PSUB	print_string

		ld	b, EC_WORK_RAM_WRITE
	;	PSUB	sound_play_byte
	endif

		ld	a, EC_WORK_RAM_WRITE
		jp	error_address


	ifnd _HEADLESS_
; This is a special print error memory function for
; work ram since we are only able to use registers
; during the tests and print errors.
; params:
;  b = expected value
;  c = actual value
;  hl = failed address
print_error_work_ram_memory_dsub:
		exx

		; backup bc to bc'
		ld	a, b
		exx
		ld	b, a
		exx
		ld	a, c
		exx
		ld	c, a
		exx

		; address value
		SEEK_XY	(SCREEN_START_X + 10), (SCREEN_START_Y + 2)
		ld	b, h
		ld	c, l
		PSUB	print_hex_word

		; restore
		exx

		; actual value
		SEEK_XY	(SCREEN_START_X + 12), (SCREEN_START_Y + 4)
		PSUB	print_hex_byte

		; expected value
		SEEK_XY	(SCREEN_START_X + 12), (SCREEN_START_Y + 3)
		ld	c, b
		PSUB	print_hex_byte

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 2)
		ld	de, d_str_address
		PSUB	print_string

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 3)
		ld	de, d_str_expected
		PSUB	print_string

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 4)
		ld	de, d_str_actual
		PSUB	print_string
		DSUB_RETURN

	endif

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

; These are padded so we fully overwrite "TESTING WORK RAM"
d_str_work_ram_address:		STRING "WORK RAM ADDRESS"
d_str_work_ram_data:		STRING "WORK RAM DATA   "
d_str_work_ram_march:		STRING "WORK RAM MARCH  "
d_str_work_ram_output:		STRING "WORK RAM OUTPUT "
d_str_work_ram_write:		STRING "WORK RAM WRITE  "

d_str_testing_work_ram: 	STRING "TESTING WORK RAM"

	endif
