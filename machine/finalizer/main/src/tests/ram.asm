	include "cpu/6809/include/common.inc"

	global ram_test

	section code

ram_test:
		SEEK_XY	0, SCREEN_START_Y
		RSUB	print_clear_line

		ldy	#d_screen_xys_list
		jsr	print_xy_string_list
		jsr	print_b2_return_to_menu

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
		bra	.loop_next_pass


	.test_paused:

		DSUB_MODE_RSUB

		RSUB	screen_init

		ldy	#d_screen_xys_list
		jsr	print_xy_string_list
		jsr	print_b2_return_to_menu

		lda	#INPUT_B1
		jsr	wait_button_release

		DSUB_MODE_PSUB
		bra	.loop_next_pass

	.test_exit:
		clr	r_menu_cursor

		DSUB_MODE_RSUB

		jmp	main_menu


	section data

d_screen_xys_list:
	XY_STRING SCREEN_START_X, SCREEN_START_Y, "TESTING RAM"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "PAUSED"
	XY_STRING SCREEN_START_X, SCREEN_PASSES_Y, "PASS COUNT NOT"
	XY_STRING SCREEN_START_X, (SCREEN_PASSES_Y + 1), "POSSIBLE"
	XY_STRING_LIST_END

