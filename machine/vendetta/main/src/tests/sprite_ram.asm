	include "global/include/screen.inc"
	include "cpu/konami/include/dsub.inc"
	include "cpu/konami/include/macros.inc"
	include "cpu/konami/include/xy_string.inc"
	include "cpu/konami/include/handlers/memory_tests.inc"
	include "cpu/konami/include/tests/ram_test_logic.inc"

	include "error_codes.inc"
	include "input.inc"
	include "machine.inc"

	RAM_TEST_LOGIC sprite, SPRITE, (RTL_FLAG_PAUSE_REDRAW | RTL_FLAG_AUTO_OVERRIDE)

	section code

auto_sprite_ram_tests:
		; bank to sprite ram
		lda	#$1
		sta	REG_CONTROL

		ldx	#d_mt_data
		jsr	memory_tests_handler

		lda	#$0
		sta	REG_CONTROL
		rts
