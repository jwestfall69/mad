	include "cpu/konami2/include/common.inc"
	include "cpu/6x09/include/handlers/values_edit.inc"

	global sprite_viewer
	global sprite_viewer_palette_setup

	section code

sprite_viewer:
		jsr	sprite_viewer_palette_setup

		ldy	#d_screen_xys_list
		jsr	print_xy_string_list

		ldd	#$2
		std	r_sprite_num

		ldd	#$140
		std	r_sprite_pos_x

		ldd	#$a0
		std	r_sprite_pos_y

		lda	#$5
		sta	r_sprite_size

		ldd	#$40
		std	r_sprite_zoom_x
		std	r_sprite_zoom_y

		clra
		sta	r_sprite_aspect_ratio
		sta	r_sprite_flip_x
		sta	r_sprite_flip_y
		sta	r_sprite_shadow
		sta	r_sprite_effect

		ldx	#d_ve_settings
		ldy	#d_ve_list

		jsr	values_edit_handler
		rts

; Per MAME (k053247)
; * Sprite Format
; * ------------------
; *
; * Word | Bit(s)           | Use
; * -----+-fedcba98 76543210-+----------------
; *   0  | x------- -------- | active (show this sprite)
; *   0  | -x------ -------- | maintain aspect ratio (when set, zoom y acts on both axis)
; *   0  | --x----- -------- | flip y
; *   0  | ---x---- -------- | flip x
; *   0  | ----xxxx -------- | sprite size (2 bits height, 2 bit width)
; *   0  | -------- xxxxxxxx | zcode
; *   1  | xxxxxxxx xxxxxxxx | sprite code (lower 6 bits seem to be doing fine x/y adjustments?)
; *   2  | ------xx xxxxxxxx | y position
; *   3  | ------xx xxxxxxxx | x position
; *   4  | xxxxxxxx xxxxxxxx | zoom y (0x40 = normal, <0x40 = enlarge, >0x40 = reduce)
; *   5  | xxxxxxxx xxxxxxxx | zoom x (0x40 = normal, <0x40 = enlarge, >0x40 = reduce, ignored if maintain aspect ratio = 1)
; *   6  | x------- -------- | mirror y (top half is drawn as mirror image of the bottom)
; *   6  | -x------ -------- | mirror x (right half is drawn as mirror image of the left)
; *   6  | --xx---- -------- | reserved (sprites with these two bits set don't seem to be graphics data at all)
; *   6  | ----xx-- -------- | shadow code: 0=off, 0x400=preset1, 0x800=preset2, 0xc00=preset3
; *   6  | ------xx -------- | effect code: flicker, upper palette, full shadow...etc. (game dependent)
; *   6  | -------- xxxxxxxx | "color", but depends on external connections (implies priority)
; *   7  | xxxxxxxx xxxxxxxx | game dependent
value_changed_cb:
		lda	#$80		; active sprite
		ldb	r_sprite_aspect_ratio
		beq	.skip_sprite_aspect_ratio
		ora	#$40

	.skip_sprite_aspect_ratio:
		ldb	r_sprite_flip_y
		beq	.skip_sprite_flip_y
		ora	#$20

	.skip_sprite_flip_y:
		ldb	r_sprite_flip_x
		beq	.skip_sprite_flip_x
		ora	#$10

	.skip_sprite_flip_x:
		ora	r_sprite_size
		sta	SPRITE_RAM

		; For some reason with mad on hardware it won't draw the
		; sprite with a <= #$1 zcode, but works ok with >= $2.  The
		; original game code has a sprite with $0 zcode.  There
		; must be some min zcode value init some place on hardware.
		lda	#$02
		sta	SPRITE_RAM + 1

		ldd	r_sprite_num
		aslb
		rola
		aslb
		rola
		aslb
		rola
		aslb
		rola
		aslb
		rola
		aslb
		rola
		std	SPRITE_RAM + 2

		ldd	r_sprite_pos_y
		std	SPRITE_RAM + 4
		ldd	r_sprite_pos_x
		std	SPRITE_RAM + 6
		ldd	r_sprite_zoom_y
		std	SPRITE_RAM + 8
		ldd	r_sprite_zoom_x
		std	SPRITE_RAM + 10


		lda	r_sprite_shadow
		asla
		asla
		ora	r_sprite_effect
		sta	SPRITE_RAM + 12

		clr	REG_SPRITE_REFRESH
		rts

loop_input_cb:
		rts

sprite_viewer_palette_setup:
		ldx	#d_palette_data
		ldy	#SPRITE_PALETTE
		ldb	#PALETTE_SIZE

	.loop_next_byte:
		lda	,x+
		sta	,y+
		decb
		bne	.loop_next_byte
		rts

	section data

d_ve_settings:
	VE_SETTINGS value_changed_cb, loop_input_cb

; Not including mirror x/y options as they don't do anything on hardware.
d_ve_list:
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_EDGE, r_sprite_num, $ffff
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_size, $f
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_aspect_ratio, $1
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_EDGE, r_sprite_zoom_x, $ffff
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_EDGE, r_sprite_zoom_y, $ffff
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_sprite_pos_x, $3ff
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_sprite_pos_y, $3ff
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_flip_x, $1
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_flip_y, $1
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_shadow, $3
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_effect, $3
	VE_LIST_END

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "SPRITE NUM"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), "SIZE"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 4), "ASPECT RATIO"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 5), "ZOOM X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 6), "ZOOM Y"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 7), "POS X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 8), "POS Y"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 9), "FLIP X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 10), "FLIP Y"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 11), "SHADOW"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 12), "EFFECT"
	XY_STRING_LIST_END

d_palette_data:
	dc.w	$0000, $3a58, $29f4, $3e9f, $29d9, $4a51, $1a5a, $11f6
	dc.w	$25b3, $216e, $2d68, $0000, $2128, $25b1, $ed8d, $3dcf

	section bss

r_sprite_num:		dcb.w 1
r_sprite_size:		dcb.b 1
r_sprite_aspect_ratio:	dcb.b 1
r_sprite_zoom_x:	dcb.w 1
r_sprite_zoom_y:	dcb.w 1
r_sprite_pos_x:		dcb.w 1
r_sprite_pos_y:		dcb.w 1
r_sprite_flip_x:	dcb.b 1
r_sprite_flip_y:	dcb.b 1
r_sprite_shadow:	dcb.b 1
r_sprite_effect:	dcb.b 1
