	include "cpu/6309/include/common.inc"

	global screen_init_dsub
	global screen_seek_xy_dsub

	section code

screen_init_dsub:
		ldx	#PALETTE_RAM
		ldw	#PALETTE_RAM_SIZE
		lda	#$00
		DSUB	memory_fill

		; header / top 5 lines
		ldx	#K007121_10E_TILE_B
		ldw	#K007121_10E_TILE_B_SIZE
		lda	#$10
		DSUB	memory_fill

		ldx	#K007121_10E_TILE_B_ATTR
		ldw	#K007121_10E_TILE_B_ATTR_SIZE
		lda	#$00
		DSUB	memory_fill

		; fg tiles
		ldx	#K007121_10E_TILE_A
		ldw	#K007121_10E_TILE_A_SIZE
		lda	#$10
		DSUB	memory_fill

		ldx	#K007121_10E_TILE_A_ATTR
		ldw	#K007121_10E_TILE_A_ATTR_SIZE
		lda	#$00
		DSUB	memory_fill

		; bg tiles
		ldx	#K007121_18E_TILE_A
		ldw	#K007121_18E_TILE_A_SIZE
		lda	#$10
		DSUB	memory_fill

		ldx	#K007121_18E_TILE_A_ATTR
		ldw	#K007121_18E_TILE_A_ATTR_SIZE
		lda	#$00
		DSUB	memory_fill

		ldx	#K007121_10E_SPRITE
		ldw	#K007121_10E_SPRITE_SIZE
		lda	#$00
		DSUB	memory_fill

		ldx	#K007121_18E_SPRITE
		ldw	#K007121_18E_SPRITE_SIZE
		lda	#$00
		DSUB	memory_fill

		lda	#$b6
		sta	REG_K007121_10E_C3
		sta	REG_K007121_18E_C3

		; txt color
		ldd	#$ffff
		std	(K007121_10E_TILE_B_PALETTE + $1e)

		SEEK_XY	2, 0
		ldy	#d_str_version
		DSUB	print_string

		SEEK_XY	0, 1
		lda	#$0c
		ldb	#SCREEN_NUM_COLUMNS
		DSUB	print_char_repeat
		DSUB_RETURN

; params:
;  a = x
;  b = y
screen_seek_xy_dsub:

		cmpb	#$5
		bge	.in_tile1
		SEEK_XY 0, 0
		bra	.do_seek

	.in_tile1:
		SEEK_XY 0, 5
		subb	#$5

	.do_seek:
		leax	b, x
		clrb
		rord
		rord
		rord
		negd
		leax	d, x
		DSUB_RETURN
