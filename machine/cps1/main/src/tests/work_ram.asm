	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/xy_string.inc"
	include "cpu/68000/include/handlers/memory_tests.inc"
	include "cpu/68000/include/tests/memory.inc"

	include "error_codes.inc"
	include "input.inc"
	include "machine.inc"
	include "mad_rom.inc"

	global auto_work_ram_tests_dsub
	global manual_work_ram_tests

	section code

auto_work_ram_tests_dsub:
		lea	MT_DATA, a0
		bra	memory_tests_handler_dsub

manual_work_ram_tests:
		lea	SCREEN_XYS_LIST, a0
		RSUB	print_xy_string_list

		INTS_DISABLE
		PSUB_INIT

		moveq	#0, d6		; passes, memory tests don't touch it

	.loop_next_pass:

		SEEK_XY	12, 10
		move.l	d6, d0
		PSUB	print_hex_long


		PSUB	auto_work_ram_tests
		tst.b	d0
		bne	.test_failed

		btst	#INPUT_B2_BIT, REG_INPUT
		beq	.test_exit

		addq.l	#1, d6

		bra	.loop_next_pass

	.test_failed:
		PSUB	error_handler
		STALL

	.test_exit:
		RSUB_INIT
		INTS_ENABLE
		bra	main_menu

	section data

	align 2

; fix me based on ram chips
MEMORY_ADDRESS_LIST:
	MEMORY_ADDRESS_ENTRY WORK_RAM_START
	MEMORY_ADDRESS_LIST_END

MT_DATA:
	MT_PARAMS WORK_RAM_START, MEMORY_ADDRESS_LIST, WORK_RAM_SIZE, WORK_RAM_ADDRESS_LINES, WORK_RAM_MASK, $0, WORK_RAM_BASE_EC

SCREEN_XYS_LIST:
	XY_STRING 3, 10, "PASSES"
	XY_STRING 3, 20, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END

