	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/6309/include/dsub.inc"
	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/handlers/memory_write.inc"

	include "machine.inc"

	global sprite_debug

	section code

sprite_debug:
		jsr	sprite_viewer_palette_setup

		; highlight color
		ldd	#$001f
		std	FIX_TILE_PALETTE + PALETTE_SIZE + $1c

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 13)
		ldy	#d_str_last_written
		RSUB	print_string

		ldd	#FIX_TILE
		std	r_old_highlight

		; setup initial values
		ldx	#r_mw_buffer
		ldd	#$cf60		; enabled + pri + size
		std	, x
		ldd	#$0800		; sprite code
		std	2, x
		ldd	#$00b8		; y offset
		std	4, x
		ldd	#$011e		; x offset
		std	6, x


		ldx	#d_mw_settings
		jsr	memory_write_handler
		rts

; params:
;  x = fix ram location to set highlight
; we are also on the hook for clearing out the
; previous highlight
highlight_cb:

		ldy	r_old_highlight
		lda	-$2000, y
		anda	#$1
		sta	-$2000, y

		lda	-$2000, x
		ora	#$40
		sta	-$2000, x
		stx	r_old_highlight
		rts

write_memory_cb:
		ldx	#SPRITE_RAM
		ldy	#r_mw_buffer
		lda	#$4
		sta	r_scratch
		lda	#SCREEN_START_X
		sta	r_x_offset

	.loop_next_word:
		pshs	x
		lda	r_x_offset
		ldb	#SCREEN_START_Y + 15
		RSUB	screen_seek_xy

		ldd	, y++
		pshs	d,y
		RSUB	print_hex_word
		puls	y,d

		puls	x
		std	, x++

		lda	r_x_offset
		adda	#$5
		sta	r_x_offset
		dec	r_scratch
		bne	.loop_next_word
		rts

loop_cb:
		rts


	section data

d_mw_settings:		MW_SETTINGS 8, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb
d_str_last_written:	STRING "LAST WRITTEN"

	section bss

r_mw_buffer:		dcb.b 8
r_old_highlight:	dcb.w 1
r_x_offset:		dcb.b 1
