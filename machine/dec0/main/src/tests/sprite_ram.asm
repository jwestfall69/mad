	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/memory_tests.inc"
	include "cpu/68000/include/tests/memory.inc"
	include "cpu/68000/include/tests/ram_test_logic.inc"

	RAM_TEST_LOGIC sprite, SPRITE, RTL_FLAG_ADDRESS_LIST, MT_FLAG_NONE

	section data
	align 1

; fix me based on ram chips
d_memory_address_list:
	MEMORY_ADDRESS_ENTRY SPRITE_RAM
	MEMORY_ADDRESS_LIST_END
