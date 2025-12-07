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

		move.w	#$54c, r_sprite_num
		move.b	#$1, r_sprite_size
		move.w	#$90, r_sprite_pos_x
		move.w	#$70, r_sprite_pos_y

		clr.b	r_sprite_flip_x
		clr.b	r_sprite_flip_y

		lea	d_ve_settings, a0
		lea	d_ve_list, a1
		jsr	values_edit_handler
		rts

; Per MAME (wwfsstar.cpp)
; * Sprite Format
; * ------------------
; * only lower byte of word
; *
; * Byte |      Bit(s)       | Use
; * -----+-fedcba98 76543210-+----------------
; *   0  | -------- xxxxxxxx | y position (low 8 bits)
; *   1  | -------- xxxx---- | palette
; *   1  | -------- ----x--- | x position (high bit)
; *   1  | -------- -----x-- | y position (high bit)
; *   1  | -------- ------x- | sprite size (1 = 32x16)
; *   1  | -------- -------x | sprite enable
; *   2  | -------- x------- | flip y
; *   2  | -------- -x------ | flip x
; *   2  | -------- --xxxxxx | sprite number (high bits)
; *   3  | -------- xxxxxxxx | sprite number (low 8 bits)
; *   4  | -------- xxxxxxxx | x position (low 8 bits)

value_changed_cb:
		moveq	#$1, d1		; enable

		move.w	r_sprite_pos_x, d0
		btst	#$8, d0
		beq	.skip_sprite_pos_x_high_bit
		or.b	#$8, d1

	.skip_sprite_pos_x_high_bit:
		and.w	#$ff, d0
		move.w	d0, SPRITE_RAM + 8
		move.w	r_sprite_pos_y, d0
		btst	#$8, d0
		beq	.skip_sprite_pos_y_high_bit
		or.b	#$4, d1

	.skip_sprite_pos_y_high_bit:
		and.w	#$ff, d0
		move.w	d0, SPRITE_RAM
		move.b	r_sprite_size, d0
		lsl.b	#$1, d0
		or.b	d0, d1
		move.w	d1, SPRITE_RAM + 2


		moveq	#$0, d1
		moveq	#$0, d0
		tst.b	r_sprite_flip_x
		beq	.skip_sprite_flip_x
		or.b	#$40, d1

	.skip_sprite_flip_x:
		tst.b	r_sprite_flip_y
		beq	.skip_sprite_flip_y
		or.b	#$80, d1

	.skip_sprite_flip_y:
		move.w	r_sprite_num, d0
		and.w	#$ff00, d0
		lsr.w	#$8, d0
		or.b	d0, d1
		move.w	d1, SPRITE_RAM + 4

		move.w	r_sprite_num, d0
		and.w	#$ff, d0
		move.w	d0, SPRITE_RAM + 6
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
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_EDGE, r_sprite_num, $fff
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_size, $1
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_sprite_pos_x, $1ff
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_sprite_pos_y, $1ff
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_flip_x, $1
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_flip_y, $1
	VE_LIST_END

d_palette_data:
	dc.w	$0000, $0abf, $078f, $025e, $023b, $0328, $0000, $03ff
	dc.w	$01af, $016a, $0ddf, $019f, $025e, $000a, $03ff, $0755

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
