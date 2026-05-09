	include "cpu/6309/include/common.inc"
	include "cpu/6x09/include/tests/ram_test_logic.inc"
	include "cpu/6309/include/handlers/memory_tests.inc"

	RAM_TEST_LOGIC k007121_g8, K007121_G8, (RTL_FLAG_PAUSE_REDRAW | RTL_FLAG_AUTO_OVERRIDE), MT_FLAG_NONE

	section code

auto_k007121_g8_ram_tests:
		; bank in
		lda	#REG_CTRL_K007121_G8
		sta	REG_CONTROL

		ldx	#d_mt_data
		jsr	memory_tests_handler

		pshs	a
		lda	#REG_CTRL_K007121_G15
		sta	REG_CONTROL
		puls	a
		rts

