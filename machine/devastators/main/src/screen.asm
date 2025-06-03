	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"

	include "machine.inc"

	global screen_init_psub
	global screen_seek_xy_psub

	section code

screen_init_psub:
		ldx	#PALETTE_RAM
		ldw	#PALETTE_RAM_SIZE
		lda	#$00
		PSUB	memory_fill

		ldx	#TILE_ATTR_RAM
		ldw	#TILE_ATTR_RAM_SIZE
		lda	#$00
		PSUB	memory_fill

		; fill with spaces
		ldx	#TILE_RAM
		ldw	#TILE_RAM_SIZE
		lda	#$10
		PSUB	memory_fill

		ldx	#LAYER_A_SCROLL
		ldw	#LAYER_A_SCROLL_SIZE
		clra
		PSUB	memory_fill

		ldx	#LAYER_B_SCROLL
		ldw	#LAYER_B_SCROLL_SIZE
		clra
		PSUB	memory_fill

		ldx	#SPRITE_RAM
		ldw	#$400
		clra
		PSUB	memory_fill

		; txt color
		ldd	#$ffff
		std	FIX_TILE_PALETTE + $2

		SEEK_XY	1, 0
		ldy	#d_str_version
		PSUB	print_string

		SEEK_LN	1
		lda	#$2e
		ldb	#$1c
		PSUB	print_char_repeat
		PSUB_RETURN

; params:
;  a = x
;  b = y
screen_seek_xy_psub:
		SEEK_XY 0, 0

		leax	b, x
		clrb
		rord
		rord
		negd
		leax	d, x
		PSUB_RETURN
