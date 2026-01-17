	include "cpu/6309/include/common.inc"
	include "cpu/6x09/include/handlers/memory_write.inc"

	global sprite_debug

	section code

sprite_debug:
		jsr	k007121_sprite_viewer_palette_setup

		; highlight color
		ldd	#$1f00
		std	K007121_TILE_A_PALETTE + PALETTE_SIZE + $1e

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 13)
		ldy	#d_str_last_written
		RSUB	print_string

		ldd	#K007121_TILE_B
		std	r_old_highlight

		; setup initial values
		ldx	#r_mw_buffer
		ldd	#$0002
		std	, x
		ldd	#$3020
		std	2, x
		lda	#$88
		sta	4, x

		ldx	#d_mw_settings
		jsr	memory_write_handler
		rts

; params:
;  x = fix ram location to set highlight
; we are also on the hook for clearing out the
; previous highlight
highlight_cb:

		ldy	r_old_highlight
		clr	-$400, y

		lda	#$1
		sta	-$400, x
		stx	r_old_highlight
		rts

write_memory_cb:
		ldx	#K007121_SPRITE
		ldy	#r_mw_buffer
		lda	#$5
		sta	r_scratch
		lda	#SCREEN_START_X
		sta	r_x_offset

	.loop_next_word:
		pshs	x
		lda	r_x_offset
		ldb	#SCREEN_START_Y + 15
		RSUB	screen_seek_xy

		lda	, y+
		pshs	a
		RSUB	print_hex_byte
		puls	a

		puls	x
		sta	, x+

		lda	r_x_offset
		adda	#$3
		sta	r_x_offset
		dec	r_scratch
		bne	.loop_next_word
		rts

loop_cb:
		rts


	section data

d_mw_settings:		MW_SETTINGS 5, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb
d_str_last_written:	STRING "LAST WRITTEN"

	section bss

r_mw_buffer:		dcb.b 5
r_old_highlight:	dcb.w 1
r_x_offset:		dcb.b 1
