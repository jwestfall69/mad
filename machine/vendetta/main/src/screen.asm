	include "cpu/konami/include/dsub.inc"
	include "cpu/konami/include/macros.inc"

	include "machine.inc"
	include "mad.inc"

	global screen_init_dsub
	global screen_seek_xy_dsub

	section code

screen_init_dsub:

		lda	#$1
		sta	REG_CONTROL

		MEMORY_FILL16 #PALETTE_RAM_START, #(PALETTE_RAM_SIZE/2), #$0
		WATCHDOG

		; white for font
		ldd	#$ffff
		std	PALETTE_RAM_START + $10
		ldd	#$ffff
		std	PALETTE_RAM_START + $410

		MEMORY_FILL16 #SPRITE_RAM_START, #(SPRITE_RAM_SIZE/2), #$0
		WATCHDOG

		lda	#$0
		sta	REG_CONTROL

		MEMORY_FILL16 #TILE1_RAM_START, #((TILE1_RAM_SIZE + $400)/2), #$0
		WATCHDOG

		; fill tiles with spaces
		MEMORY_FILL16 #TILE2_RAM_START, #(TILE2_RAM_SIZE/2), #$1010
		WATCHDOG

		MEMORY_FILL16 #(TILE2_RAM_START + TILE2_RAM_SIZE), #$200, #$0
		WATCHDOG

		; -'s on 2nd line
		SEEK_LN 1
		CHAR_REPEAT #$0c, #40

		SEEK_XY 7,0
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
