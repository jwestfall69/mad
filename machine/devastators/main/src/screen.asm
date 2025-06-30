	include "cpu/6309/include/common.inc"

	global screen_init_dsub
	global screen_seek_xy_dsub

	section code

screen_init_dsub:
		ldx	#PALETTE_RAM
		ldw	#PALETTE_RAM_SIZE
		lda	#$00
		DSUB	memory_fill

		ldx	#TILE_ATTR_RAM
		ldw	#TILE_ATTR_RAM_SIZE
		lda	#$00
		DSUB	memory_fill

		; fill with spaces
		ldx	#TILE_RAM
		ldw	#TILE_RAM_SIZE
		lda	#$10
		DSUB	memory_fill

		ldx	#LAYER_A_SCROLL
		ldw	#LAYER_A_SCROLL_SIZE
		clra
		DSUB	memory_fill

		ldx	#LAYER_B_SCROLL
		ldw	#LAYER_B_SCROLL_SIZE
		clra
		DSUB	memory_fill

		ldx	#SPRITE_RAM
		ldw	#$400
		clra
		DSUB	memory_fill

		; txt color
		ldd	#$ffff
		std	FIX_TILE_PALETTE + $2

		SEEK_XY	1, 0
		ldy	#d_str_version
		DSUB	print_string

		SEEK_LN	1
		lda	#$2e
		ldb	#$1c
		DSUB	print_char_repeat
		DSUB_RETURN

; params:
;  a = x
;  b = y
screen_seek_xy_dsub:
		SEEK_XY 0, 0

		leax	b, x
		clrb
		rord
		rord
		negd
		leax	d, x
		DSUB_RETURN
