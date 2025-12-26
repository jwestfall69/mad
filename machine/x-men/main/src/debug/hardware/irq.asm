	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/memory_write.inc"

	global irq_debug

	section code

irq_debug:
		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list

		; highlight color on 2nd pallette
		move.w	#$1f, FIX_TILE_PALETTE + PALETTE_SIZE + $10
		move.w	#$1f, FIX_TILE_PALETTE + PALETTE_SIZE + $12
		move.l	#FIX_TILE_PALETTE, r_old_highlight

		move.w	#$0, r_irq3_count
		move.w	#$0, r_irq5_count

		; initial values
		move.w	#$0, r_mw_buffer

		CPU_INTS_ENABLE

		lea	d_mw_settings, a0
		jsr	memory_write_handler

		CPU_INTS_DISABLE
		rts

; params:
;  a6 = video ram location for hightlight
; we are also on the hook for clearing out the
; previous highlight
highlight_cb:
		move.l	r_old_highlight, a0
		move.w	#$0, (-$4000, a0)

		; change tile to 2nd palette
		move.w	#$10, (-$4000, a6)
		move.l	a6, r_old_highlight
		rts

write_memory_cb:
		SEEK_XY (SCREEN_START_X + 22), (SCREEN_START_Y + 4)
		move.b	r_mw_buffer, d0
		RSUB	print_hex_byte
		move.b	r_mw_buffer, $108001

		SEEK_XY (SCREEN_START_X + 22), (SCREEN_START_Y + 5)
		move.b	r_mw_buffer + 1, d0
		RSUB	print_hex_byte
		move.b	r_mw_buffer + 1, $108025

		SEEK_XY (SCREEN_START_X + 22), (SCREEN_START_Y + 6)
		move.b	r_mw_buffer + 2, d0
		RSUB	print_hex_byte
		move.b	r_mw_buffer + 2, $18fa01
		rts

loop_cb:
		SEEK_XY	(SCREEN_START_X + 6), (SCREEN_START_Y + 10)
		move.w	r_irq3_count, d0
		RSUB	print_hex_word

		SEEK_XY	(SCREEN_START_X + 6), (SCREEN_START_Y + 11)
		move.w	r_irq5_count, d0
		RSUB	print_hex_word
		rts

	section data
	align 1

d_mw_settings:		MW_SETTINGS 3, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb

d_screen_xys_list:
	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 2), " ADDR   LW"
	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 4), "108001"
	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 5), "108025"
	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 6), "18FA01"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 10), "IRQ3"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 11), "IRQ5"
	XY_STRING_LIST_END

	section bss
	align 1

r_old_highlight:	dcb.l 1
r_mw_buffer:		dcb.b 3
