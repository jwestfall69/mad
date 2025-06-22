	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/6309/include/dsub.inc"
	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/xy_string.inc"
	include "cpu/6309/include/handlers/memory_write.inc"

	include "machine.inc"

	global k051733_math_debug

	section code

k051733_math_debug:
		; highlight color
		ldd	#$001f
		std	FIX_TILE_PALETTE + PALETTE_SIZE + $2

		ldy	#d_xys_screen_list
		RSUB	print_xy_string_list

		ldd	#FIX_TILE
		std	r_old_highlight

		; setup initial values
		ldx	#r_mw_buffer
		clrd
		std	, x
		std	2, x
		std	4, x

		ldx	#d_mw_settings
		jsr	memory_write_handler
		rts

; params:
;  x = fix ram location to set highlight
; we are also on the hook for clearing out the
; previous highlight
highlight_cb:
		ldy	r_old_highlight
		clr	-$2000, y

		lda	#$40
		sta	-$2000, x
		stx	r_old_highlight
		rts

write_memory_cb:
		ldx	#K051733_BASE
		ldy	#r_mw_buffer
		lda	#$3
		sta	r_scratch
		lda	#SCREEN_START_X
		sta	r_x_offset

	.loop_next_word:
		pshs	x
		lda	r_x_offset
		ldb	#SCREEN_START_Y + 12
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

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 15)
		ldd	K051733_BASE
		RSUB	print_hex_word

		SEEK_XY	(SCREEN_START_X + 5), (SCREEN_START_Y + 15)
		ldd	K051733_BASE + $2
		RSUB	print_hex_word

		SEEK_XY	(SCREEN_START_X + 10), (SCREEN_START_Y + 15)
		ldd	K051733_BASE + $4
		RSUB	print_hex_word

loop_cb:
		rts


	section data

d_mw_settings:		MW_SETTINGS 6, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb

d_xys_screen_list:
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 2), "ADDR"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 4), "1FA0"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 5), "1FA1"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 6), "1FA2"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 7), "1FA3"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 8), "1FA4"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 9), "1FA5"
			XY_STRING SCREEN_START_X, (SCREEN_START_Y + 11), "LAST WRITTEN"
			XY_STRING SCREEN_START_X, (SCREEN_START_Y + 14), "READ VALUES"
			XY_STRING_LIST_END

	section bss

r_mw_buffer:		dcb.b 6
r_old_highlight:	dcb.w 1
r_x_offset:		dcb.b 1
