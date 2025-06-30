	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/memory_tests.inc"
	include "cpu/68000/include/tests/ram_test_logic.inc"

	ifd _MAME_BUILD_
		RAM_TEST_LOGIC bg, BG, RTL_FLAG_MAME_DISABLE, MT_FLAG_NONE
	else
		RAM_TEST_LOGIC bg, BG, RTL_FLAG_NONE, MT_FLAG_NONE
	endif
