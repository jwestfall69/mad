	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"
	include "cpu/68000/tests/memory.inc"
	include "cpu/68000/xy_string.inc"

	include "diag_rom.inc"
	include "error_codes.inc"
	include "machine.inc"

	global auto_work_ram_tests_dsub
	global manual_work_ram_tests

	section code

auto_work_ram_tests_dsub:
		lea	MEMORY_ADDRESS_LIST, a0
		moveq	#0, d0
		DSUB	memory_output_list_test
		tst.b	d0
		bne	.test_failed_output

		lea	MEMORY_ADDRESS_LIST, a0
		moveq	#0, d0
		DSUB	memory_write_list_test
		tst.b	d0
		bne	.test_failed_write

		lea	WORK_RAM_START, a0
		move.w	#WORK_RAM_SIZE, d0
		move.w	#$ffff, d1
		DSUB	memory_data_test
		tst.b	d0
		bne	.test_failed_data

		lea	WORK_RAM_START, a0
		move.w	#WORK_RAM_ADDRESS_LINES, d0
		move.w	#$ffff, d1
		DSUB	memory_address_test
		tst.b	d0
		bne	.test_failed_address

		lea	WORK_RAM_START, a0
		move.l	#WORK_RAM_SIZE, d0
		move.w	#$ffff, d1
		DSUB	memory_march_test
		tst.b	d0
		bne	.test_failed_march
		DSUB_RETURN

	.test_failed_address:
		moveq	#EC_WORK_RAM_ADDRESS, d0
		DSUB_RETURN

	.test_failed_data:
		subq.b	#1, d0
		add.b	#EC_WORK_RAM_DATA_LOWER, d0
		DSUB_RETURN

	.test_failed_march:
		subq.b	#1, d0
		add.b	#EC_WORK_RAM_MARCH_LOWER, d0
		DSUB_RETURN

	.test_failed_output:
		subq.b	#1, d0
		add.b	#EC_WORK_RAM_OUTPUT_LOWER, d0
		DSUB_RETURN

	.test_failed_write:
		subq.b	#1, d0
		add.b	#EC_WORK_RAM_WRITE_LOWER, d0
		DSUB_RETURN



manual_work_ram_tests:

		lea	SCREEN_XYS_LIST, a0
		RSUB	print_xy_string_list

		moveq	#0, d6		; passes, memory tests don't touch it
		PSUB_INIT

	.loop_next_pass:

		SEEK_XY	12, 10
		move.l	d6, d0
		PSUB	print_hex_long


		PSUB	auto_work_ram_tests
		tst.b	d0
		bne	.test_failed

		btst	#P1_B2_BIT, REG_INPUT_P1
		beq	.test_exit

		addq.l	#1, d6

		bra	.loop_next_pass

	.test_failed:
		RSUB_INIT
		RSUB	error_handler
		STALL

	.test_exit:
		RSUB_INIT
		clr.b	MAIN_MENU_CURSOR
		bra	main_menu

	section data

SCREEN_XYS_LIST:
	XY_STRING  3, 10, "PASSES"
	XY_STRING  3, 20, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END

; fix me based on ram chips
	align 2
MEMORY_ADDRESS_LIST:
        MEMORY_ADDRESS_ENTRY WORK_RAM_START
        MEMORY_ADDRESS_LIST_END
