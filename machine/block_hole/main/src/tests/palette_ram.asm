	include "global/include/screen.inc"

	include "cpu/6x09/include/macros.inc"
	include "cpu/6x09/include/xy_string.inc"
	include "cpu/6x09/include/tests/ram_test_logic.inc"

	include "cpu/konami2/include/dsub.inc"
	include "cpu/konami2/include/handlers/memory_tests.inc"

	include "error_codes.inc"
	include "input.inc"
	include "machine.inc"

	RAM_TEST_LOGIC palette, PALETTE, (RTL_FLAG_PAUSE_REDRAW | RTL_FLAG_AUTO_OVERRIDE), MT_FLAG_INTERLEAVED

	section code

auto_palette_ram_tests:
		; bank to palette ram
		setln	#(SETLN_WATCHDOG_POLL|SETLN_SELECT_RAM_PALETTE)

		ldx	#d_mt_data
		jsr	memory_tests_handler

		setln	#(SETLN_WATCHDOG_POLL|SETLN_SELECT_RAM_WORK)
		rts
