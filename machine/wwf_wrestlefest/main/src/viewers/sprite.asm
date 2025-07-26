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

		move.w	#$1b18, r_sprite_num
		move.b	#$4, r_sprite_size
		move.w	#$60, r_sprite_pos_x
		move.w	#$40, r_sprite_pos_y

		clr.b	r_sprite_flip_x
		clr.b	r_sprite_flip_y

		lea	d_ve_settings, a0
		lea	d_ve_list, a1
		jsr	values_edit_handler
		rts

; Per MAME (ddragon3_v)
; * Sprite Format
; * ------------------
; *
; * Byte | Bit(s)   | Use
; * -----+-76543210-+----------------
; *   0  | -------- | Not used
; *   1  | xxxxxxxx | y position (low 8 bits)
; *   2  | -------- | Not used
; *   3  | xxx----- | sprite size / chain
; *   3  | ---x---- | flip x
; *   3  | ----x--- | flip y
; *   3  | -----x-- | x position (high bit)
; *   3  | ------x- | y position (high bit)
; *   3  | -------x | sprite enable
; *   4  | -------- | Not used
; *   5  | xxxxxxxx | sprite number (low 8 bits)
; *   6  | -------- | Not used
; *   7  | xxxxxxxx | sprite number (high 8 bits)
; *   8  | -------- | Not used
; *   9  | ----xxxx | palette number
; *  10  | -------- | Not used
; *  11  | xxxxxxxx | x postition (low 8 bits)
; * 12-15| -------- | Not used
; Only lower byte of each word is used
value_changed_cb:
		move.b	r_sprite_size, d0
		lsl.b	#$5, d0
		or.b	#$1, d0		; enable bit

		tst.b	r_sprite_flip_x
		beq	.skip_sprite_flip_x
		or.b	#$10, d0

	.skip_sprite_flip_x:
		tst.b	r_sprite_flip_y
		beq	.skip_sprite_flip_y
		or.b	#$08, d0

	.skip_sprite_flip_y:
		move.w	r_sprite_pos_x, d1
		move.b	d1, SPRITE_RAM + 11

		btst	#$8, d1
		beq	.skip_sprite_pos_x_high_bit
		or.b	#$04, d0

	.skip_sprite_pos_x_high_bit:
		move.w	r_sprite_pos_y, d1
		move.b	d1, SPRITE_RAM + 1

		btst	#$8, d1
		beq	.skip_sprite_pos_y_high_bit
		or.b	#$02, d0

	.skip_sprite_pos_y_high_bit:
		move.b	d0, SPRITE_RAM + 3

		move.w	r_sprite_num, d0
		move.b	d0, SPRITE_RAM + 5
		lsr.w	#$8, d0
		move.b	d0, SPRITE_RAM + 7

		clr.b	SPRITE_RAM + 9

		move.w	#$0, REG_SPRITE_COPY
		rts

loop_input_cb:
		rts

sprite_viewer_palette_setup:
		lea	d_palette_data, a0
		lea	SPRITE_PALETTE, a1
		moveq	#(PALETTE_SIZE / 8) - 1, d0

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
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_size, $7
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_sprite_pos_x, $1ff
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_sprite_pos_y, $1ff
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_flip_x, $1
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_flip_y, $1
	VE_LIST_END

d_palette_data:
	dc.w	$0000, $07af, $037e, $024b, $0138, $0016, $0000, $00af
	dc.w	$0059, $0047, $0cef, $00ef, $007a, $063f, $0008, $0999

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "SPRITE NUM"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), "SIZE"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 4), "POS X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 5), "POS Y"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 6), "FLIP X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 7), "FLIP Y"
	XY_STRING_LIST_END

	section bss
	align 1

r_sprite_num:		dcb.w 1
r_sprite_pos_x:		dcb.w 1
r_sprite_pos_y:		dcb.w 1
r_sprite_size:		dcb.b 1
r_sprite_flip_x:	dcb.b 1
r_sprite_flip_y:	dcb.b 1
