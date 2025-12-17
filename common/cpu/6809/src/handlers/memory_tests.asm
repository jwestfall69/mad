	include "cpu/6809/include/common.inc"
	include "cpu/6809/include/handlers/memory_tests.inc"

	global memory_tests_handler

	section code

; params:
;  x = MT_PARAMS struct address
memory_tests_handler:

		stx	r_mt_data_ptr
		tfr	x, y

		ldx	s_mt_start_address, y
		jsr	memory_output_test
		tsta
		lbne	.test_failed_output

		ldy	r_mt_data_ptr
		lda	#MT_FLAG_INTERLEAVED
		cmpa	s_mt_flags, y
		bne	.skip_odd_output_test

		ldx	s_mt_start_address, y
		leax	1, x
		jsr	memory_output_test
		tsta
		lbne	.test_failed_output

	.skip_odd_output_test:
		ldy	r_mt_data_ptr
		ldx	s_mt_start_address, y
		jsr	memory_write_test
		tsta
		lbne	.test_failed_write

		ldy	r_mt_data_ptr
		lda	#MT_FLAG_INTERLEAVED
		cmpa	s_mt_flags, y
		bne	.skip_odd_write_test

		ldx	s_mt_start_address, y
		leax	1, x
		jsr	memory_write_test
		tsta
		lbne	.test_failed_write

	.skip_odd_write_test:
		lda	#$00
		ldy	r_mt_data_ptr
		ldx	s_mt_start_address, y
		ldy	s_mt_size, y
		jsr	memory_data_test
		tsta
		lbne	.test_failed_data

		lda	#$55
		ldy	r_mt_data_ptr
		ldx	s_mt_start_address, y
		ldy	s_mt_size, y
		jsr	memory_data_test
		tsta
		lbne	.test_failed_data

		lda	#$aa
		ldy	r_mt_data_ptr
		ldx	s_mt_start_address, y
		ldy	s_mt_size, y
		jsr	memory_data_test
		tsta
		lbne	.test_failed_data

		lda	#$ff
		ldy	r_mt_data_ptr
		ldx	s_mt_start_address, y
		ldy	s_mt_size, y
		jsr	memory_data_test
		tsta
		lbne	.test_failed_data

		ldy	r_mt_data_ptr
		ldx	s_mt_start_address, y
		lda	s_mt_num_address_lines, y
		jsr	memory_address_test
		tsta
		bne	.test_failed_address

		ldy	r_mt_data_ptr
		lda	#MT_FLAG_INTERLEAVED
		cmpa	s_mt_flags, y
		bne	.skip_odd_address_test

		ldx	s_mt_start_address, y
		leax	1, x
		lda	s_mt_num_address_lines, y
		jsr	memory_address_test
		tsta
		bne	.test_failed_address

	.skip_odd_address_test:
		ldy	r_mt_data_ptr
		ldx	s_mt_start_address, y
		ldy	s_mt_size, y
		jsr	memory_march_test
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
		; y might have error data, so using u
		ldu	r_mt_data_ptr
		adda	s_mt_base_ec, u
		rts

	section bss

r_mt_data_ptr:		dcb.w 1
