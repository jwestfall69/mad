	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/memory_write.inc"

	global sprite_debug

	section code

sprite_debug:
		jsr	sprite_viewer_palette_setup

		RS_SD_SETUP

		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list

		move.l	#TILE_BASE + 2, r_old_highlight

		lea	d_mw_settings, a0
		jsr	memory_write_handler
		rts

; params:
;  a6 = video ram location for hightlight
; we are also on the hook for clearing out the
; previous highlight
highlight_cb:
		move.l	r_old_highlight, a0
		and.w	#$ff, (a0)

		or.w	#$1<<12, (a6)
		move.l	a6, r_old_highlight
		rts

write_memory_cb:
		move.w	r_mw_buffer, d0
		move.w	d0, SPRITE_BASE + 4
		SEEK_XY	(SCREEN_START_X + 8), (SCREEN_START_Y + 16)
		RSUB	print_hex_word

		move.w	r_mw_buffer + 2, d0
		move.w	d0, SPRITE_BASE + 6
		SEEK_XY	(SCREEN_START_X + 8), (SCREEN_START_Y + 17)
		RSUB	print_hex_word

		move.w	r_mw_buffer + 4, d0
		move.w	d0, SPRITE_BASE + $1004
		SEEK_XY	(SCREEN_START_X + 8), (SCREEN_START_Y + 18)
		RSUB	print_hex_word

		move.w	r_mw_buffer + 6, d0
		move.w	d0, SPRITE_BASE + $1006
		SEEK_XY	(SCREEN_START_X + 8), (SCREEN_START_Y + 19)
		RSUB	print_hex_word
loop_cb:
		rts

	section data
	align 1

d_mw_settings:		MW_SETTINGS 8, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 14), " ADDR   LAST WRITTEN"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 16), "100004"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 17), "100006"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 18), "101004"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 19), "101006"
	XY_STRING_LIST_END

	section bss
	align 1

r_old_highlight:	dcb.l 1
r_mw_buffer:		dcb.b 8
