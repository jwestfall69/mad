	include "cpu/z80/include/dsub.inc"
	include "cpu/z80/include/macros.inc"
	include "cpu/z80/include/tests/auto.inc"
	include "global/include/screen.inc"

	include "machine.inc"

	global auto_func_tests

	section code

auto_func_tests:

		ld	ix, d_auto_func_list

	.loop_next_test:
		; table is null terminated
		ld	c, (ix + s_ae_function_ptr)
		ld	b, (ix + s_ae_function_ptr + 1)

		; function ptr of $0000 is list end
		ld	a, 0
		cp	b
		jr	nz, .next_test

		cp	c
		jr	z, .all_tests_done

	.next_test:

		SEEK_LN	SCREEN_START_Y
		RSUB	print_clear_line

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ld	e, (ix + s_ae_name_ptr)
		ld	d, (ix + s_ae_name_ptr + 1)
		RSUB	print_string

		ld	l, (ix + s_ae_function_ptr)
		ld	h, (ix + s_ae_function_ptr + 1)

		push 	ix

		ld	de, .function_return
		push	de
		jp	(hl)
	.function_return:
		pop	ix
		cp	0
		jr	nz, .test_failed

		; re-init the screen since the test may have
		; screwed it up
		RSUB	screen_init

		ld	bc, s_ae_struct_size
		add	ix, bc
		jr	.loop_next_test

	.test_failed:
		jp	error_handler

	.all_tests_done:
		ret
