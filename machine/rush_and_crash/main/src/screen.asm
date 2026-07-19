	include "cpu/6809/include/common.inc"

	global palette_init_irq
	global palette_init_no_irq_dsub
	global screen_init_dsub
	global screen_seek_xy_dsub

	section code

screen_init_dsub:
		ldx	#FG_TILE_RAM
		ldy	#FG_TILE_RAM_SIZE / 2
		ldd	#$20
		DSUB	memory_fill_word

		ldx	#BG_TILE_RAM
		ldy	#BG_TILE_RAM_SIZE / 2
		ldd	#$41
		DSUB	memory_fill_word

		SEEK_XY	2, 0
		ldy	#d_str_version
		DSUB	print_string

		SEEK_XY	0, 1
		lda	#$5c
		ldb	#SCREEN_NUM_COLUMNS
		DSUB	print_char_repeat
		DSUB_RETURN

; params:
;  a = x
;  b = y
screen_seek_xy_dsub:
		SEEK_XY 0, 0

		asla
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
		lslb
		rola
		coma
		comb
		addd	#$1
		leax	d, x
		DSUB_RETURN

palette_init_no_irq_dsub:
		ldx	#PALETTE_RAM
		ldy	#PALETTE_RAM_SIZE
		lda	#$0
		DSUB	memory_fill

		ldd	#$ffff
		std	FG_TILE_PALETTE + 4
		DSUB_RETURN


; writing to palette ram only works correctly if it
; happens in vblank.  There isn't enough time in vblank
; to write all of it, so it needs to be broken up.
; Below mimicks what the game rom does in breaking it up
; into $80 sized chunks.  This same behavior is seen
; in capcom 85608 boards (avengers/trojan) too.
palette_init_irq:
		CPU_INTS_ENABLE

		jsr	wait_irq
		ldd	#PALETTE_RAM_SIZE / $80
		ldy	#PALETTE_RAM

	.loop_next_block:
		pshs	d,y
		lda	#$0
		sta	r_vblank_fill_data
		sty	r_vblank_fill_addr
		ldd	#$80
		std	r_vblank_fill_size
		jsr	wait_vblank_fill

		puls	d,y
		leay	$80,y
		subd	#$1
		bne	.loop_next_block

		ldd	#d_palette_data
		std	r_vblank_copy_src
		ldd	#FG_TILE_PALETTE + 4
		std	r_vblank_copy_dst
		ldd	#$2
		std	r_vblank_copy_size
		jsr	wait_vblank_copy

		CPU_INTS_DISABLE
		rts

	section data

d_palette_data:
		dc.w	$ffff
