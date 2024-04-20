	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"
	include "cpu/68000/tests/memory.inc"

	include "error_codes.inc"
	include "machine.inc"

	global auto_fg_ram_tests

	section code

auto_fg_ram_tests:

		moveq	#0, d0
		rts

		lea	MEMORY_ADDRESS_LIST, a0
		RSUB	memory_output_list_test
		tst.b	d0
		bne	.test_failed_output

		lea	MEMORY_ADDRESS_LIST, a0
		RSUB	memory_write_list_test
		tst.b	d0
		bne	.test_failed_write

		lea	FG_RAM_START, a0
		move.w	#FG_RAM_SIZE, d0
		RSUB	memory_data_test
		tst.b	d0
		bne	.test_failed_data

		lea	FG_RAM_START, a0
		move.w	#FG_RAM_ADDRESS_LINES, d0
		RSUB	memory_address_test
		tst.b	d0
		bne	.test_failed_address
		rts

	.test_failed_address:
		moveq	#EC_FG_RAM_ADDRESS, d0
		rts

	.test_failed_data:
		subq.b	#1, d0
		add.b	#EC_FG_RAM_DATA_LOWER, d0
		rts

	.test_failed_output:
		subq.b	#1, d0
		add.b	#EC_FG_RAM_OUTPUT_LOWER, d0
		rts

	.test_failed_write:
		subq.b	#1, d0
		add.b	#EC_FG_RAM_WRITE_LOWER, d0
		rts

	section data

; fix me based on ram chips
MEMORY_ADDRESS_LIST:
        MEMORY_ADDRESS_ENTRY FG_RAM_START
        MEMORY_ADDRESS_LIST_END
