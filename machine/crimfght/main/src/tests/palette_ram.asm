	include "global/include/screen.inc"
	include "cpu/konami2/include/dsub.inc"
	include "cpu/konami2/include/macros.inc"
	include "cpu/konami2/include/xy_string.inc"
	include "cpu/konami2/include/handlers/memory_tests.inc"
	include "cpu/konami2/include/tests/ram_test_logic.inc"

	include "error_codes.inc"
	include "input.inc"
	include "machine.inc"

	RAM_TEST_LOGIC palette, PALETTE, (RTL_FLAG_PAUSE_REDRAW | RTL_FLAG_AUTO_OVERRIDE), MT_FLAG_NONE

	section code

auto_palette_ram_tests:
		; bank to palette ram
		setln	#$a0

		ldx	#d_mt_data
		jsr	memory_tests_handler

		setln	#$80
		rts
