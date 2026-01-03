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

		move.l	#RS_SV_SPRITE_NUM, r_sprite_num
		move.w	#RS_SV_SPRITE_POS_X, r_sprite_pos_x
		move.w	#RS_SV_SPRITE_POS_Y, r_sprite_pos_y
		move.b	#RS_SV_SPRITE_SIZE_X, r_sprite_size_x
		move.b	#RS_SV_SPRITE_SIZE_Y, r_sprite_size_y

		clr.b	r_sprite_flip_x
		clr.b	r_sprite_flip_y

		lea	d_ve_settings, a0
		lea	d_ve_list, a1
		jsr	values_edit_handler
		rts

; Per MAME (capcom/cps2.cpp)
; * Sprite Format
; * ------------------
; *
; * Byte | Bit(s)   | Use
; * -----+-76543210-+----------------
; *   0  | xxx----- | priority
; *   0  | ------xx | x position (high bits)
; *   1  | xxxxxxxx | x position (low bits)
; *   2  | -xx----- | sprite num (top 2 bits)
; *   2  | ------xx | y position (high bits)
; *   3  | xxxxxxxx | y position (low bits)
; *   4  | xxxxxxxx | sprite num (high bits)
; *   5  | xxxxxxxx | sprite num (low bits)
; *   6  | xxxx---- | y size
; *   6  | ----xxxx | x size
; *   7  | x------- | x & y offset toggle
; *   7  | -x------ | y flip
; *   7  | --x----- | x flip
; *   7  | ---xxxxx | color/palette num

value_changed_cb:
		move.b	#$0, REG_OBJECT_RAM_BANK

		move.w	r_sprite_pos_x, d0
		or.w	#$4000, d0		; priority
		move.w	d0, OBJECT_RAM

		move.l	r_sprite_num, d0
		move.w	d0, OBJECT_RAM + 4

		; deal with upper 2 bits of sprite num
		lsr.l	#$3, d0
		and.w	#$6000, d0
		or.w	r_sprite_pos_y, d0
		move.w	d0, OBJECT_RAM + 2

		move.b	r_sprite_size_y, d0
		lsl.b	#$4, d0
		or.b	r_sprite_size_x, d0
		move.b	d0, OBJECT_RAM + 6

		moveq	#$0, d0
		tst.b	r_sprite_flip_x
		beq	.skip_sprite_flip_x
		or.b	#$20, d0

	.skip_sprite_flip_x:
		tst.b	r_sprite_flip_y
		beq	.skip_sprite_flip_y
		or.b	#$40, d0

	.skip_sprite_flip_y:
		move.b	d0, OBJECT_RAM + 7

		move.b	#$1, REG_OBJECT_RAM_BANK
		rts

loop_input_cb:
		rts

sprite_viewer_palette_setup:
		lea	d_palette_data, a0
		lea	OBJECT_PALETTE, a1
		moveq	#(PALETTE_SIZE / 2) - 1, d0

	.loop_next_byte:
		move.w	(a0)+, (a1)+
		dbra	d0, .loop_next_byte
		RSUB	screen_update_palette
		rts

	section data
	align 1

d_ve_settings:
	VE_SETTINGS value_changed_cb, loop_input_cb

d_ve_list:
	VE_ENTRY VE_TYPE_3_BYTES, VE_INPUT_EDGE, r_sprite_num, $3ffff
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_size_x, $f
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_size_y, $f
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_sprite_pos_x, $3ff
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_sprite_pos_y, $3ff
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_flip_x, $1
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_flip_y, $1
	VE_LIST_END

d_palette_data:
	RS_SV_PALETTE_DATA

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "SPRITE NUM"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), "SIZE X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 4), "SIZE Y"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 5), "POS X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 6), "POS Y"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 7), "FLIP X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 8), "FLIP Y"
	XY_STRING_LIST_END

	section bss
	align 1

r_sprite_num:		dcb.l 1
r_sprite_pos_x:		dcb.w 1
r_sprite_pos_y:		dcb.w 1
r_sprite_flip_x:	dcb.b 1
r_sprite_flip_y:	dcb.b 1
r_sprite_size_x:	dcb.b 1
r_sprite_size_y:	dcb.b 1
