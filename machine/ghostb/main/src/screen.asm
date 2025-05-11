	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"

	include "machine.inc"

	global screen_init_psub
	global screen_seek_xy_psub

	section code

screen_init_psub:
		; mame and hardware don't seem to agree on screen flip
		; setting (bit 3 of REG_ROM_BANK).  The bit set to 1 on
		; hardware is right way up, but mame is upside down and
		; vice versa if set to 0.
	ifd _MAME_BUILD_
		clr	REG_CONTROL
	else
		lda	#CTRL_SCREEN_FLIP
		sta	REG_CONTROL
	endif

		ldx	#TILE_RAM
		ldw	#$1800
		lda	#$0
		PSUB	memory_fill

		ldx	#SPRITE_RAM
		ldw	#SPRITE_RAM_SIZE
		lda	#$0
		PSUB	memory_fill

		ldx	#VIDEO_RAM
		ldw	#VIDEO_RAM_SIZE
		lda	#$0
		PSUB	memory_fill

		SEEK_XY	4, 0
		ldy	#d_str_version
		PSUB	print_string

		SEEK_LN	1
		lda	#'-'
		ldb	#$20
		PSUB	print_char_repeat
		PSUB_RETURN

; params:
;  a = x
;  b = y
screen_seek_xy_psub:
		SEEK_XY 0, 0

		lsla
		leax	a, x
		tfr	b, a
		clrb
		rord
		rord
		leax	d, x
		PSUB_RETURN
