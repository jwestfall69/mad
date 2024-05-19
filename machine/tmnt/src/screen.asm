	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"

	include "machine.inc"
	include "mad_rom.inc"

	global screen_clear_dsub
	global screen_init_dsub
	global screen_seek_xy_dsub

	section code

screen_clear_dsub:

		; tile ram seems to only work if you
		; byte writes
		lea	TILE_RAM_START, a0
		move.w	#(TILE_RAM_SIZE / 2) - 1, d0
	.loop_next_address:
		move.b	#$ff, (a0)+	; space
		move.b	#$ff, (a0)+
		dbra	d0, .loop_next_address

		lea	TILE_RAM_START, a0
		move.w	#($1000 / 2) - 1, d0
	.loop_derp:
		move.b	#$0, (a0)+	; space
		move.b	#$10, (a0)+
		dbra	d0, .loop_derp

		move.w	#$0, $106b00
		move.w	#$0, $106e00
		move.b	#$0, $106900
		move.b	#$0, $106b00
		move.b	#$0, $106e00
		move.b	#$0, $106c00

		SEEK_XY 13, 0
		lea	STR_HEADER, a0
		DSUB	print_string

		SEEK_XY	0, 1
		move.l	#'<', d0
		moveq	#40, d1
		DSUB	print_char_repeat
		DSUB_RETURN

screen_init_dsub:

		lea	PALETTE_RAM_START, a0
		move.l	#PALETTE_RAM_SIZE, d0
		moveq	#0, d1
		DSUB	memory_fill

		; text color
		move.b	#$ff, PALETTE_RAM_START + $5
		move.b	#$ff, PALETTE_RAM_START + $7
		move.b	#$ff, PALETTE_RAM_START + $9
		move.b	#$ff, PALETTE_RAM_START + $b
		bra	screen_clear_dsub

; in cases where we need to goto x, y location at runtime
; params:
;  d0 = x
;  d1 = y
screen_seek_xy_dsub:
		SEEK_XY	0, 0
		and.l	#$ff, d0
		and.l	#$ff, d1
		lsl.w	#1, d0
		lsl.w	#7, d1
		adda.l	d0, a6
		adda.l	d1, a6
		DSUB_RETURN

	section data

STR_HEADER:	STRING "TMNT < MAD 0=1"

