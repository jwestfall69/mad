	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/tests/auto.inc"
	include "global/include/screen.inc"

	include "machine.inc"

	global auto_func_tests

	section code

auto_func_tests:

		ldy	#d_auto_func_list

	.loop_next_test:
		; table is null terminated
		ldd	s_ae_function_ptr, y
		tstd
		beq	.all_tests_done

		SEEK_LN	SCREEN_START_Y
		PSUB	print_clear_line

		pshs	y
		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	s_ae_name_ptr, y
		PSUB	print_string
		puls	y
		pshs	y

		jsr	[s_ae_function_ptr, y]
		tsta
		bne	.test_failed

		; re-init the screen since the test may have
		; screwed it up
		PSUB	screen_init

		puls	y
		leay	s_ae_struct_size, y
		bra	.loop_next_test

	.test_failed:
		jsr	error_handler	; never returns

	.all_tests_done:
		rts
