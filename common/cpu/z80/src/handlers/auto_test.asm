	include "cpu/z80/include/dsub.inc"
	include "cpu/z80/include/macros.inc"
	include "cpu/z80/include/handlers/auto_test.inc"
	include "global/include/screen.inc"

	include "machine.inc"

	global auto_test_func_handler

	section code

; params:
;  ix = auto test list
auto_test_func_handler:
		; table is null terminated
		ld	c, (ix + s_at_function_ptr)
		ld	b, (ix + s_at_function_ptr + 1)

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
		ld	e, (ix + s_at_name_ptr)
		ld	d, (ix + s_at_name_ptr + 1)
		RSUB	print_string

		ld	l, (ix + s_at_function_ptr)
		ld	h, (ix + s_at_function_ptr + 1)

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

		ld	bc, s_at_struct_size
		add	ix, bc
		jr	auto_test_func_handler

	.test_failed:
		jp	error_handler

	.all_tests_done:
		ret
