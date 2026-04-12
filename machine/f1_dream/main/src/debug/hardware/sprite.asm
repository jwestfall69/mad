	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/memory_write.inc"

	global sprite_debug

	section code

sprite_debug:
		jsr	sprite_viewer_palette_setup

		SEEK_XY SCREEN_START_X, (SCREEN_START_Y + 14)
		lea	d_str_last_written, a0
		RSUB	print_string

		move.w	#$0f00, FIX_TILE_PALETTE + FIX_TILE_PALETTE_SIZE
		move.w	#$0f00, FIX_TILE_PALETTE + FIX_TILE_PALETTE_SIZE + 4

		move.l	#FIX_TILE_RAM, r_old_highlight

		move.w	#$0279, r_mw_buffer
		move.w	#$0000, r_mw_buffer + 2
		move.w	#$0090, r_mw_buffer + 4
		move.w	#$00b0, r_mw_buffer + 6

		clr.b	r_sprite_dma_req

		CPU_INTS_ENABLE

		lea	d_mw_settings, a0
		jsr	memory_write_handler

		CPU_INTS_DISABLE

		jsr	sprite_ram_clear
		rts

; params:
;  a6 = video ram location for hightlight
; we are also on the hook for clearing out the
; previous highlight
highlight_cb:
		move.l	r_old_highlight, a0
		clr.b	(a0)

		; change tile to 2nd palette
		move.b	#$1, (a6)
		move.l	a6, r_old_highlight
		rts

write_memory_cb:
		lea	r_mw_buffer, a0
		moveq	#$7, d3
		move.b	#SCREEN_START_X, d5

	.loop_next_byte:
		move.b	(a0)+, d4
		move.b	d4, (a1)+

		move.b	d5, d0
		move.b	#SCREEN_START_Y + 16, d1
		RSUB	screen_seek_xy

		move.b	d4, d0
		RSUB	print_hex_byte

		addq.b	#$3, d5
		dbra	d3, .loop_next_byte

		move.b	#$1, r_sprite_dma_req
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
