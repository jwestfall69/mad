RTL_FLAG_NONE		equ $00
RTL_FLAG_PAUSE_REDRAW	equ $01	; force a full screen redraw on pause
RTL_FLAG_AUTO_OVERRIDE	equ $02	; don't generate auto_x_ram_tests function
RTL_FLAG_BYTE_TESTS	equ $04
RTL_FLAG_ADDRESS_LIST	equ $08
RTL_FLAG_MAME_DISABLE	equ $10

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

	if \3 & RTL_FLAG_MAME_DISABLE
		moveq	#0, d0
		rts
	endif

		lea	d_mt_data, a0

	if \3 & RTL_FLAG_BYTE_TESTS
		DSUB	memory_byte_tests_handler
	else
		DSUB	memory_tests_handler
	endif
		rts
	endif

manual_\1_ram_tests:

		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list
		jsr	print_passes
		jsr	print_b2_return_to_menu

		moveq	#0, d6		; passes, memory tests don't touch it

	.loop_next_pass:

		jsr	auto_\1_ram_tests
		tst.b	d0
		bne	.test_failed

		addq.l	#1, d6

		SEEK_XY	SCREEN_PASSES_VALUE_X, SCREEN_PASSES_Y
		move.l	d6, d0
		RSUB	print_hex_long

		btst	#INPUT_B2_BIT, REG_INPUT
		beq	.test_exit

		btst	#INPUT_B1_BIT, REG_INPUT
		beq	.test_pause
		bra	.loop_next_pass

	.test_failed:
		RSUB	error_handler
		STALL

	.test_pause:

	if \3 & RTL_FLAG_PAUSE_REDRAW
		RSUB	screen_init

		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list
		jsr	print_passes
		jsr	print_b2_return_to_menu

		SEEK_XY	SCREEN_PASSES_VALUE_X, SCREEN_PASSES_Y
		move.l	d6, d0
		RSUB	print_hex_long
	endif

		moveq	#INPUT_B1_BIT, d0
		RSUB	wait_button_release

		bra	.loop_next_pass

	.test_exit:
		rts

	section data
	align 1

d_mt_data:
	if \3 & RTL_FLAG_ADDRESS_LIST
		MT_PARAMS \2_RAM, d_memory_address_list, \2_RAM_SIZE, \2_RAM_ADDRESS_LINES, \2_RAM_MASK, \2_RAM_BASE_EC, \4
	else
		MT_PARAMS \2_RAM, MT_NULL_ADDRESS_LIST, \2_RAM_SIZE, \2_RAM_ADDRESS_LINES, \2_RAM_MASK, \2_RAM_BASE_EC, \4
	endif

d_screen_xys_list:
	if \3 & RTL_FLAG_PAUSE_REDRAW
		XY_STRING SCREEN_START_X, SCREEN_START_Y, "\2 RAM TEST"
	endif
	if \3 & RTL_FLAG_MAME_DISABLE
		XY_STRING SCREEN_START_X, (SCREEN_PASSES_Y + 2), "MAME BUILD - TEST DISABLED"
	endif
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - PAUSE"
	XY_STRING_LIST_END

	endm
