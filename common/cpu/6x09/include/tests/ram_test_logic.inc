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

		ldx	#d_mt_data
		jsr	memory_tests_handler
		rts
	endif

manual_\1_ram_tests:
		ldy	#d_screen_xys_list
		jsr	print_xy_string_list
		jsr	print_passes
		jsr	print_b2_return_to_menu

		ldd	#$0

	.loop_next_pass:
		pshs	d
		WATCHDOG

		SEEK_XY	SCREEN_PASSES_VALUE_X, SCREEN_PASSES_Y
		RSUB	print_hex_word

		jsr	auto_\1_ram_tests
		tsta
		bne	.test_failed

		lda	REG_INPUT
		bita	#INPUT_B1
		beq	.test_paused

		bita	#INPUT_B2
		beq	.test_exit

		puls	d
		addd	#$1

		bra	.loop_next_pass

	.test_failed:
		jsr	error_handler
		STALL

	.test_paused:

	if \3 & RTL_FLAG_PAUSE_REDRAW
		RSUB	screen_init

		ldy	#d_screen_xys_list
		jsr	print_xy_string_list
		jsr	print_passes
		jsr	print_b2_return_to_menu

		SEEK_XY	SCREEN_PASSES_VALUE_X, SCREEN_PASSES_Y
		puls	d
		pshs	d
		RSUB	print_hex_word
	endif
		lda	#INPUT_B1
		jsr	wait_button_release
		puls	d
		jmp	.loop_next_pass

	.test_exit:
		puls	d
		rts

	section data

d_mt_data:
	MT_PARAMS \2_RAM, \2_RAM_SIZE, \2_RAM_ADDRESS_LINES, \2_RAM_BASE_EC, \4

d_screen_xys_list:
	if \3 & RTL_FLAG_PAUSE_REDRAW
		XY_STRING SCREEN_START_X, SCREEN_START_Y, "\2 RAM TEST"
	endif
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - PAUSE"
	XY_STRING_LIST_END

	endm
