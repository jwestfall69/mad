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

		move.w	#$279, r_sprite_num
		move.w	#$80, r_sprite_pos_x
		move.w	#$70, r_sprite_pos_y

		clr.b	r_sprite_flip_x
		clr.b	r_sprite_flip_y

		clr.b	r_sprite_dma_req

		CPU_INTS_ENABLE

		lea	d_ve_settings, a0
		lea	d_ve_list, a1
		jsr	values_edit_handler

		CPU_INTS_DISABLE

		jsr	sprite_ram_clear
		rts

; Per MAME (capcom/lastduel_v.cpp)
; * Sprite Format
; * ------------------
; *
; * word |        Bit(s)      | Use
; * -----+-fedcba098 76543210-+----------------
; *   0  | --------x xxxxxxxx | sprite num
; *   1  | --------- --xxxx-- | palette num
; *   1  | --------- ------x- | flip y
; *   1  | --------- -------x | flip x
; *   2  | --------x xxxxxxxx | x position
; *   3  | --------x xxxxxxxx | y position
value_changed_cb:
		move.w	r_sprite_num, SPRITE_RAM + $800
		move.w	r_sprite_pos_x, SPRITE_RAM + $804
		move.w	r_sprite_pos_y, SPRITE_RAM + $806

		clr.w	d0
		tst.b	r_sprite_flip_x
		beq	.skip_sprite_flip_x
		or.b	#$1, d0

	.skip_sprite_flip_x:
		tst.b	r_sprite_flip_y
		beq	.skip_sprite_flip_y
		or.b	#$2, d0

	.skip_sprite_flip_y:
		move.w	d0, SPRITE_RAM + $802
		move.b	#$1, r_sprite_dma_req
		rts

loop_input_cb:
		rts

sprite_viewer_palette_setup:
		lea	d_palette_data, a0
		lea	SPRITE_PALETTE, a1
		move.w	#SPRITE_PALETTE_SIZE / 2, d0
		jsr	memory_copy
		rts

	section data
	align 1

d_palette_data:
	dc.w	$0000, $0eb9, $0c98, $0965, $0da0, $0ddd, $0aaa, $0777
	dc.w	$0900, $0d00, $0090, $00d0, $005b, $008e, $0eee, $0111

d_ve_settings:
	VE_SETTINGS value_changed_cb, loop_input_cb

d_ve_list:
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_EDGE, r_sprite_num, $7ff
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_sprite_pos_x, $1ff
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_sprite_pos_y, $1ff
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_flip_x, $1
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_flip_y, $1
	VE_LIST_END

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "SPRITE NUM"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), "POS X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 4), "POS Y"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 5), "FLIP X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 6), "FLIP Y"
	XY_STRING_LIST_END

	section bss
	align 1

r_sprite_num:		dcb.w 1
r_sprite_pos_x:		dcb.w 1
r_sprite_pos_y:		dcb.w 1
r_sprite_flip_x:	dcb.b 1
r_sprite_flip_y:	dcb.b 1
