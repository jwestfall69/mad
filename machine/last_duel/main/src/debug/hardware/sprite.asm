	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/memory_write.inc"

	global sprite_debug

	section code

sprite_debug:
		jsr	sprite_viewer_palette_setup

		move.w	#$f00f, FIX_TILE_PALETTE + FIX_TILE_PALETTE_SIZE + 2
		move.w	#$f00f, FIX_TILE_PALETTE + FIX_TILE_PALETTE_SIZE + 4

		move.l	#FIX_TILE_RAM, r_old_highlight

		move.w	#$00a3, r_mw_buffer
		move.w	#$0000, r_mw_buffer + 2
		move.w	#$0070, r_mw_buffer + 4
		move.w	#$00c0, r_mw_buffer + 6

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
		move.b	#$10, (a6)
		move.l	a6, r_old_highlight
		rts

write_memory_cb:
		lea	SPRITE_RAM + $800, a0
		jsr	memory_write_generic_write

		move.w	#$0, REG_SPRITE_COPY_REQUEST
loop_cb:
		rts

	section data
	align 1

d_mw_settings:		MW_SETTINGS 8, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb

	section bss
	align 1

r_old_highlight:	dcb.l 1
r_mw_buffer:		dcb.b 8
