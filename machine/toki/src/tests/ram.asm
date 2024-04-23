	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"
	include "cpu/68000/tests/memory.inc"
	include "cpu/68000/xy_string.inc"

	include "diag_rom.inc"
	include "error_codes.inc"
	include "machine.inc"

	global auto_ram_tests_dsub
	global manual_ram_tests

	section code

auto_ram_tests_dsub:
		lea	MEMORY_ADDRESS_LIST, a0
		DSUB	memory_output_list_test
		tst.b	d0
		bne	.test_failed_output

		lea	MEMORY_ADDRESS_LIST, a0
		DSUB	memory_write_list_test
		tst.b	d0
		bne	.test_failed_write

		lea	RAM_START, a0
		move.l	#RAM_SIZE, d0
		DSUB	memory_data_test
		tst.b	d0
		bne	.test_failed_data

		lea	RAM_START, a0
		move.w	#RAM_ADDRESS_LINES, d0
		DSUB	memory_address_test
		tst.b	d0
		bne	.test_failed_address

		lea	RAM_START, a0
		move.l	#RAM_SIZE, d0
		DSUB	memory_march_test
		tst.b	d0
		bne	.test_failed_march
		DSUB_RETURN

	.test_failed_address:
		moveq	#EC_RAM_ADDRESS, d0
		DSUB_RETURN

	.test_failed_data:
		subq.b	#1, d0
		add.b	#EC_RAM_DATA_LOWER, d0
		DSUB_RETURN

	.test_failed_march:
		subq.b	#1, d0
		add.b	#EC_RAM_MARCH_LOWER, d0
		DSUB_RETURN

	.test_failed_output:
		subq.b	#1, d0
		add.b	#EC_RAM_OUTPUT_LOWER, d0
		DSUB_RETURN

	.test_failed_write:
		subq.b	#1, d0
		add.b	#EC_RAM_WRITE_LOWER, d0
		DSUB_RETURN


manual_ram_tests:

		lea	SCREEN_XYS_LIST, a0
		RSUB	print_xy_string_list

		moveq	#0, d6		; passes, memory tests don't touch it

		DISABLE_INTS
		PSUB_INIT

	.loop_next_pass:

		SEEK_XY	12, 10
		move.l	d6, d0
		PSUB	print_hex_long


		PSUB	auto_ram_tests
		tst.b	d0
		bne	.test_failed

		addq.l	#1, d6

		btst	#P1_B2_BIT, REG_INPUT_P1
		beq	.test_exit

		btst	#P1_B1_BIT, REG_INPUT_P1
		beq	.test_pause

		bra	.loop_next_pass

	.test_failed:
		RSUB_INIT
		RSUB	error_handler
		STALL

	.test_pause:
		PSUB	screen_init

		lea	SCREEN_XYS_LIST, a0
		PSUB	print_xy_string_list

		SEEK_XY	12, 10
		move.l	d6, d0
		PSUB	print_hex_long

	.loop_paused:
		btst	#P1_B1_BIT, REG_INPUT_P1
		beq	.loop_paused
		bra	.loop_next_pass

	.test_exit:
		RSUB_INIT
		ENABLE_INTS
		clr.b	MAIN_MENU_CURSOR
		bra	main_menu



	section data

SCREEN_XYS_LIST:
	XY_STRING 3,  4, "RAM TEST"
	XY_STRING 3, 10, "PASSES"
	XY_STRING 3, 19, "B1 - PAUSE"
	XY_STRING 3, 20, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END

STR_RAM_TEST:		STRING "RAM TEST"

; fix me based on ram chips
MEMORY_ADDRESS_LIST:
        MEMORY_ADDRESS_ENTRY RAM_START
        MEMORY_ADDRESS_LIST_END
