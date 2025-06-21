	include "cpu/6309/include/dsub.inc"
	include "cpu/6309/include/macros.inc"

	include "machine.inc"

	global screen_init_dsub
	global screen_seek_xy_dsub

	section code

screen_init_dsub:
		ldx	#BAC06_RAM
		ldw	#BAC06_RAM_SIZE
		lda	#$0
		DSUB	memory_fill

		ldx	#SPRITE_RAM
		ldw	#SPRITE_RAM_SIZE
		lda	#$0
		DSUB	memory_fill
		DSUB	sprite_trigger_copy

		ldx	#VIDEO_RAM
		ldw	#VIDEO_RAM_SIZE
		lda	#$0
		DSUB	memory_fill

		SEEK_XY	4, 0
		ldy	#d_str_version
		DSUB	print_string

		SEEK_LN	1
		lda	#'-'
		ldb	#$20
		DSUB	print_char_repeat
		DSUB_RETURN

; params:
;  a = x
;  b = y
screen_seek_xy_dsub:
		SEEK_XY 0, 0

		lsla
		leax	a, x
		tfr	b, a
		clrb
		rord
		rord
		leax	d, x
		DSUB_RETURN
