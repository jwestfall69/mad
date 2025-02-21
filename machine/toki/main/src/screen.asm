	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"

	include "machine.inc"
	include "mad_rom.inc"

	global screen_init_dsub
	global screen_seek_xy_dsub
	global screen_update_dsub

	section code

screen_init_dsub:
		; clear everything but work ram
		lea	NOT_WORK_RAM_START, a0
		move.l	#NOT_WORK_RAM_SIZE, d0
		moveq	#0, d1
		DSUB	memory_fill

		; There is some render difference between
		; hardware and mame such that hardware's
		; background ends up green while mame is
		; black.  It seems like something on the
		; hardware side isn't fully initialized
		; causing the background to point at a
		; random palette entry for its color.  Until
		; I can figure out wtf, I'm disabling the
		; poison.

		; bits are xxxx BBBB GGGG RRRR
		; poison palette by making everything green
		;lea	PALETTE_RAM_START, a0
		;move.l	#PALETTE_RAM_SIZE, d0
		;move.w	#$0f0, d1
		;DSUB	memory_fill

		; text color
		move.w	#$fff, PALETTE_RAM_START + $216

		; text shadow color
		move.w	#$222, PALETTE_RAM_START + $208

		; background color
		move.w	#0, PALETTE_RAM_START + $61e

		SEEK_XY	5, 0
		lea	d_str_version, a0
		DSUB	print_string

		SEEK_XY	0, 1
		move.l	#'-', d0
		moveq	#32, d1
		DSUB	print_char_repeat
		DSUB_RETURN

; in cases where we need to goto x, y location at runtime
; params:
;  d0 = x
;  d1 = y
screen_seek_xy_dsub:
		SEEK_XY	0, 0
		and.l	#$ff, d0
		and.l	#$ff, d1
		lsl.w	#1, d0
		lsl.w	#6, d1
		adda.l	d0, a6
		adda.l	d1, a6
		DSUB_RETURN


; toki only updates the screen when MMIO_UPDATE_SCREEN
; is written to.
screen_update_dsub:
		move.w	sr, d0
		btst	#8, d0
		beq	.skip_update
		SCREEN_UPDATE

	.skip_update:
		DSUB_RETURN
