	include "global/include/screen.inc"

	include "cpu/6x09/include/macros.inc"
	include "cpu/6x09/include/xy_string.inc"
	include "cpu/6x09/include/tests/ram_test_logic.inc"

	include "cpu/konami2/include/dsub.inc"
	include "cpu/konami2/include/handlers/memory_tests.inc"

	include "error_codes.inc"
	include "input.inc"
	include "machine.inc"

	RAM_TEST_LOGIC tile_attr, TILE_ATTR, RTL_FLAG_PAUSE_REDRAW, MT_FLAG_NONE
