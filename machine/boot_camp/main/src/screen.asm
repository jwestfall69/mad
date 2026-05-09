	include "cpu/6309/include/common.inc"

	global screen_init_dsub
	global screen_seek_xy_dsub

	section code

screen_init_dsub:
		ldx	#PALETTE_RAM
		ldw	#PALETTE_RAM_SIZE
		lda	#$00
		DSUB	memory_fill

		; bg1 tiles
		ldx	#K007121_G15_TILE_A
		ldw	#K007121_G15_TILE_A_SIZE
		lda	#$40
		DSUB	memory_fill

		ldx	#K007121_G15_TILE_A_ATTR
		ldw	#K007121_G15_TILE_A_ATTR_SIZE
		lda	#$00
		DSUB	memory_fill

		; fix tiles
		ldx	#K007121_G15_TILE_B
		ldw	#K007121_G15_TILE_B_SIZE
		lda	#$40
		DSUB	memory_fill

		ldx	#K007121_G15_TILE_B_ATTR
		ldw	#K007121_G15_TILE_B_ATTR_SIZE
		lda	#$00
		DSUB	memory_fill

		ldx	#K007121_G15_SPRITE
		ldw	#K007121_G15_SPRITE_SIZE
		lda	#$00
		DSUB	memory_fill

		lda	#$2c
		sta	REG_K007121_G15_C3

		lda	#REG_CTRL_K007121_G8
		sta	REG_CONTROL

		; bg2 tiles
		ldx	#K007121_G8_TILE_A
		ldw	#K007121_G8_TILE_A_SIZE
		lda	#$40
		DSUB	memory_fill

		ldx	#K007121_G8_TILE_A_ATTR
		ldw	#K007121_G8_TILE_A_ATTR_SIZE
		lda	#$00
		DSUB	memory_fill

		; not used
		ldx	#K007121_G8_TILE_B
		ldw	#K007121_G8_TILE_B_SIZE
		lda	#$40
		DSUB	memory_fill

		ldx	#K007121_G8_TILE_B_ATTR
		ldw	#K007121_G8_TILE_B_ATTR_SIZE
		lda	#$00
		DSUB	memory_fill

		ldx	#K007121_G8_SPRITE
		ldw	#K007121_G8_SPRITE_SIZE
		lda	#$00
		DSUB	memory_fill

		lda	#$2c
		sta	REG_K007121_G8_C3

		lda	#REG_CTRL_K007121_G15
		sta	REG_CONTROL

		; txt color
		ldd	#$ffff
		std	(K007121_G15_TILE_B_PALETTE + $2)

		SEEK_XY	3, 0
		ldy	#d_str_version
		DSUB	print_string

		SEEK_XY	0, 1
		lda	#$3c
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
		leax	a, x
		clra
		rold
		rold
		rold
		rold
		rold
		leax	d, x
		DSUB_RETURN
