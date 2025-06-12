	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/xy_string.inc"

	include "input.inc"
	include "machine.inc"
	include "mad.inc"
	include "smc.inc"

	global smc_draw_sprites
	global smc_palette_setup

	section code

SPRITE_START_X		equ $c0
SPRITE_START_Y		equ $0

smc_palette_setup:
		ldd	#$e003		; green
		ldw	#(PALETTE_SIZE - 2) / 2
		ldx	#K007121_18E_SPRITE_PALETTE + $2
		PSUB	memory_fill_word
		rts


; params:
;  x = address of smc_entry struct
smc_draw_sprites:
		lda	#SPRITE_START_Y
		sta	r_y_pos

		ldy	#K007121_18E_SPRITE
		lde	s_smc_num_rows, x

	.loop_next_row:
		lda	#SPRITE_START_X
		sta	r_x_pos
		ldf	s_smc_num_columns, x

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

		lda	s_smc_sprite_num, x
		sta	, y

		; purposely writing x/y swapped because screen is TATE so sprites
		; are draw left to right, up/down
		lda	r_x_pos
		sta	2, y

		lda	r_y_pos
		sta	3, y

		lda	s_smc_sprite_size, x
		sta	4, y

		lda	r_x_pos
		suba	s_smc_x_dec, x
		sta	r_x_pos

		leay	5, y

		decf
		bne	.loop_next_column

		lda	r_y_pos
		adda	s_smc_y_inc, x
		sta	r_y_pos
		dece
		bne 	.loop_next_row
		rts

	section bss

r_x_pos:	dcb.b 1
r_y_pos:	dcb.b 1
