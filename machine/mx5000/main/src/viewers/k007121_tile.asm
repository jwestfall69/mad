	include "cpu/6309/include/common.inc"

	global k007121_tile_viewer

	section code

TILE_OFFSET_MASK	equ $3fff

k007121_tile_viewer:
		jsr	k007121_tile_viewer_palette_setup

		ldd	#TILE_OFFSET_MASK
		ldx	#seek_xy_cb
		ldy	#draw_tile_cb
		jsr	tile_8x8_viewer_handler
		rts

seek_xy_cb:
		RSUB	screen_seek_xy
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

		lda	#$10
		bitb	#$20

		; the high tile bit gets set in one of
		; the 007121's registers, which will cause
		; all tiles to change and will corrupt the
		; text on screen.
		beq	.skip_bit_5
		ora	#$1

	.skip_bit_5:
		sta	REG_K007121_C3

		clra
		bitb	#$1
		beq	.skip_bit_0
		ora	#$80

	.skip_bit_0:
		ora	#$1		; palette #
		sta	-$400, x

		lsrb
		andb	#$f
		stb	r_scratch
		lslb
		lslb
		lslb
		lslb
		orb	r_scratch
		stb	REG_K007121_C4
		rts

; Palette Layout
;  xBBB BBGG GGGR RRRR
; params:
;  y = start palette address
k007121_tile_viewer_palette_setup:
		ldy	#K007121_TILE_A_PALETTE + PALETTE_SIZE
		ldx	#d_palette_data
		ldb	#PALETTE_SIZE

	.loop_next_color:
		lda	,x+
		sta	,y+
		decb
		bne	.loop_next_color
		rts

	section data

d_palette_data:
	dc.w	$0000, $6d39, $3e34, $fe00, $5864, $8064, $e277, $d126
	dc.w	$e519, $8271, $0e78, $aa39, $f725, $0e5e, $9532, $ffff
