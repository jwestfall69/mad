	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"
	include "cpu/68000/menu_input.inc"

	include "machine.inc"
	include "mad_rom.inc"

	global _start
	global	STR_PASSES

	section code

_start:

		; one of these causes the sync
		; signal to start
		move.w #$0081, $100008
		move.w #$0050, $10000c
		move.w #$00ab, $140006
		move.w #$00f7, $140012
		move.w #$0001, $140014

		PSUB_INIT
		PSUB	screen_init
		PSUB	auto_dsub_tests

		RSUB_INIT

		clr.b	INPUT_P1_EDGE
		clr.b	INPUT_P1_RAW
		clr.b	INPUT_SYSTEM_EDGE
		clr.b	INPUT_SYSTEM_RAW
		clr.b	MENU_CURSOR

		bsr	auto_func_tests

		moveq	#SOUND_NUM_SUCCESS, d0
		SOUND_PLAY

		bsr	main_menu

	section data

STR_PASSES:	STRING "PASSES"