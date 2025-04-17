RTL_FLAG_NONE		equ $00
RTL_FLAG_PAUSE_REDRAW	equ $01	; force a full screen redraw on pause
RTL_FLAG_AUTO_OVERRIDE	equ $02	; don't generate auto_x_ram_tests function

	; params:
	;  1 = lowercase of the ram name
	;  2 = uppercase of the ram name
	;  3 = rtl flags
	;  4 = mt flags
	macro RAM_TEST_LOGIC

	global auto_\1_ram_tests
	global manual_\1_ram_tests

	section code

	ifeq \3 & RTL_FLAG_AUTO_OVERRIDE
auto_\1_ram_tests:
		ld	ix, d_mt_data
		call	memory_tests_handler
		ret
	endif

manual_\1_ram_tests:
		ld	de, d_screen_xys_list
		call	print_xy_string_list

		ld	bc, 0		; # of passes

	.loop_next_pass:
		WATCHDOG

		SEEK_XY	SCREEN_PASSES_VALUE_X, SCREEN_PASSES_Y
		push	bc
		RSUB	print_hex_word

		call	auto_\1_ram_tests
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

	if \3 & RTL_FLAG_PAUSE_REDRAW
		RSUB	screen_init

		ld	de, d_screen_xys_list
		call	print_xy_string_list

		SEEK_XY	SCREEN_PASSES_VALUE_X, SCREEN_PASSES_Y
		pop	bc
		push	bc
		RSUB	print_hex_word
	endif
		ld	b, INPUT_B1
		call	wait_button_release
		pop	bc
		jr	.loop_next_pass

	.test_exit:
		pop bc
		ret

	section data

d_mt_data:
	MT_PARAMS \2_RAM_START, \2_RAM_SIZE, \2_RAM_ADDRESS_LINES, \2_RAM_BASE_EC, \4

d_screen_xys_list:
	if \3 & RTL_FLAG_PAUSE_REDRAW
		XY_STRING SCREEN_START_X, SCREEN_START_Y, "\2 RAM TEST"
	endif
	XY_STRING SCREEN_START_X, SCREEN_PASSES_Y, "PASSES"
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - PAUSE"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END

	endm
