	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/memory_write.inc"

	global bg_offset_debug

	section code

bg_offset_debug:
		jsr	bg_tile_viewer_palette_setup

		; highlight color on 2nd pallette
		move.w	#$1f, TXT_PALETTE + PALETTE_SIZE + $e

		; test bg tile
		move.w	#$10, $74386
		move.w	#$80, $75386

		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list

		move.l	#TXT_PALETTE, r_old_highlight

		; match up initial scroll/offset values based on hw init
	ifd _SCREEN_FLIP_
		move.l	#$014dfff0, r_mw_buffer
		move.l	#$00ef0000, r_mw_buffer + 4
	else
		move.l	#$ffb2fff0, r_mw_buffer
		move.l	#$00100004, r_mw_buffer + 4
	endif
		move.w	#$4, r_mw_buffer + 8

		lea	d_mw_settings, a0
		jsr	memory_write_handler
		rts

; params:
;  a6 = video ram location for hightlight
; we are also on the hook for clearing out the
; previous highlight
highlight_cb:
		move.l	r_old_highlight, a0
		move.w	#$0, (a0)

		; change tile to 2nd palette
		lea	(-$800, a6), a6
		move.w	#$10, (a6)
		move.l	a6, r_old_highlight
		rts

write_memory_cb:

		move.w	r_mw_buffer, d0
		move.w	d0, $7a300
		SEEK_XY	(SCREEN_START_X + 8), (SCREEN_START_Y + 16)
		RSUB	print_hex_word

		move.w	r_mw_buffer + 2, d0
		move.w	d0, $7a304
		SEEK_XY	(SCREEN_START_X + 8), (SCREEN_START_Y + 17)
		RSUB	print_hex_word

		move.w	r_mw_buffer+ 4, d0
		move.w	d0, $7a308
		SEEK_XY	(SCREEN_START_X + 8), (SCREEN_START_Y + 18)
		RSUB	print_hex_word

		move.w	r_mw_buffer + 6, d0
		move.w	d0, $7a30c
		SEEK_XY	(SCREEN_START_X + 8), (SCREEN_START_Y + 19)
		RSUB	print_hex_word

		move.w	r_mw_buffer + 8, d0
		move.w	d0, $7a310
		SEEK_XY	(SCREEN_START_X + 8), (SCREEN_START_Y + 20)
		RSUB	print_hex_word
		rts

loop_cb:
		rts

	section data
	align 1

d_mw_settings:		MW_SETTINGS 10, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb

d_screen_xys_list:
	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 2), " ADDR"
	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 4), "07A300  OFF X"
	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 5), "07A301"
	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 6), "07A304  SCRL Y"
	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 7), "07A305"
	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 8), "07A308  OFF Y"
	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 9), "07A309"
	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 10), "07A30C  SCRL X"
	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 11), "07A30D"
	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 12), "07A310  XXXX"
	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 13), "07A311"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 15), "LAST WRITTEN"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 16), "07A300"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 17), "07A304"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 18), "07A308"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 19), "07A30C"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 20), "07A310"
	XY_STRING_LIST_END

	section bss
	align 1

r_old_highlight:	dcb.l 1
r_mw_buffer:		dcb.b 10
