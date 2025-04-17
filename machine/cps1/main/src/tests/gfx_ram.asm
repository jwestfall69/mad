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
	include "mad.inc"

	RAM_TEST_LOGIC gfx, GFX, (RTL_FLAG_PAUSE_REDRAW | RTL_FLAG_ADDRESS_LIST), MT_FLAG_NONE

	section data
	align 1

; fix me based on ram chips
d_memory_address_list:
	MEMORY_ADDRESS_ENTRY GFX_RAM_START
	MEMORY_ADDRESS_LIST_END
