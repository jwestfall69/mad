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

		move.w	#$40, r_sprite_num
		move.w	#$70, r_sprite_pos_x
		move.w	#$a0, r_sprite_pos_y


		clr.b	r_sprite_flip_x
		clr.b	r_sprite_offset_x
		clr.b	r_sprite_offset_y

		lea	d_ve_settings, a0
		lea	d_ve_list, a1
		jsr	values_edit_handler
		rts

; * Per MAME (toki.cpp):
; *  word           bit              usage
; * --------+-fedcba98 76543210-+----------------
; *    0    | x------- -------- | sprite disable ??
; *         | -xx----- -------- | tile is part of big sprite (4=first, 6=middle, 2=last)
; *         | -----x-- -------- | ??? always set? (could be priority - see Bloodbro)
; *         | ------x- -------- | Flip y
; *         | -------x -------- | Flip x
; *         | -------- xxxx---- | X offset: add (this * 16) to X coord
; *         | -------- ----xxxx | Y offset: add (this * 16) to Y coord
; *    1    | xxxx---- -------- | Color bank
; *         | ----xxxx xxxxxxxx | Tile number (lo bits)
; *    2    | x------- -------- | Tile number (hi bit)
; *         | -xxx---- -------- | (set in not yet used entries)
; *         | -------x xxxxxxxx | X coordinate
; *    3    | -------x xxxxxxxx | Y corrdinate
value_changed_cb:
		moveq	#$0, d0
		move.b	r_sprite_flip_y, d0
		lsl.b	#$1, d0
		or.b	r_sprite_flip_x, d0
		lsl.w	#$8, d0
		move.b	r_sprite_offset_x, d0
		lsl.b	#$4, d0
		or.b	r_sprite_offset_y, d0
		move.w	d0, SPRITE_RAM

		move.w	r_sprite_num, d0
		or.w	#(PALETTE_NUM << 12), d0
		move.w	d0, SPRITE_RAM + 2

		move.w	r_sprite_num, d0
		and.w	#$1000, d0
		lsl.w	#$3, d0

		or.w	r_sprite_pos_x, d0
		move.w	d0, SPRITE_RAM + 4

		move.w	r_sprite_pos_y, SPRITE_RAM + 6
		move.b	#$1, r_sprite_copy_req
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
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_EDGE, r_sprite_num, $1fff
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_sprite_pos_x, $1ff
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_sprite_pos_y, $1ff
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_offset_x, $f
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_offset_y, $f
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_flip_x, $1
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_flip_y, $1
	VE_LIST_END

d_palette_data:
	dc.w	$079a, $068a, $0479, $0369, $0258, $0237, $01f6, $03cf
	dc.w	$00af, $018d, $017a, $0f00, $06eb, $0eee, $0aaa, $0000

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "SPRITE NUM"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), "POS X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 4), "POS Y"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 5), "OFFSET X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 6), "OFFSET Y"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 7), "FLIP X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 8), "FLIP Y"
	XY_STRING_LIST_END

	section bss
	align 1

r_sprite_num:		dcb.w 1
r_sprite_pos_x:		dcb.w 1
r_sprite_pos_y:		dcb.w 1
r_sprite_flip_x:	dcb.b 1
r_sprite_flip_y:	dcb.b 1
r_sprite_offset_x:	dcb.b 1
r_sprite_offset_y:	dcb.b 1
