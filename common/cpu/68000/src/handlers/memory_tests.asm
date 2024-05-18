	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/xy_string.inc"
	include "cpu/68000/include/handlers/memory_tests.inc"
	include "cpu/68000/include/tests/memory.inc"

	global memory_tests_handler_dsub

	section code

; offsets into MT_PARAMS struct
	rsreset
mt_start_address	rs.l 1
mt_address_list		rs.l 1
mt_size			rs.l 1
mt_num_address_lines	rs.w 1
mt_mask			rs.w 1
mt_lower_byte_only	rs.b 1
mt_base_ec		rs.b 1

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
memory_tests_handler_dsub:
		movea.l	a0, a6

		; output/write tests can either be a single
		; address or a list of addresses.  If
		; mt_address_list is non-zero we assume the
		; list versions of the functions are wanted.
		tst.l	mt_address_list(a6)
		bne	.memory_list

		move.l	mt_start_address(a6), a0
		move.b	mt_lower_byte_only(a6), d0
		DSUB	memory_output_test
		tst.b	d0
		bne	.test_failed_output

		move.l	mt_start_address(a6), a0
		move.b	mt_lower_byte_only(a6), d0
		DSUB	memory_write_test
		tst.b	d0
		bne	.test_failed_write
		bra	.data_test

	.memory_list:
		move.l	mt_address_list(a6), a0
		move.b	mt_lower_byte_only(a6), d0
		DSUB	memory_output_list_test
		tst.b	d0
		bne	.test_failed_output

		move.l	mt_address_list(a6), a0
		move.b	mt_lower_byte_only(a6), d0
		DSUB	memory_write_list_test
		tst.b	d0
		bne	.test_failed_write

	.data_test:
		move.l	mt_start_address(a6), a0
		move.l	mt_size(a6), d0
		move.w	mt_mask(a6), d1
		DSUB	memory_data_test
		tst.b	d0
		bne	.test_failed_data

		move.l	mt_start_address(a6), a0
		move.w	mt_num_address_lines(a6), d0
		move.w	mt_mask(a6), d1
		DSUB	memory_address_test
		tst.b	d0
		bne	.test_failed_address

		move.l	mt_start_address(a6), a0
		move.l	mt_size(a6), d0
		move.w	mt_mask(a6), d1
		DSUB	memory_march_test
		tst.b	d0
		bne	.test_failed_march
		DSUB_RETURN

	.test_failed_address:
		moveq	#MT_ERROR_ADDRESS_BASE, d0
		bra	.add_base_ec

	.test_failed_data:
		add.b	#MT_ERROR_DATA_BASE, d0
		bra	.adjust_which_byte

	.test_failed_march:
		add.b	#MT_ERROR_MARCH_BASE, d0
		bra	.adjust_which_byte

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
		add.b	mt_base_ec(a6), d0
		DSUB_RETURN
