	include "cpu/6809/include/common.inc"
	include "cpu/6x09/include/handlers/values_edit.inc"

	global sprite_viewer
	global sprite_viewer_palette_setup

	section code

sprite_viewer:
		ldy	#d_screen_xys_list
		jsr	print_xy_string_list

		jsr	sprite_viewer_palette_setup

		ldd	#$8
		std	r_sprite_num

		ldd	#$100
		std	r_sprite_pos_x

		lda	#$60
		sta	r_sprite_pos_y

		clra
		sta	r_sprite_flip_y

		ldx	#d_ve_settings
		ldy	#d_ve_list

		jsr	values_edit_handler


		ldd	#$0
		std	SPRITE_RAM
		std	SPRITE_RAM + 2
		rts

; Per MAME (reformattd)
; * Byte | Bit(s)   | Use
; * -----+-76543210-+----------------
; *   0  | xxxxxxxx | sprite num
; *   1  | xxx----- | sprite num (high bits)
; *   1  | ---xxx-- | color palette
; *   1  | ------x- | y flip
; *   1  | -------x | x position (high bit)
; *   2  | xxxxxxxx | y position
; *   3  | xxxxxxxx | x position

value_changed_cb:

		ldd	r_sprite_num
		stb	SPRITE_RAM

		asla
		asla
		asla
		asla
		asla


		ldb	r_sprite_flip_y
		beq	.skip_sprite_flip_y
		ora	#$2

	.skip_sprite_flip_y:
		ora	r_sprite_pos_x
		sta	SPRITE_RAM + 1
		lda	r_sprite_pos_x + 1
		sta	SPRITE_RAM + 3
		lda	r_sprite_pos_y
		sta	SPRITE_RAM + 2
		rts

loop_input_cb:
		rts

sprite_viewer_palette_setup:
		CPU_INTS_ENABLE

		ldd	#d_palette_data
		std	r_vblank_copy_src
		ldd	#SPRITE_PALETTE
		std	r_vblank_copy_dst
		ldd	#SPRITE_PALETTE_SIZE
		std	r_vblank_copy_size

		jsr	wait_vblank_copy

		CPU_INTS_DISABLE
		rts

	section data

d_ve_settings:
	VE_SETTINGS value_changed_cb, loop_input_cb

d_ve_list:
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_EDGE, r_sprite_num, $3ff
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_sprite_pos_x, $1ff
	VE_ENTRY VE_TYPE_BYTE, VE_INPUT_RAW, r_sprite_pos_y, $ff
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_flip_y, $1
	VE_LIST_END

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "SPRITE NUM"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), "POS X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 4), "POS Y"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 5), "FLIP Y"
	XY_STRING_LIST_END

d_palette_data:
	dc.w	$0000, $4570, $6790, $78a0, $bcd0, $eee0, $8880, $6660
	dc.w	$a000, $7000, $a750, $eb80, $e960, $e700, $7650, $1110

	section bss

r_sprite_flip_y:	dcb.b 1
r_sprite_num:		dcb.w 1
r_sprite_pos_x:		dcb.w 1
r_sprite_pos_y:		dcb.b 1
