	include "cpu/konami/include/error_codes.inc"
	include "cpu/konami/include/macros.inc"

	include "machine.inc"
	include "mad.inc"

	global screen_init
	global screen_seek_xy

	section code

screen_init:

		; bank to palette ram
		setline	#$a0

		MEMORY_FILL16 #PALETTE_RAM_START, #(PALETTE_RAM_SIZE/2), #$0
		WATCHDOG

		; white for font
		MEMORY_FILL16 #(PALETTE_RAM_START + 2), #$7, #$ffff
		WATCHDOG

		setline #$80


		MEMORY_FILL16 #TILE1_RAM_START, #((TILE1_RAM_SIZE + $400)/2), #$0
		WATCHDOG

		; fill tiles with spaces
		MEMORY_FILL16 #TILE2_RAM_START, #(TILE2_RAM_SIZE/2), #$1010

		MEMORY_FILL16 #(TILE2_RAM_START + TILE2_RAM_SIZE), #$200, #$0
		MEMORY_FILL8 #(TILE2_RAM_START + TILE2_RAM_SIZE), #$400, #$0

		; -'s on 2nd line
		SEEK_LN 1
		CHAR_REPEAT #$0c, #40

		SEEK_XY 5,0
		ldy	#d_str_version
		jsr	print_string
		rts

; params:
;  a = x
;  b = y
screen_seek_xy:
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
		rts
