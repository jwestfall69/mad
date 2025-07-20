	include "cpu/68000/include/common.inc"

	global cps_a_init_dsub
	global palette_init_dsub
	global screen_init_dsub
	global screen_init_workaround_dsub
	global screen_seek_xy_dsub

	section code

palette_init_dsub:

		ROMSET_PALETTE_SETUP

		move.w	#ROMSET_LAYER_CTRL, REGB_LAYER_CTRL
		move.w	#ROMSET_PALETTE_CTRL, REGB_PALETTE_CTRL
		move.w	#PALETTE_RAM / 256, REGA_PALETTE_RAM_BASE
		move.w	#ROMSET_VIDEO_CTRL, REGA_VIDEO_CONTROL
		DSUB_RETURN

; The ram block we use for palette data is suppose to get copied to
; the palette ram whenever we write to REGA_PALETTE_RAM_BASE, however
; this doesn't seem to be the case 100% of the time.  It appears a
; number of games write to REGA_PALETTE_RAM_BASE within the vblank
; interrupt handler to get around this issue? Using an interrupt
; handler isn't something we can do before work ram is tested.  From
; testing it appears we can trigger the copy just by looping over
; clearing ram and writing to REGA_PALETTE_RAM_BASE a 3+ times.
screen_init_workaround_dsub:
		moveq	#1, d2
	.loop_workaround:

		lea	d_memory_fill_list, a0
		DSUB	memory_fill_list
		DSUB	palette_init
		dbra	d2, .loop_workaround

screen_init_dsub:

		lea	d_memory_fill_list, a0
		DSUB	memory_fill_list
		DSUB	palette_init

	ifd _SCREEN_TATE_
		SEEK_XY	3, 0
	else
		SEEK_XY	13, 0
	endif
		lea	d_str_version, a0
		DSUB	print_string

		SEEK_XY	0, 1
		move.l	#'-', d0
		moveq	#SCREEN_NUM_COLUMNS, d1
		DSUB	print_char_repeat

		SEEK_XY ((SCREEN_NUM_COLUMNS - _ROMSET_STR_LENGTH_) - 1), 1
		lea	d_str_romset, a0
		DSUB	print_string
		DSUB_RETURN

cps_a_init_dsub:

		; games seem to do this, mame hints this might trigger
		; a reset of the CPS A chip
		move.b	#$80, REG_COIN_CTRL
		move.b	#0, REG_COIN_CTRL

		move.w	#OBJECT_RAM / 256, REGA_OBJECT_RAM_BASE
		move.w	#SCROLL1_RAM / 256, REGA_SCROLL1_RAM_BASE
		move.w	#SCROLL2_RAM / 256, REGA_SCROLL2_RAM_BASE
		move.w	#SCROLL3_RAM / 256, REGA_SCROLL3_RAM_BASE
		move.w	#ROW_SCROLL_RAM / 256, REGA_ROW_SCROLL_RAM_BASE
		move.w	#PALETTE_RAM / 256, REGA_PALETTE_RAM_BASE
		DSUB_RETURN

; in cases where we need to goto x, y location at runtime
; params:
;  d0 = x
;  d1 = y
screen_seek_xy_dsub:
		SEEK_XY	0, 0
		and.l	#$ff, d0
		and.l	#$ff, d1
	ifd _SCREEN_TATE_
		lsl.l	#2, d0
		lsl.l	#7, d1
		adda.l	d0, a6
		suba.l	d1, a6
	else
		lsl.l	#7, d0
		lsl.l	#2, d1
		adda.l	d0, a6
		adda.l	d1, a6
	endif
		DSUB_RETURN

	section data
	align 1

d_memory_fill_list
	; this first one being $20 is a bit of a hack for now, its
	; because mercs uses tile_group $0 so filling with $0 results
	; in the screen being filled with "0" tiles.
	MEMORY_FILL_ENTRY SCROLL1_RAM, SCROLL1_RAM_SIZE, $20
	MEMORY_FILL_ENTRY SCROLL2_RAM, SCROLL2_RAM_SIZE, $0
	MEMORY_FILL_ENTRY SCROLL3_RAM, SCROLL3_RAM_SIZE, $0
	MEMORY_FILL_ENTRY OBJECT_RAM, OBJECT_RAM_SIZE, $0
	MEMORY_FILL_ENTRY ROW_SCROLL_RAM, ROW_SCROLL_RAM_SIZE, $0
	MEMORY_FILL_ENTRY PALETTE_RAM, PALETTE_RAM_SIZE, $f0f0
	MEMORY_FILL_LIST_END
