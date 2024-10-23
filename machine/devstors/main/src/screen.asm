	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"

	include "machine.inc"

	global screen_init_psub
	global screen_seek_xy_psub

	section code

screen_init_psub:
		ldx	#TILE1_RAM_START
		ldw	#$1800
		lda	#$00
		PSUB	memory_fill

		ldx	#TILE1_RAM_START+$1800
		ldw	#$400
		lda	#$00
		PSUB	memory_fill

		ldx	#TILE2_RAM_START
		ldw	#$1800
		lda	#$10
		PSUB	memory_fill

		ldx	#TILE2_RAM_START+$1808
		ldw	#$400
		lda	#$00
		PSUB	memory_fill

		ldx	#SPRITE_RAM_START
		ldw	#$400
		lda	#$00
		PSUB	memory_fill

		ldx	#PALETTE_RAM_START
		ldw	#PALETTE_RAM_SIZE
		lda	#$00
		PSUB	memory_fill

		; txt color
		lda	#$ff
		sta	(PALETTE_RAM_START + $2)
		sta	(PALETTE_RAM_START + $3)


		; txt shadow ($8 $9)
		; background ($100 $101)

		SEEK_XY	5, 0
		ldy	#d_str_header
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

	section data

d_str_header:	STRING "DEVSTORS - MAD 0.1"
