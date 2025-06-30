	include "cpu/konami2/include/common.inc"
	include "cpu/6x09/include/tests/ram_test_logic.inc"
	include "cpu/konami2/include/handlers/memory_tests.inc"

	RAM_TEST_LOGIC palette, PALETTE, (RTL_FLAG_PAUSE_REDRAW | RTL_FLAG_AUTO_OVERRIDE), MT_FLAG_INTERLEAVED

	section code

auto_palette_ram_tests:
		; bank to palette ram
		lda	#$1
		sta	REG_CONTROL

		ldx	#d_mt_data
		jsr	memory_tests_handler

		pshs	a
		lda	#$0
		sta	REG_CONTROL
		puls	a

		rts
