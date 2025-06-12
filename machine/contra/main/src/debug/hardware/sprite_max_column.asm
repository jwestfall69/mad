	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/xy_string.inc"

	include "input.inc"
	include "machine.inc"
	include "mad.inc"

	global sprite_max_column

	section code

SPRITE_NUM_GREEN	equ $02
SPRITE_NUM_RED		equ $03

SPRITE_SIZE		equ $06
SPRITE_Y_POS		equ $00

sprite_max_column:
		ldd	#$e003		; green
		std	K007121_18E_SPRITE_PALETTE + $10	; for sprite 02
		ldd	#$1f00		; red
		std	K007121_18E_SPRITE_PALETTE + $18	; for sprite 03

		ldy	#K007121_18E_SPRITE
		lde	#$e0		; start x position
		ldf	#$68		; columns/sprites to draw * 2

	.loop_next_column:

; * Byte | Bit(s)   | Use
; * -----+-76543210-+----------------
; *   0  | xxxxxxxx | sprite code
; *   1  | xxxx---- | color
; *   1  | ----xx-- | sprite code low 2 bits for 16x8/8x8 sprites
; *   1  | ------xx | sprite code bank bits 1/0
; *   2  | xxxxxxxx | y position
; *   3  | xxxxxxxx | x position (low 8 bits)
; *   4  | xx------ | sprite code bank bits 3/2
; *   4  | --x----- | flip y
; *   4  | ---x---- | flip x
; *   4  | ----xxx- | sprite size 000=16x16 001=16x8 010=8x16 011=8x8 100=32x32
; *   4  | -------x | x position (high bit)

		lda	#SPRITE_NUM_GREEN
		sta	, y

		; purposely writing x/y swapped because screen is TATE so sprites
		; are draw left to right, up/down
		ste	2, y
		lda	#SPRITE_Y_POS
		sta	3, y

		lda	#SPRITE_SIZE
		sta	4, y

		dece
		leay	5, y

		lda	#SPRITE_NUM_RED
		sta	, y

		; purposely writing x/y swapped because screen is TATE so sprites
		; are draw left to right, up/down
		ste	2, y
		lda	#SPRITE_Y_POS
		sta	3, y

		lda	#SPRITE_SIZE
		sta	4, y

		dece
		leay	5, y

		decf
		bne	.loop_next_column

		lda	#INPUT_B2
		jsr	wait_button_press
		rts
