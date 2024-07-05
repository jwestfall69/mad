	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"

	include "machine.inc"
	include "mad_rom.inc"

	global _start

	section code

_start:
		SOUND_STOP

		; hardware init
		; bg layer
		move.w #$ffb2, $7a300
		move.w #$fff0, $7a304
		move.w #$0010, $7a308
		move.w #$0000, $7a30c
		move.w #$0004, $7a310

		; fg layer
		move.w #$ffb2, $7a200
		move.w #$fff0, $7a204
		move.w #$0010, $7a208
		move.w #$0000, $7a20c
		move.w #$0004, $7a210

		; txt layer
		move.w #$ffb2, $7a100

		; mame and hardware don't seem to agree on the 'y' scroll
		; value meaning.  A value of $20 in mame causes the header
		; to be off the top of the screen.  A value of $0 on hardware
		; causes the header to start 2 rows down.
	ifd _MAME_BUILD_
		move.w #$0000, $7a104
	else
		move.w #$0020, $7a104
	endif
		move.w #$0000, $7a108
		move.w #$0000, $7a10c
		move.w #$0003, $7a110
		move.w #$0, $7a808

		PSUB_INIT
		PSUB	screen_init
		PSUB	auto_dsub_tests

		RSUB_INIT
		;bsr	auto_func_tests

		move.w	#SOUND_NUM_SUCCESS, d0
		SOUND_PLAY

		bsr	main_menu
