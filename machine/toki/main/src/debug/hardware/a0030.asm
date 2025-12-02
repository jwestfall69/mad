	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/memory_write.inc"

	global a0030_debug

	section code

a0030_debug:
		jsr	bg_tile_viewer_palette_setup
		jsr	fg_tile_viewer_palette_setup

		lea	FG_RAM + $80, a0
		move.l	#$700, d0
		move.w	#$1002, d1
		DSUB	memory_fill

		lea	BG_RAM + $80, a0
		move.l	#$700, d0
		move.w	#$1010, d1
		DSUB	memory_fill

		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list

		; highlight color on 2nd pallette
		move.w	#$1f, TXT_PALETTE + PALETTE_SIZE + $16
		move.l	#TXT_PALETTE, r_old_highlight

		; initial values
		move.l	#$0, r_mw_buffer
		move.l	#$0, r_mw_buffer + 4
		move.l	#$0, r_mw_buffer + 8
		move.l	#$0, r_mw_buffer + 12

		lea	d_mw_settings, a0
		jsr	memory_write_handler
		rts

; params:
;  a6 = video ram location for hightlight
; we are also on the hook for clearing out the
; previous highlight
highlight_cb:
		move.l	r_old_highlight, a0
		move.b	#$0, (a0)

		move.b	#$10, (a6)
		move.l	a6, r_old_highlight
		rts

write_memory_cb:
		move.l	r_mw_buffer, $a0030
		move.l	r_mw_buffer + 4, $a0034
		move.l	r_mw_buffer + 8, $a0038
		move.l	r_mw_buffer + 12, $a003c

		moveq	#$f, d5
		moveq	#(SCREEN_START_Y + 4), d4
		lea	r_mw_buffer, a0

	.loop_next_byte:
		moveq	#(SCREEN_START_X + 14), d0
		move.w	d4, d1
		RSUB	screen_seek_xy
		move.b	(a0)+, d0
		RSUB	print_hex_byte
		addq.b	#$1, d4
		dbra	d5, .loop_next_byte
		rts

loop_cb:
		rts

	section data
	align 1

d_mw_settings:		MW_SETTINGS 16, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb

d_screen_xys_list:
	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 2), "LW"
	XY_STRING (SCREEN_START_X + 18), (SCREEN_START_Y + 4), "A0030"
	XY_STRING (SCREEN_START_X + 18), (SCREEN_START_Y + 5), "A0031"
	XY_STRING (SCREEN_START_X + 18), (SCREEN_START_Y + 6), "A0032"
	XY_STRING (SCREEN_START_X + 18), (SCREEN_START_Y + 7), "A0033"
	XY_STRING (SCREEN_START_X + 18), (SCREEN_START_Y + 8), "A0034"
	XY_STRING (SCREEN_START_X + 18), (SCREEN_START_Y + 9), "A0035"
	XY_STRING (SCREEN_START_X + 18), (SCREEN_START_Y + 10), "A0036"
	XY_STRING (SCREEN_START_X + 18), (SCREEN_START_Y + 11), "A0037"
	XY_STRING (SCREEN_START_X + 18), (SCREEN_START_Y + 12), "A0038"
	XY_STRING (SCREEN_START_X + 18), (SCREEN_START_Y + 13), "A0039"
	XY_STRING (SCREEN_START_X + 18), (SCREEN_START_Y + 14), "A003A"
	XY_STRING (SCREEN_START_X + 18), (SCREEN_START_Y + 15), "A003B"
	XY_STRING (SCREEN_START_X + 18), (SCREEN_START_Y + 16), "A003C"
	XY_STRING (SCREEN_START_X + 18), (SCREEN_START_Y + 17), "A003D"
	XY_STRING (SCREEN_START_X + 18), (SCREEN_START_Y + 18), "A003E"
	XY_STRING (SCREEN_START_X + 18), (SCREEN_START_Y + 19), "A003F"
	XY_STRING_LIST_END

	section bss
	align 1

r_old_highlight:	dcb.l 1
r_mw_buffer:		dcb.b 16
