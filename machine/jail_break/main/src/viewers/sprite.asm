	include "cpu/6809/include/common.inc"
	include "cpu/6x09/include/handlers/values_edit.inc"

	global sprite_viewer

	section code

sprite_viewer:
		ldy	#d_screen_xys_list
		jsr	print_xy_string_list

		ldd	#$d5
		std	r_sprite_num

		ldd	#$90
		std	r_sprite_pos_x

		lda	#$70
		sta	r_sprite_pos_y

		clra
		sta	r_sprite_palette_num
		sta	r_sprite_flip_x
		sta	r_sprite_flip_y

		ldx	#d_ve_settings
		ldy	#d_ve_list

		jsr	values_edit_handler
		rts

; Per MAME (reformattd)
; * Byte | Bit(s)   | Use
; * -----+-76543210-+----------------
; *   0  | xxxxxxxx | sprite num
; *   1  | x------- | x position (high bit)
; *   1  | -x------ | sprite num (high bit)
; *   1  | --x----- | flip y
; *   1  | ---x---- | flip x
; *   1  | ----xxxx | color palette
; *   2  | xxxxxxxx | y position
; *   3  | xxxxxxxx | x position

value_changed_cb:

		lda	r_sprite_num + 1
		sta	SPRITE_RAM

		clrb

		lda	r_sprite_num
		beq	.skip_sprite_num_high_bit
		orb	#$80

	.skip_sprite_num_high_bit:
		lda	r_sprite_pos_x
		beq	.skip_sprite_pos_x_high_bit
		orb	#$40

	.skip_sprite_pos_x_high_bit:
		lda	r_sprite_flip_x
		beq	.skip_sprite_flip_x
		orb	#$10

	.skip_sprite_flip_x:
		lda	r_sprite_flip_y
		beq	.skip_sprite_flip_y
		orb	#$20

	.skip_sprite_flip_y:
		orb	r_sprite_palette_num
		stb	SPRITE_RAM + 1

		lda	r_sprite_pos_x + 1
		sta	SPRITE_RAM + 3

		lda	r_sprite_pos_y
		sta	SPRITE_RAM + 2
		rts


loop_input_cb:
		rts

	section data

d_ve_settings:
	VE_SETTINGS value_changed_cb, loop_input_cb

d_ve_list:
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_EDGE, r_sprite_num, $3ff
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_palette_num, $f
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_sprite_pos_x, $1ff
	VE_ENTRY VE_TYPE_BYTE, VE_INPUT_RAW, r_sprite_pos_y, $ff
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_flip_x, $1
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_flip_y, $1
	VE_LIST_END

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "SPRITE NUM"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), "PALETTE NUM"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 4), "POS X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 5), "POS Y"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 6), "FLIP X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 7), "FLIP Y"
	XY_STRING_LIST_END

	section bss

r_sprite_num:		dcb.w 1
r_sprite_palette_num:	dcb.b 1
r_sprite_pos_x:		dcb.w 1
r_sprite_pos_y:		dcb.b 1
r_sprite_flip_x:	dcb.b 1
r_sprite_flip_y:	dcb.b 1
