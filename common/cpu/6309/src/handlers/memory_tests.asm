	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/xy_string.inc"
	include "cpu/6309/include/handlers/memory_tests.inc"

	include "machine.inc"

	global memory_tests_handler

	section code

; params:
;  x = MT_PARAMS struct address
memory_tests_handler:

		stx	MT_DATA
		tfr	x, y

		ldx	MT_PARAMS.start_address, y
		PSUB	memory_output_test
		tsta
		lbne	.test_failed_output

		ldx	MT_PARAMS.start_address, y
		PSUB	memory_write_test
		tsta
		lbne	.test_failed_write

		ldx	MT_PARAMS.start_address, y
		ldd	MT_PARAMS.size, y
		lde	#$00
		PSUB	memory_data_test
		tsta
		lbne	.test_failed_data

		ldy	MT_DATA
		ldx	MT_PARAMS.start_address, y
		ldd	MT_PARAMS.size, y
		lde	#$55
		PSUB	memory_data_test
		tsta
		lbne	.test_failed_data

		ldy	MT_DATA
		ldx	MT_PARAMS.start_address, y
		ldd	MT_PARAMS.size, y
		lde	#$aa
		PSUB	memory_data_test
		tsta
		lbne	.test_failed_data

		ldy	MT_DATA
		ldx	MT_PARAMS.start_address, y
		ldd	MT_PARAMS.size, y
		lde	#$ff
		PSUB	memory_data_test
		tsta
		lbne	.test_failed_data

		ldy	MT_DATA
		ldx	MT_PARAMS.start_address, y
		lda	MT_PARAMS.num_address_lines, y
		PSUB	memory_address_test
		tsta
		bne	.test_failed_address

		ldy	MT_DATA
		ldx	MT_PARAMS.start_address, y
		ldd	MT_PARAMS.size, y
		PSUB	memory_march_test
 		tsta
		bne	.test_failed_march

		rts

	.test_failed_address:
		lda	#MT_ERROR_ADDRESS_BASE
		bra	.add_base_ec

	.test_failed_data:
		lda	#MT_ERROR_DATA_BASE
		bra	.add_base_ec

	.test_failed_march:
		lda	#MT_ERROR_MARCH_BASE
		bra	.add_base_ec

	.test_failed_output:
		lda	#MT_ERROR_OUTPUT_BASE
		bra	.add_base_ec

	.test_failed_write:
		lda	#MT_ERROR_WRITE_BASE

	.add_base_ec:
		ldy	MT_DATA
		adda	MT_PARAMS.base_ec, y
		rts

	section bss

MT_DATA:	blkw	1
