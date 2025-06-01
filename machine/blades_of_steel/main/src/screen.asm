	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"

	include "machine.inc"

	global screen_init_psub
	global screen_seek_xy_psub

	section code

screen_init_psub:
		ldx	#LAYER_A_TILE_ATTR
		ldw	#LAYER_A_TILE_ATTR_SIZE
		lda	#$0f
		PSUB	memory_fill

		ldx	#LAYER_B_TILE_ATTR
		ldw	#LAYER_B_TILE_ATTR_SIZE
		lda	#$0f
		PSUB	memory_fill

		ldx	#LAYER_A_TILE
		ldw	#LAYER_A_TILE_SIZE
		lda	#$10		; space
		PSUB	memory_fill

		ldx	#LAYER_B_TILE
		ldw	#LAYER_B_TILE_SIZE
		lda	#$10		; space
		PSUB	memory_fill

		ldx	#SPRITE_RAM
		ldw	#SPRITE_RAM_SIZE
		lda	#$0
		PSUB	memory_fill

		ldx	#SCROLL_RAM
		ldw	#SCROLL_RAM_SIZE
		lda	#$0
		PSUB	memory_fill

		ldx	#PALETTE_RAM
		ldw	#PALETTE_RAM_SIZE
		lda	#$00
		PSUB	memory_fill

		; txt color
		ldd	#$ffff
		std	LAYER_A_TILE_PALETTE + $c

		SEEK_XY	1, 0
		ldy	#d_str_version
		PSUB	print_string

		SEEK_LN	1
		lda	#$2e
		ldb	#$20
		PSUB	print_char_repeat
		PSUB_RETURN

; params:
;  a = x
;  b = y
screen_seek_xy_psub:

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
		PSUB_RETURN
