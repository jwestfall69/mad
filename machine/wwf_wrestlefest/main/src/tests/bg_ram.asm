	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/xy_string.inc"
	include "cpu/68000/include/handlers/memory_tests.inc"
	include "cpu/68000/include/tests/ram_test_logic.inc"
	include "global/include/screen.inc"

	include "error_codes.inc"
	include "input.inc"
	include "machine.inc"

	ifd _MAME_BUILD_
		RAM_TEST_LOGIC bg, BG, RTL_FLAG_MAME_DISABLE, MT_FLAG_NONE
	else
		RAM_TEST_LOGIC bg, BG, RTL_FLAG_NONE, MT_FLAG_NONE
	endif
