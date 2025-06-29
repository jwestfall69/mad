	include "cpu/6x09/include/macros.inc"

	include "cpu/6309/include/dsub.inc"

	include "machine.inc"

	global screen_init_dsub
	global screen_seek_xy_dsub

	section code

screen_init_dsub:
		ldx	#LAYER_A_TILE_ATTR
		ldw	#LAYER_A_TILE_ATTR_SIZE
		lda	#$0f
		DSUB	memory_fill

		ldx	#LAYER_B_TILE_ATTR
		ldw	#LAYER_B_TILE_ATTR_SIZE
		lda	#$0f
		DSUB	memory_fill

		ldx	#LAYER_A_TILE
		ldw	#LAYER_A_TILE_SIZE
		lda	#$10		; space
		DSUB	memory_fill

		ldx	#LAYER_B_TILE
		ldw	#LAYER_B_TILE_SIZE
		lda	#$10		; space
		DSUB	memory_fill

		ldx	#SPRITE_RAM
		ldw	#SPRITE_RAM_SIZE
		lda	#$0
		DSUB	memory_fill

		ldx	#SCROLL_RAM
		ldw	#SCROLL_RAM_SIZE
		lda	#$0
		DSUB	memory_fill

		ldx	#PALETTE_RAM
		ldw	#PALETTE_RAM_SIZE
		lda	#$00
		DSUB	memory_fill

		; txt color
		ldd	#$ffff
		std	LAYER_A_TILE_PALETTE + $c

		SEEK_XY	1, 0
		ldy	#d_str_version
		DSUB	print_string

		SEEK_LN	1
		lda	#$2e
		ldb	#$20
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
