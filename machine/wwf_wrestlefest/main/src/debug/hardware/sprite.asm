	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/memory_write.inc"

	global sprite_debug

	section code

sprite_debug:
		jsr	sprite_viewer_palette_setup

		; highlight color on 2nd pallette
		move.w	#$1f, FIX_TILE_PALETTE + PALETTE_SIZE + $1e

		SEEK_XY SCREEN_START_X, (SCREEN_START_Y + 14)
		lea	d_str_last_written, a0
		RSUB	print_string

		move.l	#FIX_TILE, r_old_highlight

		move.l	#$7881181b, r_mw_buffer
		move.l	#$00c00000, r_mw_buffer + 4

		lea	d_mw_settings, a0
		jsr	memory_write_handler
		rts

; params:
;  a6 = video ram location for hightlight
; we are also on the hook for clearing out the
; previous highlight
highlight_cb:
		move.l	r_old_highlight, a0
		clr.b	(a0)

		; change tile to 2nd palette
		addq.l	#$2, a6
		move.w	#$10, (a6)
		move.l	a6, r_old_highlight
		rts

write_memory_cb:
		lea	r_mw_buffer, a0
		lea	SPRITE_RAM + 1, a1
		moveq	#$7, d3
		move.b	#SCREEN_START_X, d5

	; sprite ram is only lower byte
	.loop_next_byte:
		move.b	(a0)+, d4
		move.b	d4, (a1)

		move.b	d5, d0
		move.b	#SCREEN_START_Y + 16, d1
		RSUB	screen_seek_xy

		move.b	d4, d0
		RSUB	print_hex_byte

		addq.l	#$2, a1
		addq.b	#$3, d5
		dbra	d3, .loop_next_byte

		move.w	#$0, REG_SPRITE_COPY
		rts

loop_cb:
		rts

	section data
	align 1

d_mw_settings:		MW_SETTINGS 8, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb
d_str_last_written:	STRING "LAST WRITTEN"

	section bss
	align 1

r_old_highlight:	dcb.l 1
r_mw_buffer:		dcb.b 8
