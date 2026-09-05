	include "cpu/6809/include/common.inc"
	include "cpu/6x09/include/handlers/values_edit.inc"

	global k005885_sprite_viewer

	section code

k005885_sprite_viewer:
		ldy	#d_screen_xys_list
		jsr	print_xy_string_list

		ldd	#$127
		std	r_sprite_num

		ldd	#$70
		std	r_sprite_pos_x

		lda	#$70
		sta	r_sprite_pos_y

		clra
		sta	r_sprite_palette_num
		sta	r_sprite_size
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
; *   1  | xxxx---- | color palette
; *   1  | ------xx | sprite num (high bits)
; *   2  | xxxxxxxx | y position
; *   3  | xxxxxxxx | x position
; *   4  | -x------ | flip y
; *   4  | --x----- | flip x
; *   4  | ---xxx-- | sprite size
; *   4  | -------x | x position (high bit)

value_changed_cb:

		ldd	r_sprite_num
		stb	K005885_SPRITE
		sta	r_scratch
		ldb	r_sprite_palette_num
		lslb
		lslb
		lslb
		lslb
		orb	r_scratch
		stb	K005885_SPRITE + 1

		lda	r_sprite_pos_y
		sta	K005885_SPRITE + 2

		ldd	r_sprite_pos_x
		stb	K005885_SPRITE + 3

		ldb	r_sprite_size
		lslb
		lslb
		stb	r_scratch
		ora	r_scratch

		ldb	r_sprite_flip_x
		beq	.skip_sprite_flip_x
		ora	#$20

	.skip_sprite_flip_x:
		ldb	r_sprite_flip_y
		beq	.skip_sprite_flip_y
		ora	#$40

	.skip_sprite_flip_y:
		sta	K005885_SPRITE + 4


loop_input_cb:
		rts

	section data

d_ve_settings:
	VE_SETTINGS value_changed_cb, loop_input_cb

d_ve_list:
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_EDGE, r_sprite_num, $3ff
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_palette_num, $f
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_size, $7
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_sprite_pos_x, $1ff
	VE_ENTRY VE_TYPE_BYTE, VE_INPUT_RAW, r_sprite_pos_y, $ff
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_flip_x, $1
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_flip_y, $1
	VE_LIST_END

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "SPRITE NUM"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), "PALETTE NUM"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 4), "SIZE"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 5), "POS X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 6), "POS Y"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 7), "FLIP X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 8), "FLIP Y"
	XY_STRING_LIST_END

	section bss

r_sprite_num:		dcb.w 1
r_sprite_palette_num:	dcb.b 1
r_sprite_size:		dcb.b 1
r_sprite_pos_x:		dcb.w 1
r_sprite_pos_y:		dcb.b 1
r_sprite_flip_x:	dcb.b 1
r_sprite_flip_y:	dcb.b 1
