	include "cpu/z80/include/dsub.inc"
	include "cpu/z80/include/macros.inc"
	include "cpu/z80/include/handlers/memory_tests.inc"

	include "machine.inc"

	global memory_tests_handler

	section code

; params:
;  ix = MT_PARAMS struct address
; returns:
;  a = 0 (pass), !0 (fail)
;  Z = 1 (pass), 0 (fail)
; returned error values from memory test is untouched
;  hl = error address
;  b = expected
;  c = actual
memory_tests_handler:

		; save these off to make life easier
		ld	l, (ix + s_mt_start_address)
		ld	h, (ix + s_mt_start_address + 1)
		ld	(r_start_address), hl

		ld	l, (ix + s_mt_size)
		ld	h, (ix + s_mt_size + 1)
		ld	(r_size), hl

		ld	hl, (r_start_address)
		RSUB	memory_output_test
		cp	0
		jr	nz, .test_failed_output

		ld	hl, (r_start_address)
		RSUB	memory_write_test
		cp	0
		jr	nz, .test_failed_write

		ld	hl, (r_start_address)
		ld	de, (r_size)
		ld	b, $00
		RSUB	memory_data_pattern_test
		cp	0
		jr	nz, .test_failed_data

		ld	hl, (r_start_address)
		ld	de, (r_size)
		ld	b, $55
		RSUB	memory_data_pattern_test
		cp	0
		jr	nz, .test_failed_data

		ld	hl, (r_start_address)
		ld	de, (r_size)
		ld	b, $aa
		RSUB	memory_data_pattern_test
		cp	0
		jr	nz, .test_failed_data

		ld	hl, (r_start_address)
		ld	de, (r_size)
		ld	b, $ff
		RSUB	memory_data_pattern_test
		cp	0
		jr	nz, .test_failed_data

		ld	hl, (r_start_address)
		ld	b, (ix + s_mt_num_address_lines)
		RSUB	memory_address_test
		cp	0
		jr	nz, .test_failed_address

		ld	hl, (r_start_address)
		ld	de, (r_size)
		RSUB	memory_march_test
 		cp	0
		jr	nz, .test_failed_march
		ret

	.test_failed_address:
		ld	a, MT_ERROR_ADDRESS_BASE
		jr	.add_base_ec

	.test_failed_data:
		ld	a, MT_ERROR_DATA_BASE
		jr	.add_base_ec

	.test_failed_march:
		ld	a, MT_ERROR_MARCH_BASE
		jr	.add_base_ec

	.test_failed_output:
		ld	a, MT_ERROR_OUTPUT_BASE
		jr	.add_base_ec

	.test_failed_write:
		ld	a, MT_ERROR_WRITE_BASE

	.add_base_ec:
		add	a, (ix + s_mt_base_ec)
		ret

	section bss

r_size:			dc.w $0
r_start_address:	dc.w $0
