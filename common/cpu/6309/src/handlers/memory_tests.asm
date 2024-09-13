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

		stx	r_mt_data_addr
		tfr	x, y

		ldx	mt_start_address, y
		PSUB	memory_output_test
		tsta
		lbne	.test_failed_output

		ldx	mt_start_address, y
		PSUB	memory_write_test
		tsta
		lbne	.test_failed_write

		ldx	mt_start_address, y
		ldd	mt_size, y
		lde	#$00
		PSUB	memory_data_test
		tsta
		lbne	.test_failed_data

		ldy	r_mt_data_addr
		ldx	mt_start_address, y
		ldd	mt_size, y
		lde	#$55
		PSUB	memory_data_test
		tsta
		lbne	.test_failed_data

		ldy	r_mt_data_addr
		ldx	mt_start_address, y
		ldd	mt_size, y
		lde	#$aa
		PSUB	memory_data_test
		tsta
		lbne	.test_failed_data

		ldy	r_mt_data_addr
		ldx	mt_start_address, y
		ldd	mt_size, y
		lde	#$ff
		PSUB	memory_data_test
		tsta
		lbne	.test_failed_data

		ldy	r_mt_data_addr
		ldx	mt_start_address, y
		lda	mt_num_address_lines, y
		PSUB	memory_address_test
		tsta
		bne	.test_failed_address

		ldy	r_mt_data_addr
		ldx	mt_start_address, y
		ldd	mt_size, y
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
		ldy	r_mt_data_addr
		adda	mt_base_ec, y
		rts

	section bss

r_mt_data_addr:	dc.w $0
