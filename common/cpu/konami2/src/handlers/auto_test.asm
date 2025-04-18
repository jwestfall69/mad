	include "cpu/konami2/include/dsub.inc"
	include "cpu/konami2/include/macros.inc"
	include "cpu/konami2/include/handlers/auto_test.inc"
	include "global/include/screen.inc"

	include "machine.inc"

	global auto_test_func_handler

	section code

; params:
;  y = auto_test_list
auto_test_func_handler:
		; table is null terminated
		ldx	s_at_function_ptr, y
		beq	.all_tests_done

		SEEK_LN	SCREEN_START_Y
		RSUB	print_clear_line

		pshs	y
		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	s_at_name_ptr, y
		RSUB	print_string
		puls	y
		pshs	y

		jsr	[s_at_function_ptr, y]
		tsta
		bne	.test_failed

		; re-init the screen since the test may have
		; screwed it up
		RSUB	screen_init

		puls	y
		leay	s_at_struct_size, y
		bra	auto_test_func_handler

	.test_failed:
		jsr	error_handler	; never returns

	.all_tests_done:
		rts
