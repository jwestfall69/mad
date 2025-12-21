	include "cpu/6809/include/common.inc"

	global screen_init_dsub
	global screen_seek_xy_dsub

	section code

screen_init_dsub:
		ldx	#FG_RAM
		ldy	#FG_RAM_SIZE
		lda	#$0
		DSUB	memory_fill

		ldx	#BG_RAM
		ldy	#BG_RAM_SIZE
		lda	#$0
		DSUB	memory_fill

		ldx	#SPRITE_RAM
		ldy	#SPRITE_RAM_SIZE
		lda	#$0
		DSUB	memory_fill

		SEEK_XY	4, 0
		ldy	#d_str_version
		DSUB	print_string

		SEEK_XY	0, 1
		lda	#$df
		ldb	#SCREEN_NUM_COLUMNS
		DSUB	print_char_repeat
		DSUB_RETURN

; params:
;  a = x
;  b = y
screen_seek_xy_dsub:
		SEEK_XY 0, 0

		leax	a, x
		tfr	b, a
		clra
		lslb
		rola
		lslb
		rola
		lslb
		rola
		lslb
		rola
		lslb
		rola
		leax	d, x
		DSUB_RETURN
