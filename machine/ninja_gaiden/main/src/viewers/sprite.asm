	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/values_edit.inc"

	global sprite_viewer
	global sprite_viewer_palette_setup

	section code

PALETTE_NUM		equ $1

sprite_viewer:
		jsr	sprite_viewer_palette_setup

		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list
		jsr	print_b2_return_to_menu

		move.w	#$17d0, r_sprite_num
		move.b	#$2, r_sprite_size
		move.w	#$70, r_sprite_pos_x
		move.w	#$80, r_sprite_pos_y

		clr.b	r_sprite_flip_x
		clr.b	r_sprite_flip_y
		clr.b	r_sprite_blend
		clr.b	r_sprite_priority

		lea	d_ve_settings, a0
		lea	d_ve_list, a1
		jsr	values_edit_handler
		rts

; * Per MAME (shared/tecmo_spr.cpp):
; *  word           bit              usage
; * --------+-fedcba98 76543210-+----------------
; *    0    | -------- -------x | flip x
; *         | -------- ------x- | flip y
; *         | -------- -----x-- | enable
; *         | -------- --x----- | blend
; *         | -------- xx------ | sprite-tile priority
; *    1    | xxxxxxxx xxxxxxxx | number
; *    2    | -------- xxxx---- | palette
; *         | -------- ------xx | size: 8x8, 16x16, 32x32, 64x64
; *    3    | xxxxxxxx xxxxxxxx | y position
; *    4    | xxxxxxxx xxxxxxxx | x position
; *    5,6,7|                   | unused
value_changed_cb:
		moveq	#$4, d0		; enable
		or.b	r_sprite_flip_x, d0
		move.b	r_sprite_flip_y, d1
		lsl.b	#$1, d1
		or.b	d1, d0
		move.b	r_sprite_blend, d1
		lsl.b	#$5, d1
		or.b	d1, d0
		move.b	r_sprite_priority, d1
		lsl.b	#$6, d1
		or.b	d1, d0
		move.w	d0, SPRITE_RAM
		move.w	r_sprite_num, SPRITE_RAM + 2

		moveq	#(PALETTE_NUM << 4), d0
		or.b	r_sprite_size, d0
		move.w	d0, SPRITE_RAM + 4
		move.w	r_sprite_pos_y, SPRITE_RAM + 6
		move.w	r_sprite_pos_x, SPRITE_RAM + 8
		clr.w	SPRITE_RAM + 10
		clr.w	SPRITE_RAM + 12
		clr.w	SPRITE_RAM + 14
		rts

loop_input_cb:
		rts
; Palette Layout
;  xxxx BBBB GGGG RRRR
sprite_viewer_palette_setup:

		lea	SPRITE_PALETTE + (PALETTE_SIZE * PALETTE_NUM), a0
		lea	d_palette_data, a1
		moveq	#(PALETTE_SIZE/2 - 1), d0

	.loop_next_color:
		move.w	(a1)+, d1
		move.w	d1, (a0)+
		dbra	d0, .loop_next_color
		rts

	section data
	align 1

d_ve_settings:
	VE_SETTINGS value_changed_cb, loop_input_cb

d_ve_list:
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_EDGE, r_sprite_num, $ffff
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_size, $7
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_sprite_pos_x, $1ff
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_sprite_pos_y, $1ff
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_flip_x, $1
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_flip_y, $1
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_blend, $1
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_priority, $3
	VE_LIST_END

d_palette_data:
	dc.w	$0000, $0fff, $0040, $0633, $0855, $0a77, $0c99, $0ebb
	dc.w	$0008, $000b, $007f, $0358, $09bd, $057a, $0bdf, $079c

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "SPRITE NUM"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), "SIZE"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 4), "POS X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 5), "POS Y"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 6), "FLIP X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 7), "FLIP Y"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 8), "BLEND"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 9), "PRIORITY"
	XY_STRING_LIST_END

	section bss
	align 1

r_sprite_num:		dcb.w 1
r_sprite_pos_x:		dcb.w 1
r_sprite_pos_y:		dcb.w 1
r_sprite_size:		dcb.b 1
r_sprite_flip_x:	dcb.b 1
r_sprite_flip_y:	dcb.b 1
r_sprite_blend:		dcb.b 1
r_sprite_priority:	dcb.b 1
