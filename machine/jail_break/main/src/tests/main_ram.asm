	include "cpu/6809/include/common.inc"

	global manual_main_ram_tests

	section code

manual_main_ram_tests:
		SEEK_XY	0, SCREEN_START_Y
		RSUB	print_clear_line

		ldy	#d_screen_xys_list
		jsr	print_xy_string_list
		jsr	print_b2_return_to_menu

		ldd	#$0
		std	R_WORK_RAM_PASSES

		DSUB_MODE_PSUB

	.loop_next_pass:
		PSUB	work_ram_output_test
		PSUB	work_ram_write_test
		PSUB	work_ram_data_test
		PSUB	work_ram_address_test
		PSUB	work_ram_march_test

		lda	REG_INPUT
		coma

		bita	#INPUT_B1
		bne	.test_paused

		bita	#INPUT_B2
		bne	.test_exit

		ldd	R_WORK_RAM_PASSES
		addd	#$1
		std	R_WORK_RAM_PASSES
		bra	.loop_next_pass


	.test_paused:

		DSUB_MODE_RSUB

		RSUB	screen_init_no_scroll_clear

		SEEK_XY SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_testing_work_ram
		RSUB	print_string

		SEEK_XY SCREEN_START_X, SCREEN_B1_Y
		ldy	#d_str_b1_pause
		RSUB	print_string

		jsr	print_passes
		jsr	print_b2_return_to_menu

		SEEK_XY	SCREEN_PASSES_VALUE_X, SCREEN_PASSES_Y
		ldd	R_WORK_RAM_PASSES
		RSUB	print_hex_word

		lda	#INPUT_B1
		jsr	wait_button_release

		DSUB_MODE_PSUB
		lbra	.loop_next_pass

	.test_exit:
		clr	r_menu_cursor

		DSUB_MODE_RSUB

		jmp	main_menu


	section data

d_str_b1_pause:
	STRING "B1 - PAUSE"

d_screen_xys_list:
	XY_STRING SCREEN_START_X, SCREEN_START_Y, "TESTING RAM"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "PAUSED"
	XY_STRING_LIST_END

