	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/xy_string.inc"
	include "cpu/6309/include/handlers/sprite_k007420_viewer.inc"

	include "input.inc"
	include "machine.inc"
	include "mad.inc"

	global sprite_viewer

	section code

SPRITE_NUM_MASK		equ $1ff

sprite_viewer:
		PSUB	screen_init

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_title
		PSUB	print_string

		jsr	sprite_palette_setup

		ldx	#r_sprite_struct

		; setup initial struct values
		ldd	#$b4
		std	s_se_num, x

		lda	#$4
		sta	s_se_size, x

		ldd	#$60
		std	s_se_pos_x, x
		lda	#$90
		sta	s_se_pos_y, x

		ldd	#$80
		std	s_se_zoom, x

		ldd	#SPRITE_NUM_MASK
		ldy	#draw_sprite_cb
		jsr	sprite_k007420_viewer_handler

		clr	REG_CONTROL
		rts
; Per MAME
; * Sprite Format
; * ------------------
; *
; * Byte | Bit(s)   | Use
; * -----+-76543210-+----------------
; *   0  | xxxxxxxx | y position
; *   1  | xxxxxxxx | sprite code (low 8 bits)
; *   2  | xxxxxxxx | depends on external conections. Usually banking
; *   3  | xxxxxxxx | x position (low 8 bits)
; *   4  | x------- | x position (high bit)
; *   4  | -xxx---- | sprite size 000=16x16 001=8x16 010=16x8 011=8x8 100=32x32
; *   4  | ----x--- | flip y
; *   4  | -----x-- | flip x
; *   4  | ------xx | zoom (bits 8 & 9)
; *   5  | xxxxxxxx | zoom (low 8 bits)  0x080 = normal, < 0x80 enlarge, > 0x80 reduce
; *   6  | xxxxxxxx | unused
; *   7  | xxxxxxxx | unused

draw_sprite_cb:
		ldy	#r_sprite_struct

		lda	s_se_pos_y, y
		sta	SPRITE_RAM

		; sprite num is limited to $1ff. Lower byte goes to
		; sprite ram.  Bit 8 picks bank 0/1 via bit 7 of
		; REG_CONTROL
		ldd	s_se_num, y
		stb	SPRITE_RAM + 1

		asra
		rora
		sta	REG_CONTROL

		ldd	s_se_pos_x, y
		stb	SPRITE_RAM + 3
		sta	SPRITE_RAM + 4

		ldd	s_se_zoom, y
		stb	SPRITE_RAM + 5
		ora	SPRITE_RAM + 4
		sta	SPRITE_RAM + 4

		lda	s_se_size, y
		asla
		asla
		asla
		asla
		ora	SPRITE_RAM + 4
		sta	SPRITE_RAM + 4

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
	dc.w	$0000, $0400, $429c, $31f9, $00f0, $4621, $001f, $77bd
	dc.w	$03ff, $3800, $7500, $6810, $0340, $01e0, $001f, $0010

d_str_title:	STRING "SPRITE VIEWER"

	section bss

r_sprite_struct:	dcb.b s_se_struct_size
