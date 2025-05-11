	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/konami2/include/dsub.inc"
	include "cpu/konami2/include/macros.inc"
	include "cpu/konami2/include/xy_string.inc"
	include "cpu/konami2/include/handlers/sprite_k053247_viewer.inc"

	include "input.inc"
	include "machine.inc"
	include "mad.inc"

	global sprite_viewer

	section code

sprite_viewer:
		RSUB	screen_init
		jsr	sprite_palette_setup

		ldx	#r_sprite_struct

		; setup initial struct values
		ldd	#$1
		std	s_ks_sprite_num, x

		ldd	#$1ff
		std	s_ks_sprite_pos_x, x
		ldd	#$7f
		std	s_ks_sprite_pos_y, x

		lda	#$1
		sta	s_ks_sprite_width, x
		sta	s_ks_sprite_height, x

		lda	#$40
		sta	s_ks_sprite_zoom, x

		ldy	#draw_sprite_cb
		jsr	sprite_k053247_viewer_handler
		rts
; Per MAME
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
; *
; * shadow enables transparent shadows. Note that it applies to the last sprite pen ONLY.
; * The rest of the sprite remains normal.

draw_sprite_cb:
		lda	#$1
		sta	REG_CONTROL

		ldy	#r_sprite_struct

		lda	s_ks_sprite_height, y
		asla
		asla
		ora	s_ks_sprite_width, y
		ora	#$c0			; active sprite and maintain aspect ratio
		sta	SPRITE_RAM_START

		; For some reason with mad on hardware it won't draw the
		; sprite with a #$0 zcode, but works ok with >= $1.  The
		; original game code has a sprite with $0 zcode.  There
		; must be some min zcode value init some place on hardware.
		lda	#$01
		sta	SPRITE_RAM_START + 1

		ldd	s_ks_sprite_num, y
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
		std	SPRITE_RAM_START + 2

		ldd	s_ks_sprite_pos_y, y
		std	SPRITE_RAM_START + 4

		ldd	s_ks_sprite_pos_x, y
		std	SPRITE_RAM_START + 6

		lda	s_ks_sprite_zoom, y
		sta	SPRITE_RAM_START + 9

		lda	#$0
		sta	REG_CONTROL
		rts

; Palette Layout
;  xBBB BBGG GGGR RRRR
sprite_palette_setup:
		lda	#$1
		sta	REG_CONTROL

		ldx	#d_palette_data
		ldy	#SPRITE_PALETTE
		ldb	#PALETTE_SIZE

	.loop_next_color:
		lda	,x+
		sta	,y+
		decb
		bne	.loop_next_color

		lda	#$0
		sta	REG_CONTROL

		rts


	section data

d_palette_data:
	dc.w	$0000, $00f2, $25bc, $42bf, $5f5f, $7bdf, $2908, $45ad
	dc.w	$66b5, $000e, $0017, $001f, $05df, $084a, $08f8, $0000

	section bss

r_sprite_struct:	dcb.b s_ks_struct_size
