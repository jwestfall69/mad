	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"

	include "diag_rom.inc"
	include "machine.inc"

	global _start
	global	vblank_interrupt
	global	STR_PASSES
	global DERP

	section code

vblank_interrupt:
		move.w	#PALETTE_RAM_START / 256, REGA_PALETTE_RAM_BASE
		move.w	DERP, d5
		addq.w	#$1, d5
		move.w	d5, DERP
		rte

_start:
		reset
		PSUB_INIT

		move.b	#$80, $800030
		move.b	#$0, $800030
		move.b	#$f0, $800181

		ROMSET_PALETTE_SETUP

		move.w	#$ffc0, REGA_SCROLL1_X
		move.w	#$0, REGA_SCROLL1_Y

		PSUB	cps_a_init
		PSUB	screen_init

;		move.l	#$1ffff, d0
;	.derp:
;		move.w	#PALETTE_RAM_START / 256, REGA_PALETTE_RAM_BASE
;		subq.l	#$1, d0
;		tst.l	d0
;		bne	.derp

		PSUB	auto_dsub_tests


		RSUB_INIT
		bsr	main_menu

		SEEK_XY	0, 0
		lea	STR_PASSES, a0
		RSUB	print_string

		SEEK_XY	1, 1
		lea	STR_PASSES, a0
		RSUB	print_string

		SEEK_LN	3
		lea	STR_PASSES, a0
		RSUB	print_string

		clr.w	DERP

	.loop:

		move.w	DERP, d4
		tst.w	d4
		bne	.disable_ints

		SEEK_XY	4,10
		move.w	$800000, d0
		move.w	d0, d5
		RSUB	print_hex_word
		move.w	d5, d0
		btst	#4, d0
		beq	.do_palette
		btst	#5, d0
		beq	.do_all
		bra	.loop


	.disable_ints:
		move.w	#$2700, sr
		clr.w	DERP
		bra	.loop

;	.loop:
	.do_palette:
		;lea	PALETTE_RAM_START, a0
		;move.w	#(PALETTE_RAM_SIZE / 2), d0
		;RSUB	memory_rewrite_word
		move.w  #PALETTE_RAM_START / 256, REGA_PALETTE_RAM_BASE
		bra	.loop

	.do_all:
		move.w	#$2100, sr
		bra	.loop
;	.loop:
;		lea	SCROLL1_RAM_START, a0
;		move.w	#(SCROLL1_RAM_SIZE / 2), d0
;		PSUB	memory_rewrite_word
;		bra	.loop

		STALL

	section data

STR_PASSES:	STRING "PASSES"

	section bss
DERP:		dc.w $0
