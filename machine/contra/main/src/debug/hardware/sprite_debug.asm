	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/6309/include/dsub.inc"
	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/handlers/memory_write.inc"

	include "machine.inc"

	global sprite_debug

	section code

sprite_debug:
		jsr	k007121_10e_sprite_viewer_palette_setup

		; highlight color
		ldd	#$001f
		std	K007121_10E_TILE_B_PALETTE + $c

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 13)
		ldy	#d_str_last_written
		RSUB	print_string

		ldd	#K007121_10E_TILE_B
		std	r_old_highlight

		; setup initial values
		ldx	#r_mw_buffer
		ldd	#$7000		; sprite code
		std	, x
		ldd	#$3020		; x + y offset
		std	2, x
		lda	#$88		; more sprite code?
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

		lda	#$2
		sta	-$400, x
		stx	r_old_highlight
		rts

write_memory_cb:
		ldx	#K007121_10E_SPRITE
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
