	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"

	include "machine.inc"

	global screen_clear_psub
	global screen_init_psub
	global screen_seek_xy_psub

	section code

screen_init_psub:
		ldx	#PALETTE_RAM_START
		ldw	#PALETTE_RAM_SIZE
		lda	#$00
		PSUB	memory_fill

		; txt color
		lda	#$ff
		sta	(PALETTE_RAM_START + $1c)
		sta	(PALETTE_RAM_START + $1d)

		; txt shadow ($2 $3)
		; background ($100 $101)
		bra	screen_clear_psub

screen_clear_psub:
		ldx	#TILE_RAM_START
		ldw	#$1800
		lda	#$01
		PSUB	memory_fill

		ldx	#TILE_RAM_START+$1800
		ldw	#$400
		lda	#$00
		PSUB	memory_fill

		ldx	#TILE_RAM_START+$2000
		ldw	#$1800
		lda	#$fe
		PSUB	memory_fill

		ldx	#TILE_RAM_START+$3808
		ldw	#$400
		lda	#$00
		PSUB	memory_fill

		ldx	#TILE_RAM_START+$3c00
		ldw	#$400
		lda	#$00
		PSUB	memory_fill

		SEEK_XY	9, 0
		ldy	#d_str_header
		PSUB	print_string

		SEEK_LN	1
		lda	#$4c
		ldb	#$24
		PSUB	print_char_repeat
		PSUB_RETURN

; params:
;  a = x
;  b = y
screen_seek_xy_psub:
		SEEK_XY 0, 0

		leax	a, x
		tfr	b, a
		clrb
		rord
		rord
		leax	d, x
		PSUB_RETURN

	section data

d_str_header:	STRING "MAINEVT - MAD 0.1"
