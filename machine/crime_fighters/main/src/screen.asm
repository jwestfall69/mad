	include "cpu/konami2/include/common.inc"

	global screen_init_dsub
	global screen_seek_xy_dsub

	section code

screen_init_dsub:

		; bank to palette ram
		setln	#(SETLN_WATCHDOG_POLL|SETLN_SELECT_RAM_PALETTE)

		MEMORY_FILL16 #PALETTE_RAM, #(PALETTE_RAM_SIZE / 2), #$0
		WATCHDOG

		; font color
		MEMORY_FILL16 #(FIX_TILE_PALETTE + 2), #$7, #$ffff
		WATCHDOG

		setln	#(SETLN_WATCHDOG_POLL|SETLN_SELECT_RAM_WORK)

		MEMORY_FILL16 #TILE_ATTR_RAM, #(TILE_ATTR_RAM_SIZE / 2), #$0
		WATCHDOG

		; fill tiles with spaces
		MEMORY_FILL16 #TILE_RAM, #(TILE_RAM_SIZE/2), #$1010
		WATCHDOG

		MEMORY_FILL16 #LAYER_A_SCROLL, #(LAYER_A_SCROLL_SIZE / 2), #$0
		MEMORY_FILL16 #LAYER_B_SCROLL, #(LAYER_B_SCROLL_SIZE / 2), #$0
		WATCHDOG

		MEMORY_FILL16 #SPRITE_RAM, #(SPRITE_RAM_SIZE / 2), #$0
		WATCHDOG

		; -'s on 2nd line
		SEEK_XY	0, 1
		CHAR_REPEAT #$0c, #SCREEN_NUM_COLUMNS

		SEEK_XY 5,0
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
		aslb
		rola

		leax	d, x
		DSUB_RETURN
