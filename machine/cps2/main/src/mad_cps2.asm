	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"

	include "machine.inc"
	include "mad_rom.inc"

	global _start

	section code

_start:
		INTS_DISABLE

		move.w	#$0, $8040a0

		; This comes from razoola's suicided tester /
		; phoenix roms.  Its unclear what this is actually
		; doing since the the destination is ram.  Without
		; it the screen will remain purple like a normally
		; suicided board.  Assuming it has something to do
		; with bypassing the cps2's watchdog instruction.
		move.w	#$7000, $fffff0
		move.w	#$807d, $fffff2
		move.w	#$1234, $fffff4
		move.w	#$0, $fffff6
		move.w	#$40, $fffff8
		move.w	#$10, $fffffa

		move.w	#$ffc0, REGA_SCROLL1_X
		move.w	#$0, REGA_SCROLL1_Y

		;SOUND_STOP

		PSUB_INIT
		PSUB	screen_init
		PSUB	auto_dsub_tests

		RSUB_INIT
		bsr	auto_func_tests

		clr.b	r_menu_cursor
		bra	main_menu
