	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/memory_tests.inc"
	include "cpu/68000/include/tests/ram_test_logic.inc"

	; sprite ram only works with byte read/writes
	RAM_TEST_LOGIC sprite, SPRITE, RTL_FLAG_BYTE_TESTS, MT_FLAG_NONE
