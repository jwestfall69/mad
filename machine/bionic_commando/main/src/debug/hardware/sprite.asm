	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/memory_write.inc"

	global sprite_debug

	section code

sprite_debug:
		jsr	sprite_viewer_palette_setup

		move.w	#$0014, r_mw_buffer
		move.w	#$0000, r_mw_buffer + 2
		move.w	#$0060, r_mw_buffer + 4
		move.w	#$00b0, r_mw_buffer + 6

		clr.b	r_sprite_dma_req

		CPU_INTS_ENABLE

		move.l	#d_palette_data, r_vblank_copy_src
		move.l	#FIX_TILE_PALETTE + FIX_TILE_PALETTE_SIZE, r_vblank_copy_dst
		move.w	#$4, r_vblank_copy_size
		jsr	wait_vblank_copy

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
		clr.b	($801, a0)

		; change tile to 2nd palette
		move.b	#$1, ($801, a6)
		move.l	a6, r_old_highlight
		rts

write_memory_cb:
		lea	SPRITE_RAM + $800, a0
		jsr	memory_write_generic_write
		move.b	#$1, r_sprite_dma_req
loop_cb:
		rts

	section data
	align 1

d_mw_settings:		MW_SETTINGS 8, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb

d_palette_data:
			dc.w	$0000, $f00f, $0000, $0000

	section bss
	align 1

r_old_highlight:	dcb.l 1
r_mw_buffer:		dcb.b 8
