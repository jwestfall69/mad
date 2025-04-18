	include "cpu/konami2/include/dsub.inc"
	include "cpu/konami2/include/macros.inc"

	include "machine.inc"
	include "mad.inc"

	global screen_init_dsub
	global screen_seek_xy_dsub

	section code

screen_init_dsub:

		MEMORY_FILL16 #PALETTE_RAM_START, #(PALETTE_RAM_SIZE / 2), #$0
		WATCHDOG

		; font color
		ldd	#$7fff
		std	PALETTE_RAM_START + 2

		MEMORY_FILL16 #TILE_RAM_START, #(TILE_RAM_SIZE / 4), #$0
		WATCHDOG

		MEMORY_FILL16 #TILE_RAM_START + (TILE_RAM_SIZE / 2), #(TILE_RAM_SIZE / 4), #$0f0f
		WATCHDOG

		MEMORY_FILL16 #SPRITE_RAM_START, #(SPRITE_RAM_SIZE / 2), #$0
		WATCHDOG

		; -'s on 2nd line
		SEEK_LN 1
		CHAR_REPEAT #$5e, #32

		SEEK_XY 3,0
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
