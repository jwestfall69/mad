	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/memory_write.inc"

	global sprite_debug

	section code

sprite_debug:
		jsr	sprite_viewer_palette_setup

		; highlight color on 2nd pallette
		move.b	#$1f, FIX_TILE_PALETTE + PALETTE_SIZE + $7
		move.b	#$1f, FIX_TILE_PALETTE + PALETTE_SIZE + $b

		move.l	#FIX_TILE, r_old_highlight

		move.l	#$ce660080, r_mw_buffer
		move.l	#$00b00110, r_mw_buffer + 4

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
		move.b	#$20, (a6)
		move.l	a6, r_old_highlight
		rts

write_memory_cb:
		lea	SPRITE_RAM, a0
		jsr	memory_write_generic_write
loop_cb:
		rts

	section data
	align 1

d_mw_settings:		MW_SETTINGS 8, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb

	section bss
	align 1

r_old_highlight:	dcb.l 1
r_mw_buffer:		dcb.b 8
