	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"

	include "machine.inc"
	include "mad_rom.inc"

	global screen_clear_dsub
	global screen_init_dsub
	global screen_seek_xy_dsub

	section code

screen_clear_dsub:

		lea	TILE_RAM_START, a0
		move.l	#$1000, d0
		move.w	#$10, d1
		DSUB	memory_fill_tile

		lea	TILE_RAM_START+$2000, a0
		move.l	#$1000, d0
		move.w	#$10, d1
		DSUB	memory_fill_tile

		lea	TILE_RAM_START+$4000, a0
		move.l	#$1000, d0
		move.w	#$10, d1
		DSUB	memory_fill_tile

		lea	TILE_RAM_START+$6000, a0
		move.l	#$800, d0
		move.w	#$0000, d1
		DSUB	memory_fill_tile

		move.w	#$0, $106b00
		move.w	#$0, $106e00
		move.b	#$0, $106900
		move.b	#$0, $106b00
		move.b	#$0, $106e00
		move.b	#$0, $106c00

		SEEK_XY 13, 0
		lea	d_str_header, a0
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

; fills memory with byte writes
; params:
;  a0 = start address
;  d0 = number of bytes (long)
;  d1 = value (word)
; this may need to be move to common but for now only
; tmnt has memory that requires being written as bytes
memory_fill_tile_dsub:
		lsr.l	#1, d0	; convert to words
		move.b	d1, d2
		lsr.w	#8, d1

	.loop_next_address:
		move.b	d1, (a0)+
		move.b	d2, (a0)+
		subq.l	#1, d0
		bne	.loop_next_address
		WATCHDOG
		DSUB_RETURN

	section data
	align 2

d_str_header:	STRING "TMNT < MAD 0=1"
