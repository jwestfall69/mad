	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/memory_tests.inc"
	include "cpu/68000/include/tests/ram_test_logic.inc"

	; sprite ram only works with byte read/writes
	RAM_TEST_LOGIC sprite, SPRITE, (RTL_FLAG_BYTE_TESTS | RTL_FLAG_AUTO_OVERRIDE), MT_FLAG_NONE

	section code

auto_sprite_ram_tests:

		; disable sprite rendering/dma as it will
		; cause sprite ram tests to fail
		move.b	#$0, $108025


		lea	d_mt_data, a0
		DSUB	memory_byte_tests_handler

		; re-enable sprite rendering/dma
		move.b	#$10, $108025
		rts
