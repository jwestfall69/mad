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

		move.l	#$ce660080, d0
		move.l	d0, r_mw_buffer
		move.l	#$00b00110, d0
		move.l	d0, r_mw_buffer + 4
		clr.b	r_mw_buffer + 8

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
		lea	r_mw_buffer, a0
		lea	SPRITE_RAM, a1
		moveq	#$7, d0

	; sprite ram can only be accessed via bytes
	.loop_next_byte:
		move.b	(a0)+, (a1)+
		dbra	d0, .loop_next_byte
		rts

loop_cb:
		rts

	section data
	align 1

	d_mw_settings:	MW_SETTINGS 8, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb

	section bss
	align 1

r_old_highlight:	dcb.l 1
r_mw_buffer:		dcb.b 8
