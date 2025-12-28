	include "cpu/konami2/include/common.inc"
	include "cpu/6x09/include/handlers/values_edit.inc"

	global k053246_zoom_debug

	section code

k053246_zoom_debug:
		jsr	palette_setup

		ldy	#TILE_RAM
		ldx	#TILE_RAM_SIZE
		lda	#$2c
	.loop_next_address:
		sta	,y+
		leax	-1, x
		bne	.loop_next_address

		ldy	#d_screen_xys_list
		jsr	print_xy_string_list

		lda	#$5
		sta	r_sprite_size

		ldd	#$40
		std	r_sprite_zoom_x
		std	r_sprite_zoom_y

		clr	r_sprite_aspect_ratio

		lda	#(CTRL_SPRITE_BANK | CTRL_SPRITE_RENDER)
		sta	REG_CONTROL

		ldd	#$8501
		std	SPRITE_RAM

		ldd	#$2440
		std	SPRITE_RAM + 2

		ldd	#$0100
		std	SPRITE_RAM + 4

		ldd	#$00c0
		std	SPRITE_RAM + 6

		ldd	#$0040
		std	SPRITE_RAM + 8

		ldd	#$0040
		std	SPRITE_RAM + 10

		lda	#CTRL_SPRITE_RENDER
		sta	REG_CONTROL

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
		lda	#(CTRL_SPRITE_BANK | CTRL_SPRITE_RENDER)
		sta	REG_CONTROL

		lda	SPRITE_RAM
		anda	#$b0

		ldb	r_sprite_aspect_ratio
		beq	.skip_sprite_aspect_ratio
		ora	#$40

	.skip_sprite_aspect_ratio:
		ora	r_sprite_size
		sta	SPRITE_RAM

		ldd	r_sprite_zoom_y
		std	SPRITE_RAM + 8

		ldd	r_sprite_zoom_x
		std	SPRITE_RAM + 10

		lda	#CTRL_SPRITE_RENDER
		sta	REG_CONTROL
		rts

loop_input_cb:
		rts

palette_setup:
		lda	#CTRL_PALETTE_BANK
		sta	REG_CONTROL

		ldx	#(PALETTE_SIZE / 2)
		ldy	#SPRITE_PALETTE
		ldd	#$1f

	.loop_next_byte:
		std	,y++
		leax	-1, x
		bne	.loop_next_byte

		clr	REG_CONTROL
		rts

	section data

d_ve_settings:
	VE_SETTINGS value_changed_cb, loop_input_cb

d_ve_list:
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_size, $f
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_aspect_ratio, $1
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_EDGE, r_sprite_zoom_x, $ffff
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_EDGE, r_sprite_zoom_y, $ffff
	VE_LIST_END

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "SIZE"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), "ASPECT RATIO"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 4), "ZOOM X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 5), "ZOOM Y"
	XY_STRING_LIST_END

	section bss

r_sprite_size:		dcb.b 1
r_sprite_aspect_ratio:	dcb.b 1
r_sprite_zoom_x:	dcb.w 1
r_sprite_zoom_y:	dcb.w 1
