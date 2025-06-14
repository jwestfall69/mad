	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/xy_string.inc"
	include "cpu/6309/include/handlers/sprite_k051960_viewer.inc"

	include "input.inc"
	include "machine.inc"
	include "mad.inc"

	global sprite_viewer

	section code

SPRITE_NUM_MASK		equ $1fff

sprite_viewer:
		PSUB	screen_init

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_title
		PSUB	print_string

		jsr	sprite_palette_setup

		ldx	#r_sprite_struct

		; setup initial struct values
		ldd	#$8
		std	s_se_num, x

		ldd	#$f0
		std	s_se_pos_x, x
		ldd	#$90
		std	s_se_pos_y, x

		lda	#$3
		sta	s_se_size, x

		lda	#$0
		sta	s_se_zoom_x, x
		lda	#$0
		sta	s_se_zoom_y, x

		ldd	#SPRITE_NUM_MASK
		ldy	#draw_sprite_cb
		jsr	sprite_k051960_viewer_handler
		rts
; Per MAME
; * Sprite Format
; * ------------------
; *
; * Byte | Bit(s)   | Use
; * -----+-76543210-+----------------
; *   0  | x------- | active (show this sprite)
; *   0  | -xxxxxxx | priority order
; *   1  | xxx----- | sprite size (see below)
; *   1  | ---xxxxx | sprite code (high 5 bits)
; *   2  | xxxxxxxx | sprite code (low 8 bits)
; *   3  | xxxxxxxx | "color", but depends on external connections (see below)
; *   4  | xxxxxx-- | zoom y (0 = normal, >0 = shrink)
; *   4  | ------x- | flip y
; *   4  | -------x | y position (high bit)
; *   5  | xxxxxxxx | y position (low 8 bits)
; *   6  | xxxxxx-- | zoom x (0 = normal, >0 = shrink)
; *   6  | ------x- | flip x
; *   6  | -------x | x position (high bit)
; *   7  | xxxxxxxx | x position (low 8 bits)
; *
; * Example of "color" field for Punk Shot:
; *   3  | x------- | shadow
; *   3  | -xx----- | priority
; *   3  | ---x---- | use second gfx ROM bank
; *   3  | ----xxxx | color code
; *
; * shadow enables transparent shadows. Note that it applies to pen 0x0f ONLY.
; * The rest of the sprite remains normal.
; * Note that Aliens also uses the shadow bit to select the second sprite bank.

draw_sprite_cb:
		ldy	#r_sprite_struct

		lda	#$cf
		sta	SPRITE_RAM

		lda	s_se_size, y
		asla
		asla
		asla
		asla
		asla
		ora	s_se_num, y
		sta	SPRITE_RAM + 1
		lda	s_se_num + 1, y
		sta	SPRITE_RAM + 2

		clr	SPRITE_RAM + 3

		lda	s_se_zoom_y, y
		asla
		asla
		ora	s_se_pos_y, y
		ldb	s_se_pos_y + 1, y
		std	SPRITE_RAM + 4

		lda	s_se_zoom_x, y
		asla
		asla
		ora	s_se_pos_x, y
		ldb	s_se_pos_x + 1, y

		std	SPRITE_RAM + 6
		rts

; Palette Layout
;  xBBB BBGG GGGR RRRR
sprite_palette_setup:
		ldx	#d_palette_data
		ldy	#SPRITE_PALETTE
		ldb	#PALETTE_SIZE

	.loop_next_color:
		lda	,x+
		sta	,y+
		decb
		bne	.loop_next_color
		rts


	section data

d_palette_data:
	dc.w	$0000, $1150, $7d6a, $76f3, $1f1c, $5fdf, $2a15, $3a58
	dc.w	$32df, $5afe, $4659, $53bf, $42d7, $3def, $0421, $7bde

d_str_title:	STRING "SPRITE VIEWER"

	section bss

r_sprite_struct:	dcb.b s_se_struct_size
