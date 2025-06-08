	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/xy_string.inc"

	include "input.inc"
	include "machine.inc"
	include "mad.inc"

	global sprite_test

	section code

sprite_test:
		PSUB	screen_init

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_title
		PSUB	print_string

		ldx	#d_palette_data
		ldy	#K007121_18E_SPRITE_PALETTE
		ldd	#PALETTE_SIZE
		jsr	copy_memory

		ldx	#d_sprite_before_data
		ldy	#K007121_18E_SPRITE
		ldd	#(5 * 50)
		jsr	copy_memory

	ifd _MAME_BUILD_
		lda	#$be
		sta	REG_K007121_18E_C3
	endif

		lda	#INPUT_B1
		jsr	wait_button_press

		ldx	#d_sprite_after_data
		ldy	#K007121_18E_SPRITE
		ldd	#(5 * 50)
		jsr	copy_memory

	ifd _MAME_BUILD_
		lda	#$be
		sta	REG_K007121_18E_C3
	endif

		lda	#INPUT_B2
		jsr	wait_button_press

		rts

; params:
;  x = source
;  y = dest
;  d = length in bytes
copy_memory:
		lda	,x+
		sta	,y+
		decd
		bne	copy_memory
		rts

	section data

d_palette_data:
	dc.b	$00, $00, $6f, $19, $b3, $15, $39, $3a, $2c, $25, $34, $1d, $7e, $2d, $ff, $02
	dc.b	$29, $2a, $ab, $4d, $8a, $5a, $69, $39, $8b, $2d, $72, $4a, $bc, $73, $02, $00

d_sprite_before_data:
	; sprites when "10" count down is on screen
	dc.b	$02, $00, $88, $88, $06
	dc.b	$02, $00, $88, $90, $06
	dc.b	$02, $00, $88, $98, $06
	dc.b	$02, $00, $88, $a0, $06
	dc.b	$02, $00, $98, $a0, $06
	dc.b	$02, $00, $a0, $70, $06
	dc.b	$02, $00, $a0, $78, $06
	dc.b	$02, $00, $a0, $80, $06
	dc.b	$02, $00, $a0, $88, $06
	dc.b	$02, $00, $a0, $90, $06
	dc.b	$02, $00, $a0, $98, $06
	dc.b	$02, $00, $a0, $a0, $06
	dc.b	$02, $00, $a8, $78, $06
	dc.b	$02, $00, $a8, $a0, $06
	dc.b	$02, $00, $70, $70, $06
	dc.b	$02, $00, $70, $78, $06
	dc.b	$02, $00, $70, $80, $06
	dc.b	$02, $00, $70, $88, $06
	dc.b	$02, $00, $70, $90, $06
	dc.b	$02, $00, $70, $98, $06
	dc.b	$02, $00, $70, $a0, $06
	dc.b	$02, $00, $78, $70, $06
	dc.b	$02, $00, $78, $a0, $06
	dc.b	$02, $00, $80, $70, $06
	dc.b	$02, $00, $80, $a0, $06
	dc.b	$02, $00, $88, $70, $06
	dc.b	$02, $00, $88, $78, $06
	dc.b	$02, $00, $88, $80, $06
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $00, $00, $00
	dc.b	$00, $00, $00, $00, $00
	dc.b	$00, $00, $00, $00, $00
	dc.b	$00, $00, $00, $00, $00
	dc.b	$00, $00, $00, $00, $00
	dc.b	$00, $00, $00, $00, $00

