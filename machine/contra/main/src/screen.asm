	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"

	include "machine.inc"

	global screen_init_psub
	global screen_seek_xy_psub

	section code

screen_init_psub:
		ldx	#TILE1_RAM
		ldw	#TILE1_RAM_SIZE / 2
		lda	#$00
		PSUB	memory_fill

		ldx	#TILE1_RAM + (TILE1_RAM_SIZE / 2)
		ldw	#TILE1_RAM_SIZE / 2
		lda	#$10
		PSUB	memory_fill

		ldx	#TILE2_RAM
		ldw	#TILE2_RAM_SIZE / 2
		lda	#$00
		PSUB	memory_fill

		ldx	#TILE2_RAM + (TILE2_RAM_SIZE / 2)
		ldw	#TILE2_RAM_SIZE / 2
		lda	#$10
		PSUB	memory_fill

		ldx	#TILE3_RAM
		ldw	#TILE3_RAM_SIZE / 2
		lda	#$00
		PSUB	memory_fill

		ldx	#TILE3_RAM + (TILE3_RAM_SIZE / 2)
		ldw	#TILE3_RAM_SIZE / 2
		lda	#$10
		PSUB	memory_fill

		ldx	#SPRITE1_RAM
		ldw	#SPRITE1_RAM_SIZE
		lda	#$00
		PSUB	memory_fill

		ldx	#SPRITE2_RAM
		ldw	#SPRITE2_RAM_SIZE
		lda	#$00
		PSUB	memory_fill

		ldx	#PALETTE_RAM
		ldw	#PALETTE_RAM_SIZE
		lda	#$00
		PSUB	memory_fill

		; txt color
		lda	#$ff
		sta	(PALETTE_RAM + $3e)
		sta	(PALETTE_RAM + $3f)

		SEEK_XY	2, 0
		ldy	#d_str_version
		PSUB	print_string

		SEEK_LN	1
		lda	#$0c
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
