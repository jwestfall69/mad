	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/values_edit.inc"

	global sprite_viewer
	global sprite_viewer_palette_setup

	section code

sprite_viewer:
		jsr	sprite_viewer_palette_setup

		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list
		jsr	print_b2_return_to_menu

		move.w	#$1, r_sprite_num
		move.b	#$5, r_sprite_size
		move.w	#$e0, r_sprite_pos_x
		move.w	#$110, r_sprite_pos_y
		move.w	#$40, r_sprite_zoom_x
		move.w	#$40, r_sprite_zoom_y

		clr.b	r_sprite_flip_x
		clr.b	r_sprite_flip_y
		clr.b	r_sprite_mirror_x
		clr.b	r_sprite_mirror_y
		clr.b	r_sprite_shadow
		clr.b	r_sprite_effect

		lea	d_ve_settings, a0
		lea	d_ve_list, a1

		;move.b	#$10, $108025	; enable sprite dma
		jsr	values_edit_handler
		;move.b	#$0, $108025
		rts

; Per MAME (k053247)
; * Sprite Format
; * ------------------
; *
; * Word | Bit(s)           | Use
; * -----+-fedcba98 76543210-+----------------
; *   0  | x------- -------- | active (show this sprite)
; *   0  | -x------ -------- | maintain aspect ratio (when set, zoom y acts on both axis)
; *   0  | --x----- -------- | flip y
; *   0  | ---x---- -------- | flip x
; *   0  | ----xxxx -------- | sprite size (2 bits height, 2 bit width)
; *   0  | -------- xxxxxxxx | zcode
; *   1  | xxxxxxxx xxxxxxxx | sprite code (lower 6 bits seem to be doing fine x/y adjustments?)
; *   2  | ------xx xxxxxxxx | y position
; *   3  | ------xx xxxxxxxx | x position
; *   4  | xxxxxxxx xxxxxxxx | zoom y (0x40 = normal, <0x40 = enlarge, >0x40 = reduce)
; *   5  | xxxxxxxx xxxxxxxx | zoom x (0x40 = normal, <0x40 = enlarge, >0x40 = reduce, ignored if maintain aspect ratio = 1)
; *   6  | x------- -------- | mirror y (top half is drawn as mirror image of the bottom)
; *   6  | -x------ -------- | mirror x (right half is drawn as mirror image of the left)
; *   6  | --xx---- -------- | reserved (sprites with these two bits set don't seem to be graphics data at all)
; *   6  | ----xx-- -------- | shadow code: 0=off, 0x400=preset1, 0x800=preset2, 0xc00=preset3
; *   6  | ------xx -------- | effect code: flicker, upper palette, full shadow...etc. (game dependent)
; *   6  | -------- xxxxxxxx | "color", but depends on external connections (implies priority)
; *   7  | xxxxxxxx xxxxxxxx | game dependent
value_changed_cb:

		move.w	#$8001, d0	; active sprite + zcode
		tst.b	r_sprite_aspect_ratio
		beq	.skip_sprite_aspect_ratio
		or.w	#$4000, d0

	.skip_sprite_aspect_ratio:
		tst.b	r_sprite_flip_y
		beq	.skip_sprite_flip_y
		or.w	#$2000, d0

	.skip_sprite_flip_y:
		tst.b	r_sprite_flip_x
		beq	.skip_sprite_flip_x
		or.w	#$1000, d0

	.skip_sprite_flip_x:
		move.b	r_sprite_size, d1
		lsl.w	#$8, d1
		or.w	d1, d0
		move.w	d0, SPRITE_RAM


		move.w	r_sprite_num, d0
		lsl.w	#$6, d0
		move.w	d0, SPRITE_RAM + 2

		move.w	r_sprite_pos_y, SPRITE_RAM + 4
		move.w	r_sprite_pos_x, SPRITE_RAM + 6
		move.w	r_sprite_zoom_y, SPRITE_RAM + 8
		move.w	r_sprite_zoom_x, SPRITE_RAM + 10

		moveq	#$0, d0
		move.b	r_sprite_shadow, d0
		lsl.w	#$2, d0
		or.b	r_sprite_effect, d0
		lsl.w	#$8, d0

		tst.b	r_sprite_mirror_y
		beq	.skip_sprite_mirror_y
		or.w	#$8000, d0

	.skip_sprite_mirror_y:
		tst.b	r_sprite_mirror_x
		beq	.skip_sprite_mirror_x
		or.w	#$4000, d0

	.skip_sprite_mirror_x:
		move.w	d0, SPRITE_RAM + 12
		clr.w	SPRITE_RAM + 14
		rts

loop_input_cb:
		rts

sprite_viewer_palette_setup:
		lea	d_palette_data, a0
		lea	SPRITE_PALETTE, a1
		moveq	#(PALETTE_SIZE / 2) - 1, d0

	.loop_next_byte:
		move.w	(a0)+, (a1)+
		dbra	d0, .loop_next_byte
		rts

	section data
	align 1

d_ve_settings:
	VE_SETTINGS value_changed_cb, loop_input_cb

d_ve_list:
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_EDGE, r_sprite_num, $ffff
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_size, $f
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_aspect_ratio, $1
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_EDGE, r_sprite_zoom_x, $ffff
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_EDGE, r_sprite_zoom_y, $ffff
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_sprite_pos_x, $3ff
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_sprite_pos_y, $3ff
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_flip_x, $1
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_flip_y, $1
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_mirror_x, $1
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_mirror_y, $1
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_shadow, $3
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_effect, $3
	VE_LIST_END

d_palette_data:
	dc.w	$3def, $0002, $2800, $48c0, $7da0, $0137, $021e, $033f
	dc.w	$0028, $2596, $365c, $575e, $001c, $7fff, $5652, $2908

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "SPRITE NUM"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), "SIZE"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 4), "ASPECT RATIO"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 5), "ZOOM X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 6), "ZOOM Y"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 7), "POS X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 8), "POS Y"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 9), "FLIP X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 10), "FLIP Y"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 11), "MIRROR X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 12), "MIRROR Y"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 13), "SHADOW"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 14), "EFFECT"
	XY_STRING_LIST_END

	section bss
	align 1

r_sprite_num:		dcb.w 1
r_sprite_zoom_x:	dcb.w 1
r_sprite_zoom_y:	dcb.w 1
r_sprite_pos_x:		dcb.w 1
r_sprite_pos_y:		dcb.w 1
r_sprite_size:		dcb.b 1
r_sprite_aspect_ratio:	dcb.b 1
r_sprite_flip_x:	dcb.b 1
r_sprite_flip_y:	dcb.b 1
r_sprite_mirror_x:	dcb.b 1
r_sprite_mirror_y:	dcb.b 1
r_sprite_shadow:	dcb.b 1
r_sprite_effect:	dcb.b 1
