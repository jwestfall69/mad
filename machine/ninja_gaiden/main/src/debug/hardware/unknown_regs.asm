	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/memory_write.inc"

	global unknown_regs_debug

	section code

unknown_regs_debug:
		jsr	bg_tile_viewer_palette_setup
		jsr	fg_tile_viewer_palette_setup
		jsr	sprite_viewer_palette_setup

		; highlight color on 2nd pallette
		move.w	#$1f, TXT_PALETTE + PALETTE_SIZE + $e

		; test fg tile
		move.w	#$10, $72386
		move.w	#$02, $73386

		; test bg tile
		move.w	#$10, $74388
		move.w	#$80, $75388

		; test sprite
		move.l	#$004517d0, SPRITE_RAM
		move.l	#$00120090, SPRITE_RAM + 4
		move.l	#$02640000, SPRITE_RAM + 8
		move.l	#$0, SPRITE_RAM + 12

		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list

		move.l	#TXT_PALETTE, r_old_highlight

		move.l	#$000f0010, r_mw_buffer
		move.l	#$00ef0001, r_mw_buffer + 4

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
		move.w	d0, $7a000
		SEEK_XY	(SCREEN_START_X + 8), (SCREEN_START_Y + 16)
		RSUB	print_hex_word

		move.w	r_mw_buffer + 2, d0
		move.w	d0, $7a002
		SEEK_XY	(SCREEN_START_X + 8), (SCREEN_START_Y + 17)
		RSUB	print_hex_word

		move.w	r_mw_buffer+ 4, d0
		move.w	d0, $7a004
		SEEK_XY	(SCREEN_START_X + 8), (SCREEN_START_Y + 18)
		RSUB	print_hex_word

		move.w	r_mw_buffer + 6, d0
		move.w	d0, $7a006
		SEEK_XY	(SCREEN_START_X + 8), (SCREEN_START_Y + 19)
		RSUB	print_hex_word
		rts

loop_cb:
		rts

	section data
	align 1

d_mw_settings:		MW_SETTINGS 8, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb

d_screen_xys_list:
	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 2), " ADDR"
	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 4), "07A000 XXXX"
	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 5), "07A001"
	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 6), "07A002 SPR OFFY"
	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 7), "07A003"
	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 8), "07A004 XXXX"
	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 9), "07A005"
	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 10), "07A006 XXXX"
	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 11), "07A007"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 15), "LAST WRITTEN"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 16), "07A000"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 17), "07A002"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 18), "07A004"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 19), "07A006"
	XY_STRING_LIST_END

	section bss
	align 1

r_old_highlight:	dcb.l 1
r_mw_buffer:		dcb.b 8
