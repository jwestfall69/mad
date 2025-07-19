	include "cpu/konami2/include/common.inc"
	include "cpu/6x09/include/handlers/values_edit.inc"

	global sprite_viewer
	global sprite_viewer_palette_setup

	section code

sprite_viewer:
		jsr	sprite_viewer_palette_setup

		ldy	#d_screen_xys_list
		jsr	print_xy_string_list

		ldd	#$4
		std	r_sprite_num

		ldd	#$d0
		std	r_sprite_pos_x

		ldd	#$80
		std	r_sprite_pos_y

		lda	#$3
		sta	r_sprite_size

		clra
		sta	r_sprite_zoom_x
		sta	r_sprite_zoom_y
		sta	r_sprite_flip_x
		sta	r_sprite_flip_y

		ldx	#d_ve_settings
		ldy	#d_ve_list

		jsr	values_edit_handler
		rts

; Per MAME (k051960)
; * Sprite Format
; * ------------------
; *
; * Byte | Bit(s)   | Use
; * -----+-76543210-+----------------
; *   0  | x------- | active (show this sprite)
; *   0  | -xxxxxxx | priority order
; *   1  | xxx----- | sprite size (see below)
; *   1  | ---xxxxx | sprite number (high 5 bits)
; *   2  | xxxxxxxx | sprite number (low 8 bits)
; *   3  | xxxxxxxx | "color", but depends on external connections (see below)
; *   4  | xxxxxx-- | zoom y (0 = normal, >0 = shrink)
; *   4  | ------x- | flip y
; *   4  | -------x | y position (high bit)
; *   5  | xxxxxxxx | y position (low 8 bits)
; *   6  | xxxxxx-- | zoom x (0 = normal, >0 = shrink)
; *   6  | ------x- | flip x
; *   6  | -------x | x position (high bit)
; *   7  | xxxxxxxx | x position (low 8 bits)
value_changed_cb:
		lda	#$ff
		sta	SPRITE_RAM

		lda	r_sprite_size
		asla
		asla
		asla
		asla
		asla
		ora	r_sprite_num
		ldb	r_sprite_num + 1
		std	SPRITE_RAM + 1

		clr	SPRITE_RAM + 3

		lda	r_sprite_zoom_y
		asla
		asla
		ldb	r_sprite_flip_y
		beq	.skip_sprite_flip_y
		ora	#$02

	.skip_sprite_flip_y:
		ora	r_sprite_pos_y
		ldb	r_sprite_pos_y + 1
		std	SPRITE_RAM + 4

		lda	r_sprite_zoom_x
		asla
		asla
		ldb	r_sprite_flip_x
		beq	.skip_sprite_flip_x
		ora	#$02

	.skip_sprite_flip_x:
		ora	r_sprite_pos_x
		ldb	r_sprite_pos_x + 1
		std	SPRITE_RAM + 6
		rts

loop_input_cb:
		rts

sprite_viewer_palette_setup:
		setln	#(SETLN_WATCHDOG_POLL|SETLN_SELECT_RAM_PALETTE)

		ldx	#d_palette_data
		ldy	#SPRITE_PALETTE
		ldb	#PALETTE_SIZE

	.loop_next_byte:
		lda	,x+
		sta	,y+
		decb
		bne	.loop_next_byte

		setln	#(SETLN_WATCHDOG_POLL|SETLN_SELECT_RAM_WORK)
		rts

	section data

d_ve_settings:
	VE_SETTINGS value_changed_cb, loop_input_cb

d_ve_list:
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_EDGE, r_sprite_num, $1fff
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_size, $7
	VE_ENTRY VE_TYPE_BYTE, VE_INPUT_EDGE, r_sprite_zoom_x, $3f
	VE_ENTRY VE_TYPE_BYTE, VE_INPUT_EDGE, r_sprite_zoom_y, $3f
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_sprite_pos_x, $1ff
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_sprite_pos_y, $1ff
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_flip_x, $1
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_flip_y, $1
	VE_LIST_END

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "SPRITE NUM"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), "SIZE"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 4), "ZOOM X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 5), "ZOOM Y"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 6), "POS X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 7), "POS Y"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 8), "FLIP X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 9), "FLIP Y"
	XY_STRING_LIST_END

d_palette_data:
	dc.w	$0000, $7fff, $5b9f, $3edf, $325a, $21d6, $4bff, $031f
	dc.w	$01f5, $6738, $5294, $39ce, $536f, $7d80, $4400, $2000

	section bss

r_sprite_num:		dcb.w 1
r_sprite_size:		dcb.b 1
r_sprite_zoom_x:	dcb.b 1
r_sprite_zoom_y:	dcb.b 1
r_sprite_pos_x:		dcb.w 1
r_sprite_pos_y:		dcb.w 1
r_sprite_flip_x:	dcb.b 1
r_sprite_flip_y:	dcb.b 1
