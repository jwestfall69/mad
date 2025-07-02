	include "cpu/konami2/include/common.inc"

	global screen_init_dsub
	global screen_seek_xy_dsub

	section code

screen_init_dsub:

		MEMORY_FILL16 #PALETTE_RAM, #(PALETTE_RAM_SIZE / 2), #$0
		WATCHDOG

		; font color
		ldd	#$7fff
		std	PALETTE_RAM + 2

		MEMORY_FILL16 #TILE_RAM, #(TILE_RAM_SIZE / 4), #$0
		WATCHDOG

		MEMORY_FILL16 #TILE_RAM + (TILE_RAM_SIZE / 2), #(TILE_RAM_SIZE / 4), #$0f0f
		WATCHDOG

		MEMORY_FILL16 #SPRITE_RAM, #(SPRITE_RAM_SIZE / 2), #$0
		WATCHDOG

		; -'s on 2nd line
		SEEK_XY	0, 1
		CHAR_REPEAT #$5e, #SCREEN_NUM_COLUMNS

		SEEK_XY 4,0
		ldy	#d_str_version
		DSUB	print_string
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

		leax	d, x
		DSUB_RETURN
