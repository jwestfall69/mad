	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/xy_string.inc"
	include "cpu/68000/include/handlers/memory_tests.inc"
	include "cpu/68000/include/tests/memory.inc"
	include "cpu/68000/include/tests/ram_test_logic.inc"
	include "global/include/screen.inc"

	include "error_codes.inc"
	include "input.inc"
	include "machine.inc"
	include "mad_rom.inc"

	ifd _MAME_BUILD_
		RAM_TEST_LOGIC tile3, TILE1, (RTL_FLAG_PAUSE_REDRAW | RTL_FLAG_MAME_DISABLE)
	else
		RAM_TEST_LOGIC tile3, TILE1, RTL_FLAG_PAUSE_REDRAW
	endif
