	include "cpu/konami2/include/common.inc"
	include "cpu/6x09/include/tests/ram_test_logic.inc"
	include "cpu/konami2/include/handlers/memory_tests.inc"

	RAM_TEST_LOGIC sprite, SPRITE, (RTL_FLAG_PAUSE_REDRAW | RTL_FLAG_AUTO_OVERRIDE), MT_FLAG_NONE

auto_sprite_ram_tests:
		lda	#CTRL_SPRITE_BANK
		sta	REG_CONTROL

		; This is disables the k053246 from messing with the sprite ram
		lda	#$24
		sta	$1fa5

		ldx	#d_mt_data
		jsr	memory_tests_handler

		clr	REG_CONTROL

		pshs	a
		lda	#$34
		sta	$1fa5
		puls	a
		rts
