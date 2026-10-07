	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/memory_write.inc"

	global sprite_debug

	section code

sprite_debug:
		RS_SD_SETUP

		; purposely calling this after RS_SD_SETUP to take
		; advantage of it triggering a palette dma copy
		jsr	sprite_viewer_palette_setup

		move.l	#SCROLL1_RAM, r_old_highlight

		lea	d_mw_settings, a0
		jsr	memory_write_handler
		rts

; params:
;  a6 = video ram location for hightlight
; we are also on the hook for clearing out the
; previous highlight
highlight_cb:
		move.l	r_old_highlight, a0
		clr.w	(2, a0)

		; change tile to 2nd palette
		move.w	#$1, (2, a6)
		move.l	a6, r_old_highlight
		rts

write_memory_cb:
		move.b	#$0, REG_OBJECT_RAM_BANK

		lea	OBJECT_RAM, a0
		jsr	memory_write_generic_write

		move.b	#$1, REG_OBJECT_RAM_BANK
loop_cb:
		rts

	section data
	align 1

d_mw_settings:		MW_SETTINGS 8, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb

	section bss
	align 1

r_old_highlight:	dcb.l 1
r_mw_buffer:		dcb.b 8
