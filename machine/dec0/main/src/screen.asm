	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/memory_fill.inc"

	include "machine.inc"
	include "mad.inc"

	global screen_init_dsub
	global screen_seek_xy_dsub

	section code

screen_clear_dsub:


screen_init_dsub:

		lea	d_memory_fill_list, a0
		DSUB	memory_fill_list

		; mame and hardware don't seem to agree on screen flip
		; setting (bit 7 on REG_TILE1_CTRL1).  The bit set to 1 on
		; hardware is right side up, but mame is upside down and
		; vice versa if set to 0.  To avoid having to have different
		; hardware/mame build going to read the dsw bit normally used
		; for screen flip and apply it.  The dsw1 read could be bad,
		; but oh well.
		move.b	REG_INPUT_DSW1, d0
		not.b	d0
		and.w	DSW1_SCREEN_FLIP, d0	; bit 6, also zero out upper nibble
		lsl.b	#1, d0			; shift over to 7 to align with bit for REG_TILE1_CTRL1
		or.b	#$3, d0			; 8x8 tiles, not flipped?
		lea	REG_TILE1_CTRL1, a0
		move.w	d0, (a0)+
		move.w	#$3, (a0)+
		move.w	#$0, (a0)+
		move.w	#$1, (a0)+

		ROMSET_PALETTE_SETUP

		SEEK_XY	0, 1
		move.l	#'-', d0
		moveq	#32, d1
		DSUB	print_char_repeat

	ifd _SCREEN_TATE_
		SEEK_XY	4, 0
	else
		SEEK_XY	5, 0
	endif
		lea	d_str_version, a0
		DSUB	print_string
		DSUB_RETURN

screen_seek_xy_dsub:
		SEEK_XY	0, 0
		and.l	#$ff, d0
		and.l	#$ff, d1

	ifd _SCREEN_TATE_
		lsl.w	#6, d0
		lsl.w	#1, d1
		add.l	d0, a6
		sub.l	d1, a6
	else
		lsl.w	#1, d0
		lsl.w	#6, d1
		add.l	d0, a6
		add.l	d1, a6
	endif
		DSUB_RETURN

	section data
	align 2

d_memory_fill_list:
		MEMORY_FILL_ENTRY REG_TILE1_CTRL2, $8, $0
		MEMORY_FILL_ENTRY REG_TILE2_CTRL1, $8, $0
		MEMORY_FILL_ENTRY REG_TILE2_CTRL2, $8, $0
		MEMORY_FILL_ENTRY REG_TILE3_CTRL1, $8, $0
		MEMORY_FILL_ENTRY REG_TILE3_CTRL2, $8, $0
		MEMORY_FILL_ENTRY REG_TILE1_COLUMN_SCROLL, $2000, $0
		MEMORY_FILL_ENTRY REG_TILE2_COLUMN_SCROLL, $2000, $0
		MEMORY_FILL_ENTRY REG_TILE3_COLUMN_SCROLL, $2000, $0
		MEMORY_FILL_ENTRY TILE1_RAM_START, TILE1_RAM_SIZE, $0
		MEMORY_FILL_ENTRY TILE2_RAM_START, TILE2_RAM_SIZE, $0
		MEMORY_FILL_ENTRY TILE3_RAM_START, TILE3_RAM_SIZE, $0
		MEMORY_FILL_ENTRY SPRITE_RAM_START, SPRITE_RAM_SIZE, $0
		MEMORY_FILL_ENTRY PALETTE_RAM_START, PALETTE_RAM_SIZE, $0
		MEMORY_FILL_ENTRY PALETTE_EXT_RAM_START, PALETTE_EXT_RAM_SIZE, $0
		MEMORY_FILL_LIST_END
