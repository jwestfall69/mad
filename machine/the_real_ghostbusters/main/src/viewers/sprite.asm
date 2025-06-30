	include "cpu/6309/include/common.inc"
	include "global/include/sprite/dataeast/karnov.inc"

	global sprite_viewer

	section code

SPRITE_NUM_MASK		equ $fff

sprite_viewer:
		ldx	#r_sprite_struct

		; setup initial struct values
		ldd	#$105
		std	s_se_num, x

		lda	#$1
		sta	s_se_size, x

		ldd	#$90
		std	s_se_pos_x, x
		ldd	#$80
		std	s_se_pos_y, x

		ldd	#SPRITE_NUM_MASK
		ldy	#draw_sprite_cb
		jsr	sprite_deco_karnov_viewer_handler
		rts

; Exacted from mame's code in src/mame/dataeast/deckarn.cpp
; * Byte | Bit(s)   | Use
; * -----+-76543210-+----------------
; *   0  | x------- | sprite enabled
; *   0  | ----x--- | sprite size (0 = 16x16, 1 = 16x32)
; *   0  | -??????- | ?
; *   0  | -------x | y position (high bit)
; *   1  | xxxxxxxx | y position
; *   2  | ???????? | ?
; *   3  | ???----- | ?
; *   3  | ---x---- | or'd with sprite number?
; *   3  | ----?--- | ?
; *   3  | -----x-- | flip x
; *   3  | ------x- | flip y
; *   3  | -------x | sprite enabled again?
; *   4  | ???????- | ?
; *   4  | -------x | x position (high bit)
; *   5  | xxxxxxxx | x position
; *   6  | xxxx---- | color/palette
; *   6  | ----xxxx | sprite num (high bits)
; *   7  | xxxxxxxx | sprite num
draw_sprite_cb:
		ldy	#r_sprite_struct

		ldd	s_se_pos_y, y
		ora	#$80
		std	SPRITE_RAM

		lda	s_se_size, y
		lsla
		lsla
		lsla
		lsla
		ora	#$1
		sta	SPRITE_RAM + 3

		ldd	s_se_pos_x, y
		std	SPRITE_RAM + 4

		ldd	s_se_num, y
		std	SPRITE_RAM + 6

		RSUB	sprite_trigger_copy
		rts

	section bss

r_sprite_struct:	dcb.b s_se_struct_size
