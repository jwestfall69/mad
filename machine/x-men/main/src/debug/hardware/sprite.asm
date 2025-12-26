	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/memory_write.inc"

	global sprite_debug

	section code

sprite_debug:
		jsr	sprite_viewer_palette_setup

		SEEK_XY	(SCREEN_START_X + 14), (SCREEN_START_Y + 2)
		lea	d_str_lw, a0
		RSUB	print_string

		; highlight color on 2nd pallette
		move.w	#$1f, FIX_TILE_PALETTE + PALETTE_SIZE + $10
		move.w	#$1f, FIX_TILE_PALETTE + PALETTE_SIZE + $12
		move.l	#FIX_TILE_PALETTE, r_old_highlight

		; initial values
		move.l	#$85010040, r_mw_buffer
		move.l	#$110000e0, r_mw_buffer + 4
		move.l	#$00400040, r_mw_buffer + 8
		move.l	#$00000000, r_mw_buffer + 12

		;move.b	#$10, $108025	; enable sprite dma
		lea	d_mw_settings, a0
		jsr	memory_write_handler
		;move.b	#$0, $108025
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
		moveq	#$f, d5
		moveq	#(SCREEN_START_Y + 4), d4
		lea	r_mw_buffer, a0
		lea	SPRITE_RAM, a1

	.loop_next_byte:
		moveq	#(SCREEN_START_X + 14), d0
		move.w	d4, d1
		RSUB	screen_seek_xy
		move.b	(a0)+, d0
		move.b	d0, (a1)+
		RSUB	print_hex_byte
		addq.b	#$1, d4
		dbra	d5, .loop_next_byte
		rts

loop_cb:
		rts

	section data
	align 1

d_mw_settings:		MW_SETTINGS 16, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb
d_str_lw:		STRING "LW"

	section bss
	align 1

r_old_highlight:	dcb.l 1
r_mw_buffer:		dcb.b 16
