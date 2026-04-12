	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/values_edit.inc"

	global bg_tile_viewer

	section code

bg_tile_viewer:
		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list

		lea	d_palette_data, a0
		lea	BG_TILE_PALETTE, a1
		moveq	#(BG_TILE_PALETTE_SIZE / 2), d0
		jsr	memory_copy

		; f1dream only seems to have bank 0 but leaving the code
		; in the event I get a tigeroad board, which I assume
		; has a bank 1
		;move.w	#$0, r_bank
		move.w	#$0, r_bg_scroll_x
		move.w	#$0, r_bg_scroll_y
		move.w	#$0, REG_BG_SCROLL_X
		move.w	#$0, REG_BG_SCROLL_Y

		lea	d_ve_settings, a0
		lea	d_ve_list, a1

		jsr	values_edit_handler

		move.w	#$0, r_bg_scroll_x
		move.w	#$0, r_bg_scroll_y
		move.w	#$0, REG_BG_SCROLL_X
		move.w	#$0, REG_BG_SCROLL_Y
		;move.w	#$0, REG_CONTROL
		rts

value_changed_cb:

	;	tst.b	r_bank
	;	beq	.set_bank_zero
	;	move.b	#$4, REG_CONTROL
	;	bra	.scroll_update

	;.set_bank_zero:
	;	move.b	#$0, REG_CONTROL


	.scroll_update:
		move.w	r_bg_scroll_x, d0
		move.w	d0, REG_BG_SCROLL_X

		move.w	r_bg_scroll_y, d0
		move.w	d0, REG_BG_SCROLL_Y
		rts

loop_input_cb:
		rts

	section data
	align 1

d_palette_data:
	dc.w	$0000, $0060, $0080, $04a0, $06c0, $0754, $0975, $0a86
	dc.w	$0b97, $0db8, $0ddd, $0bbb, $0999, $0998, $0777, $0666

d_ve_settings:
	VE_SETTINGS value_changed_cb, loop_input_cb

d_ve_list:
	;VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_bank, $1
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_bg_scroll_x, $fff
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_bg_scroll_y, $fff
	VE_LIST_END

d_screen_xys_list:
;	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "BANK"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "SCROLL X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), "SCROLL Y"
	XY_STRING_LIST_END

	section bss
	align 1

r_bg_scroll_x:		dcb.w 1
r_bg_scroll_y:		dcb.w 1
;r_bank:			dcb.b 1
