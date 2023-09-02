	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"

	include "diag_rom.inc"
	include "machine.inc"

	global _start
	global	vblank_interrupt
	global	STR_PASSES

	section code

_start:
		PSUB_INIT
		PSUB	screen_init

		PSUB	auto_dsub_tests

		RSUB_INIT

		clr.b	INPUT_P1_EDGE
		clr.b	INPUT_P1_RAW
		clr.b	INPUT_P2_EDGE
		clr.b	INPUT_P2_RAW
		clr.b	INPUT_SYSTEM_EDGE
		clr.b	INPUT_SYSTEM_RAW
		clr.b	MAIN_MENU_CURSOR

		bsr	main_menu

		SEEK_XY	10,11
		lea	STR_PASSES, a0
		RSUB	print_string
;	.loop:
;		lea	PALETTE_RAM_START, a0
;		move.w	#(PALETTE_RAM_SIZE / 2), d0
;		PSUB	memory_rewrite_word
;		bra	.loop

		STALL

	section data

STR_PASSES:	STRING "PASSES"
