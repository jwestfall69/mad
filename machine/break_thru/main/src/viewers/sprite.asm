	include "cpu/6809/include/common.inc"
	include "cpu/6x09/include/handlers/values_edit.inc"

	global sprite_viewer

	section code

sprite_viewer:
		ldy	#d_screen_xys_list
		jsr	print_xy_string_list

		ldd	#$2
		std	r_sprite_num

		lda	#$90
		sta	r_sprite_pos_x

		lda	#$70
		sta	r_sprite_pos_y

		clra
		sta	r_sprite_palette_num
		sta	r_sprite_size

		ldx	#d_ve_settings
		ldy	#d_ve_list

		jsr	values_edit_handler
		rts

; Per MAME (reformattd)
; * Byte | Bit(s)   | Use
; * -----+-76543210-+----------------
; *   0  | xxx----- | color palette
; *   0  | ---x---- | sprite size
; *   0  | ----x--- | priority
; *   0  | -----xx- | bank
; *   0  | -------x | enable
; *   1  | xxxxxxxx | sprite num
; *   2  | xxxxxxxx | y position
; *   3  | xxxxxxxx | x position

value_changed_cb:

		lda	r_sprite_num
		asla			; bank
		tst	r_sprite_size
		beq	.sprite_size_zero
		ora	#$10
	.sprite_size_zero:

		ldb	r_sprite_palette_num
		lslb
		lslb
		lslb
		lslb
		lslb
		stb	r_scratch
		ora	r_scratch

		ora	#$9		; priority/enable
		sta	SPRITE_RAM

		lda	r_sprite_num + 1
		sta	SPRITE_RAM + 1

		lda	r_sprite_pos_y
		sta	SPRITE_RAM + 2
		lda	r_sprite_pos_x
		sta	SPRITE_RAM + 3
		rts

loop_input_cb:
		rts

	section data

d_ve_settings:
	VE_SETTINGS value_changed_cb, loop_input_cb

d_ve_list:
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_EDGE, r_sprite_num, $3ff
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_palette_num, $7
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_size, $1
	VE_ENTRY VE_TYPE_BYTE, VE_INPUT_RAW, r_sprite_pos_x, $ff
	VE_ENTRY VE_TYPE_BYTE, VE_INPUT_RAW, r_sprite_pos_y, $ff
	VE_LIST_END

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "SPRITE NUM"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), "PALETTE NUM"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 4), "SIZE"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 5), "POS X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 6), "POS Y"
	XY_STRING_LIST_END

	section bss

r_sprite_num:		dcb.w 1
r_sprite_palette_num:	dcb.b 1
r_sprite_size:		dcb.b 1
r_sprite_pos_x:		dcb.b 1
r_sprite_pos_y:		dcb.b 1
