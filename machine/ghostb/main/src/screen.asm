	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"

	include "machine.inc"

	global screen_init_psub
	global screen_seek_xy_psub

	section code

screen_init_psub:
		ldx	#TILE1_RAM_START
		ldw	#$1800
		lda	#$0
		PSUB	memory_fill

		ldx	#SPRITE_RAM_START
		ldw	#SPRITE_RAM_SIZE
		lda	#$0
		PSUB	memory_fill

		ldx	#VIDEO_RAM_START
		ldw	#VIDEO_RAM_SIZE
		lda	#$0
		PSUB	memory_fill

		SEEK_XY	4, 0
		ldy	#d_str_version
		PSUB	print_string

		SEEK_LN	1
		lda	#'-'
		ldb	#$20
		PSUB	print_char_repeat
		PSUB_RETURN

; params:
;  a = x
;  b = y
screen_seek_xy_psub:
		SEEK_XY 0, 0

		lsla
		leax	a, x
		tfr	b, a
		clrb
		rord
		rord
		leax	d, x
		PSUB_RETURN
