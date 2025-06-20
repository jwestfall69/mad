	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/xy_string.inc"
	include "cpu/6309/include/handlers/sprite_k007121_viewer.inc"

	include "input.inc"
	include "machine.inc"
	include "mad.inc"

	global k007121_10e_sprite_viewer_palette_setup
	global k007121_10e_sprite_viewer

	section code

SPRITE_NUM_MASK		equ $3fff

k007121_10e_sprite_viewer:
		jsr	k007121_10e_sprite_palette_setup

		ldx	#r_sprite_struct

		; setup initial struct values
		ldd	#$2070
		std	s_se_num, x

		lda	#$4
		sta	s_se_size, x

		ldd	#$30
		std	s_se_pos_x, x
		lda	#$80
		sta	s_se_pos_y, x

		ldd	#SPRITE_NUM_MASK
		ldy	#draw_sprite_cb
		jsr	sprite_k007121_viewer_handler

		rts
; Per MAME
; * Sprite Format
; * ------------------
; *
; * There are 0x40 sprites, each one using 5 bytes. However the number of
; * sprites can be increased to 0x80 with a control register (Combat School
; * sets it on and off during the game).
; *
; * Byte | Bit(s)   | Use
; * -----+-76543210-+----------------
; *   0  | xxxxxxxx | sprite code
; *   1  | xxxx---- | color
; *   1  | ----xx-- | sprite code low 2 bits for 16x8/8x8 sprites
; *   1  | ------xx | sprite code bank bits 1/0
; *   2  | xxxxxxxx | y position
; *   3  | xxxxxxxx | x position (low 8 bits)
; *   4  | xx------ | sprite code bank bits 3/2
; *   4  | --x----- | flip y
; *   4  | ---x---- | flip x
; *   4  | ----xxx- | sprite size 000=16x16 001=16x8 010=8x16 011=8x8 100=32x32
; *   4  | -------x | x position (high bit)

draw_sprite_cb:
		ldy	#r_sprite_struct

		ldd	s_se_num, y
		stb	K007121_10E_SPRITE

		tfr	a, b
		andb	#$f
		stb	K007121_10E_SPRITE + 1

		anda	#$f0
		asla
		asla

		ldb	s_se_size, y
		aslb
		orr	b, a

		ldw	s_se_pos_x, y
		orr	e, a
		sta	K007121_10E_SPRITE + 4
		stf	K007121_10E_SPRITE + 3
		lda	s_se_pos_y, y
		sta	K007121_10E_SPRITE + 2
		rts

; Palette Layout
;  xBBB BBGG GGGR RRRR
k007121_10e_sprite_palette_setup:
		ldx	#d_palette_data
		ldy	#K007121_10E_SPRITE_PALETTE
		ldb	#PALETTE_SIZE

	.loop_next_color:
		lda	,x+
		sta	,y+
		decb
		bne	.loop_next_color
		rts


	section data

d_palette_data:
	dc.w	$0000, $6f19, $b315, $393a, $2c25, $341d, $7e2d, $ff02
	dc.w	$292A, $ab4d, $8a5a, $6939, $8b2d, $724a, $bc73, $0200

	section bss

r_sprite_struct:	dcb.b s_se_struct_size
