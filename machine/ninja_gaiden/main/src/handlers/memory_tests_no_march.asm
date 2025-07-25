	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/memory_tests.inc"

	global memory_tests_no_march_handler_dsub

	section code

; params:
;  a0 = ptr to mt_params struct
; returns:
;  d0 = 0 if success, else error code
;  d1 = data from failed test
;  d2 = data from failed test
;  a0 = data from failed test
;  a1 = data from failed test
; The d0 error code will be based on the passed base_ec
;  address error = base_ec + $0
;  data error    = base_ec + $1 + which byte (0 = lower, 1 = upper, 2 = both)
;  march error   = base_ec + $4 + which byte
;  output error  = base_ec + $7 + which byte
;  write error   = base_ec + $a + which byte
memory_tests_no_march_handler_dsub:
		movea.l	a0, a6

		; output/write tests can either be a single
		; address or a list of addresses.  If
		; s_mt_address_list is non-zero we assume the
		; list versions of the functions are wanted.
		tst.l	s_mt_address_list(a6)
		bne	.memory_list

		move.l	s_mt_start_address(a6), a0
		moveq	#MT_FLAG_LOWER_ONLY, d0
		and.b	s_mt_flags(a6), d0
		DSUB	memory_output_test
		tst.b	d0
		bne	.test_failed_output

		move.l	s_mt_start_address(a6), a0
		moveq	#MT_FLAG_LOWER_ONLY, d0
		and.b	s_mt_flags(a6), d0
		DSUB	memory_write_test
		tst.b	d0
		bne	.test_failed_write
		bra	.data_test

	.memory_list:
		move.l	s_mt_address_list(a6), a0
		moveq	#MT_FLAG_LOWER_ONLY, d0
		and.b	s_mt_flags(a6), d0
		DSUB	memory_output_list_test
		tst.b	d0
		bne	.test_failed_output

		move.l	s_mt_address_list(a6), a0
		moveq	#MT_FLAG_LOWER_ONLY, d0
		and.b	s_mt_flags(a6), d0
		DSUB	memory_write_list_test
		tst.b	d0
		bne	.test_failed_write

	.data_test:
		move.l	s_mt_start_address(a6), a0
		move.l	s_mt_size(a6), d0
		move.w	s_mt_mask(a6), d1
		DSUB	memory_data_test
		tst.b	d0
		bne	.test_failed_data

		move.l	s_mt_start_address(a6), a0
		move.w	s_mt_num_address_lines(a6), d0
		move.w	s_mt_mask(a6), d1
		DSUB	memory_address_test
		tst.b	d0
		bne	.test_failed_address

		;move.l	s_mt_start_address(a6), a0
		;move.l	s_mt_size(a6), d0
		;move.w	s_mt_mask(a6), d1
		;DSUB	memory_march_test
		;tst.b	d0
		;bne	.test_failed_march
		DSUB_RETURN

	.test_failed_address:
		moveq	#MT_ERROR_ADDRESS_BASE, d0
		bra	.add_base_ec

	.test_failed_data:
		add.b	#MT_ERROR_DATA_BASE, d0
		bra	.adjust_which_byte

;	.test_failed_march:
;		add.b	#MT_ERROR_MARCH_BASE, d0
;		bra	.adjust_which_byte

	.test_failed_output:
		add.b	#MT_ERROR_OUTPUT_BASE, d0
		bra	.adjust_which_byte

	.test_failed_write:
		add.b	#MT_ERROR_WRITE_BASE, d0

	; for tests that return data about what byte was bad
	; (1 = lower, 2 = upper, 3 = both) need to have that
	; data adjusted so it will map to the right ec value
	; for the given error type.
	.adjust_which_byte:
		subq.b	#1, d0

	; given our internal mt error add on the memory's base
	; ec value so its the correct ec value for that memory
	.add_base_ec:
		add.b	s_mt_base_ec(a6), d0
		DSUB_RETURN
