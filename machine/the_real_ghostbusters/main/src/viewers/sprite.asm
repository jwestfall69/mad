	include "cpu/6309/include/common.inc"
	include "cpu/6x09/include/handlers/values_edit.inc"

	global sprite_viewer

	section code

sprite_viewer:
		ldy	#d_screen_xys_list
		jsr	print_xy_string_list

		ldd	#$105
		std	r_sprite_num

		lda	#$1
		sta	r_sprite_size

		ldd	#$90
		std	r_sprite_pos_x

		ldd	#$60
		std	r_sprite_pos_y

		clra
		sta	r_sprite_palette_num
		sta	r_sprite_flip_x
		sta	r_sprite_flip_y

		ldx	#d_ve_settings
		ldy	#d_ve_list

		jsr	values_edit_handler
		rts

; Extracted from mame's code in src/mame/dataeast/deckarn.cpp
; * Byte | Bit(s)   | Use
; * -----+-76543210-+----------------
; *   0  | x------- | sprite enabled
; *   0  | -???---- | ?
; *   0  | ----x--- | sprite size (0 = 16x16, 1 = 16x32)
; *   0  | -----??- | ?
; *   0  | -------x | y position (high bit)
; *   1  | xxxxxxxx | y position
; *   2  | ???????? | ?
; *   3  | ???----- | ?
; *   3  | ---x---- | need to match sprite size
; *   3  | ----?--- | ?
; *   3  | -----x-- | flip x
; *   3  | ------x- | flip y
; *   3  | -------x | sprite enabled again?
; *   4  | ???????- | ?
; *   4  | -------x | x position (high bit)
; *   5  | xxxxxxxx | x position
; *   6  | xxxx---- | color/palette
; *   6  | ----xxxx | sprite num (high bits)
; *   7  | xxxxxxxx | sprite num
value_changed_cb:
		lda	#$80		; sprite enable
		ldb	r_sprite_size
		beq	.skip_sprite_size
		ora	#$08

	.skip_sprite_size:
		ora	r_sprite_pos_y
		ldb	r_sprite_pos_y + 1
		std	SPRITE_RAM

		anda	#$08		; extract sprite size
		asla
		ora	#$01		; another enable?

		ldb	r_sprite_flip_x
		beq	.skip_sprite_flip_x
		ora	#$04

	.skip_sprite_flip_x:
		ldb	r_sprite_flip_y
		beq	.skip_sprite_flip_y
		ora	#$02

	.skip_sprite_flip_y:
		sta	SPRITE_RAM + 3

		ldd	r_sprite_pos_x
		std	SPRITE_RAM + 4

		lda	r_sprite_palette_num
		asla
		asla
		asla
		asla
		ora	r_sprite_num
		ldb	r_sprite_num + 1
		std	SPRITE_RAM + 6
		RSUB	sprite_trigger_copy
		rts

loop_input_cb:
		rts

	section data

d_ve_settings:
	VE_SETTINGS value_changed_cb, loop_input_cb

d_ve_list:
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_EDGE, r_sprite_num, $ffff
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_palette_num, $f
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_size, $1
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_sprite_pos_x, $1ff
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_sprite_pos_y, $1ff
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
r_sprite_pos_y:		dcb.w 1
r_sprite_flip_x:	dcb.b 1
r_sprite_flip_y:	dcb.b 1
