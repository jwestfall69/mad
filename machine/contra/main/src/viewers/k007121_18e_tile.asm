	include "cpu/6309/include/common.inc"

	global k007121_18e_tile_viewer

	section code

TILE_OFFSET_MASK	equ $3fff

k007121_18e_tile_viewer:
		RSUB	screen_init

		ldy	#K007121_18E_TILE_A_PALETTE
		jsr	tvc_init

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_title
		RSUB	print_string

		ldd	#TILE_OFFSET_MASK
		ldx	#seek_xy_cb
		ldy	#draw_tile_cb
		jsr	tile_8x8_viewer_handler
		rts

seek_xy_cb:
		RSUB	screen_seek_xy

		; adjust to be in 18e ram
		leax	$2000, x
		rts

; params:
;  d = tile (word)
;  00TT TTTT TTTT TTTT
;  T = tile num
;  x = already at location in tile ram
; TTTT T??? TTTT TTTT
;  T = tile num
draw_tile_cb:
		exg	b, a
		RSUB	print_byte

		lda	#$b6
		bitb	#$20
		beq	.skip_bit_5
		ora	#$1

	.skip_bit_5:
		sta	REG_K007121_18E_C3
		andb	#$1f
		lslb
		lslb
		lslb
		stb	-$400, x
		rts
	section data

d_str_title:	STRING "K007121 10E TILE VIEWER"
