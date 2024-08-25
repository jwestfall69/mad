	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/memory_fill.inc"

	include "machine.inc"
	include "mad_rom.inc"

	global screen_clear_dsub
	global screen_init_dsub
	global screen_seek_xy_dsub


	section code

screen_clear_dsub:
		lea	MEMORY_FILL_LIST, a0
		DSUB	memory_fill_list

		SEEK_XY	2, 0
		lea	STR_HEADER, a0
		DSUB	print_string

		SEEK_XY	0, 1
		move.l	#'-', d0
		moveq	#32, d1
		DSUB	print_char_repeat
		DSUB_RETURN


; setup palette, then clear the screen
screen_init_dsub:

		lea	PALETTE_RAM_START, a0
		move.l	#PALETTE_RAM_SIZE, d0
		moveq	#0, d1
		DSUB	memory_fill

		; text color
		lea	PALETTE_RAM_START + $2, a0
		move.w	#$0fff, (a0)

		; text shadow
		lea	PALETTE_RAM_START + $a, a0
		move.w	#$0111, (a0)

		; background color
		lea	PALETTE_RAM_START + $ffe, a0
		move.w	#$0000, (a0)

		bra	screen_clear_dsub

; in cases where we need to goto x, y location at runtime
; params:
;  d0 = x
;  d1 = y
screen_seek_xy_dsub:
		SEEK_XY	0, 0
		and.l	#$ff, d0
		and.l	#$ff, d1

		lsl.w	#2, d0
		lsl.w	#7, d1
		suba.l	d0, a6
		adda.l	d1, a6
		DSUB_RETURN

	section data

	align 2
MEMORY_FILL_LIST:
	MEMORY_FILL_ENTRY TILE_RAM_START, TILE_RAM_SIZE, $0020
;	MEMORY_FILL_ENTRY PALETTE_RAM_START, PALETTE_RAM_SIZE, $0
	MEMORY_FILL_ENTRY SPRITE_RAM_START, SPRITE_RAM_SIZE, $0
	MEMORY_FILL_LIST_END

STR_HEADER:	STRING "TIME SOLDIERS - MAD 0.01"
