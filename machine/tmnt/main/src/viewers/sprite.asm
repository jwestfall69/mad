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

		move.w	#$600, r_sprite_num
		move.b	#$3, r_sprite_size
		move.w	#$b0, r_sprite_pos_x
		move.w	#$80, r_sprite_pos_y

		clr.b	r_sprite_zoom_x
		clr.b	r_sprite_zoom_y
		clr.b	r_sprite_flip_x
		clr.b	r_sprite_flip_y

		lea	d_ve_settings, a0
		lea	d_ve_list, a1
		jsr	values_edit_handler
		rts

; Per MAME (k051960)
; * Sprite Format
; * ------------------
; *
; * Byte | Bit(s)   | Use
; * -----+-76543210-+----------------
; *   0  | x------- | active (show this sprite)
; *   0  | -xxxxxxx | priority order
; *   1  | xxx----- | sprite size (see below)
; *   1  | ---xxxxx | sprite number (high 5 bits)
; *   2  | xxxxxxxx | sprite number (low 8 bits)
; *   3  | xxxxxxxx | "color", but depends on external connections (see below)
; *   4  | xxxxxx-- | zoom y (0 = normal, >0 = shrink)
; *   4  | ------x- | flip y
; *   4  | -------x | y position (high bit)
; *   5  | xxxxxxxx | y position (low 8 bits)
; *   6  | xxxxxx-- | zoom x (0 = normal, >0 = shrink)
; *   6  | ------x- | flip x
; *   6  | -------x | x position (high bit)
; *   7  | xxxxxxxx | x position (low 8 bits)
value_changed_cb:
		move.b	#$ff, SPRITE_RAM

		move.b	r_sprite_size, d0
		lsl.b	#$5, d0
		or.b	r_sprite_num, d0
		move.b	d0, SPRITE_RAM + 1

		move.b	r_sprite_num + 1, SPRITE_RAM + 2

		clr.b	SPRITE_RAM + 3

		move.b	r_sprite_zoom_y, d0
		lsl.b	#$2, d0
		or.b	r_sprite_pos_y, d0
		tst.b	r_sprite_flip_y
		beq	.skip_sprite_flip_y
		or.b	#$02, d0
	.skip_sprite_flip_y:
		move.b	d0, SPRITE_RAM + 4
		move.b	r_sprite_pos_y + 1, SPRITE_RAM + 5

		move.b	r_sprite_zoom_x, d0
		lsl.b	#$2, d0
		or.b	r_sprite_pos_x, d0
		tst.b	r_sprite_flip_x
		beq	.skip_sprite_flip_x
		or.b	#$02, d0
	.skip_sprite_flip_x:
		move.b	d0, SPRITE_RAM + 6
		move.b	r_sprite_pos_x + 1, SPRITE_RAM + 7
		rts

loop_input_cb:
		rts

sprite_viewer_palette_setup:
		lea	d_palette_data, a0
		lea	SPRITE_PALETTE, a1
		moveq	#(PALETTE_SIZE / 2) - 1, d0

	.loop_next_byte:
		addq.l	#$1, a1
		move.b	(a0)+, (a1)+
		dbra	d0, .loop_next_byte
		rts

	section data
	align 1

d_ve_settings:
	VE_SETTINGS value_changed_cb, loop_input_cb

d_ve_list:
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_EDGE, r_sprite_num, $1fff
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_size, $7
	VE_ENTRY VE_TYPE_BYTE, VE_INPUT_EDGE, r_sprite_zoom_x, $3f
	VE_ENTRY VE_TYPE_BYTE, VE_INPUT_EDGE, r_sprite_zoom_y, $3f
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_sprite_pos_x, $1ff
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_sprite_pos_y, $1ff
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_flip_x, $1
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_flip_y, $1
	VE_LIST_END

d_palette_data:
	dc.w	$0000, $0000, $01a0, $028d, $0374, $018e, $01f2, $0276
	dc.w	$029b, $6a55, $6611, $7ee0, $35ad, $5294, $6b5a, $2d6b

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "SPRITE NUM"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), "SIZE"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 4), "ZOOM X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 5), "ZOOM Y"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 6), "POS X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 7), "POS Y"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 8), "FLIP X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 9), "FLIP Y"
	XY_STRING_LIST_END

	section bss
	align 1

r_sprite_num:		dcb.w 1
r_sprite_pos_x:		dcb.w 1
r_sprite_pos_y:		dcb.w 1
r_sprite_size:		dcb.b 1
r_sprite_zoom_x:	dcb.b 1
r_sprite_zoom_y:	dcb.b 1
r_sprite_flip_x:	dcb.b 1
r_sprite_flip_y:	dcb.b 1
