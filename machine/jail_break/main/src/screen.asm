	include "cpu/6809/include/common.inc"

	global screen_init_dsub
	global screen_init_no_scroll_clear_dsub
	global screen_seek_xy_dsub

	section code

screen_init_dsub:
		ldx	#SCROLL_RAM
		ldy	#SCROLL_RAM_SIZE * 2
		lda	#$0
		DSUB	memory_fill


screen_init_no_scroll_clear_dsub:
		ldx	#TILE_RAM
		ldy	#TILE_RAM_SIZE
		lda	#$10
		DSUB	memory_fill

		ldx	#TILE_RAM_ATTR
		ldy	#TILE_RAM_ATTR_SIZE
		lda	#$0
		DSUB	memory_fill

		ldx	#SPRITE_RAM
		ldy	#SPRITE_RAM_SIZE
		lda	#$0
		DSUB	memory_fill

		SEEK_XY	3, 0
		ldy	#d_str_version
		DSUB	print_string

		SEEK_XY	0, 1
		lda	#$0c
		ldb	#SCREEN_NUM_COLUMNS
		DSUB	print_char_repeat
		DSUB_RETURN

; params:
;  a = x
;  b = y
screen_seek_xy_dsub:
		SEEK_XY 0, 0

		leax	a, x

		clra

		aslb
		rola
		aslb
		rola
		aslb
		rola
		aslb
		rola
		aslb
		rola
		aslb
		rola

		leax	d, x
		DSUB_RETURN
