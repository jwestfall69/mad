	include "cpu/6809/include/common.inc"

	global screen_init_dsub
	global screen_seek_xy_dsub

	section code

screen_init_dsub:
		ldx	#K005885_TILE_B
		ldy	#K005885_TILE_B_SIZE
		lda	#$10
		DSUB	memory_fill

		ldx	#K005885_TILE_B_ATTR
		ldy	#K005885_TILE_B_ATTR_SIZE
		lda	#$0
		DSUB	memory_fill

		ldx	#K005885_TILE_A
		ldy	#K005885_TILE_A_SIZE
		lda	#$10
		DSUB	memory_fill

		ldx	#K005885_TILE_A_ATTR
		ldy	#K005885_TILE_A_ATTR_SIZE
		lda	#$0
		DSUB	memory_fill

		ldx	#K005885_SPRITE
		ldy	#K005885_SPRITE_SIZE
		lda	#$0
		DSUB	memory_fill

		SEEK_XY	1, 0
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
		lsra
		rorb
		lsra
		rorb
		lsra
		rorb
		coma
		comb
		addd	#$1
		leax	d, x
		DSUB_RETURN