d_sprite_after_data:
	if 0
	; sprites from after press player 1 start.
	; the game has written the player sprite and
	; done its stuff to clean up the "10" sprites
	dc.b	$a8, $00, $98, $61, $88 ; legs
	dc.b	$b8, $00, $a8, $59, $80 ; back
	dc.b	$b9, $00, $98, $59, $80 ; front + with arms
	dc.b	$c0, $00, $88, $59, $80 ; gun
	dc.b	$02, $00, $f0, $a0, $08
	dc.b	$02, $00, $f0, $70, $08
	dc.b	$02, $00, $f0, $78, $08
	dc.b	$02, $00, $f0, $80, $08
	dc.b	$02, $00, $f0, $88, $08
	dc.b	$02, $00, $f0, $90, $08
	dc.b	$02, $00, $f0, $98, $08
	dc.b	$02, $00, $f0, $a0, $08
	dc.b	$02, $00, $f0, $78, $08
	dc.b	$02, $00, $f0, $a0, $08
	dc.b	$02, $00, $f0, $70, $08
	dc.b	$02, $00, $f0, $78, $08
	dc.b	$02, $00, $f0, $80, $08
	dc.b	$02, $00, $f0, $88, $08
	dc.b	$02, $00, $f0, $90, $08
	dc.b	$02, $00, $f0, $98, $08
	dc.b	$02, $00, $f0, $a0, $08
	dc.b	$02, $00, $78, $70, $06
	dc.b	$02, $00, $78, $a0, $06
	dc.b	$02, $00, $80, $70, $06
	dc.b	$02, $00, $80, $a0, $06
	dc.b	$02, $00, $88, $70, $06
	dc.b	$02, $00, $88, $78, $06
	dc.b	$02, $00, $88, $80, $06
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $00, $00, $00
	dc.b	$00, $00, $00, $00, $00
	dc.b	$00, $00, $00, $00, $00
	dc.b	$00, $00, $00, $00, $00
	dc.b	$00, $00, $00, $00, $00
	dc.b	$00, $00, $00, $00, $00

	else

	; these are all 32x32 sprites that are
	; offscreen			; running total of 8x8 sprites
	dc.b	$02, $00, $f0, $a0, $08 ; 16
	dc.b	$02, $00, $f0, $a0, $08 ; 32
	dc.b	$02, $00, $f0, $a0, $08 ; 48
	dc.b	$02, $00, $f0, $70, $08 ; 64
	dc.b	$02, $00, $f0, $78, $08 ; 80
	dc.b	$02, $00, $f0, $80, $08 ; 96
	dc.b	$02, $00, $f0, $88, $08 ; 112
	dc.b	$02, $00, $f0, $90, $08 ; 128
	dc.b	$02, $00, $f0, $98, $08 ; 144
	dc.b	$02, $00, $f0, $a0, $08 ; 160
	dc.b	$02, $00, $f0, $78, $08 ; 176
	dc.b	$02, $00, $f0, $a0, $08 ; 192
	dc.b	$02, $00, $f0, $70, $08 ; 208
	dc.b	$02, $00, $f0, $78, $08 ; 224
	dc.b	$02, $00, $f0, $80, $08 ; 240
	dc.b	$02, $00, $f0, $88, $08 ; 256
	; if you comment out the below line
	; 8 of the 8x8 "10" sprites will get drawn.
	; which points to the 264 8x8 sprite limit
	;dc.b	$02, $00, $f0, $90, $08 ; 272

	; below are parts of the "10" sprites
	; the game never cleaned up
	dc.b	$02, $00, $88, $88, $06
	dc.b	$02, $00, $88, $90, $06
	dc.b	$02, $00, $88, $98, $06
	dc.b	$02, $00, $88, $a0, $06
	dc.b	$02, $00, $98, $a0, $06
	dc.b	$02, $00, $a0, $70, $06
	dc.b	$02, $00, $a0, $78, $06
	dc.b	$02, $00, $a0, $80, $06
	dc.b	$02, $00, $a0, $88, $06
	dc.b	$02, $00, $a0, $90, $06
	dc.b	$02, $00, $a0, $98, $06
	dc.b	$02, $00, $a0, $a0, $06
	dc.b	$02, $00, $a8, $78, $06
	dc.b	$02, $00, $a8, $a0, $06
	dc.b	$02, $00, $70, $70, $06
	dc.b	$02, $00, $70, $78, $06
	dc.b	$02, $00, $70, $80, $06
	dc.b	$02, $00, $70, $88, $06
	dc.b	$02, $00, $70, $90, $06
	dc.b	$02, $00, $70, $98, $06
	dc.b	$02, $00, $70, $a0, $06
	dc.b	$02, $00, $78, $70, $06
	dc.b	$02, $00, $78, $a0, $06
	dc.b	$02, $00, $80, $70, $06
	dc.b	$02, $00, $80, $a0, $06
	dc.b	$02, $00, $88, $70, $06
	dc.b	$02, $00, $88, $78, $06
	dc.b	$02, $00, $88, $80, $06
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $f0, $00, $08
	dc.b	$00, $00, $00, $00, $00
	dc.b	$00, $00, $00, $00, $00
	dc.b	$00, $00, $00, $00, $00
	dc.b	$00, $00, $00, $00, $00
	dc.b	$00, $00, $00, $00, $00
	dc.b	$00, $00, $00, $00, $00
	endif
d_str_title:	STRING "SPRITE TEST"
