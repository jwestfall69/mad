	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/memory_write.inc"

	global sprite_debug

	section code

sprite_debug:
		RS_SD_SETUP

		; purposely calling this after RS_SD_SETUP to take
		; advantage of it triggering a palette dma copy
		jsr	sprite_viewer_palette_setup

		SEEK_XY SCREEN_START_X, (SCREEN_START_Y + 14)
		lea	d_str_last_written, a0
		RSUB	print_string

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
		lea	r_mw_buffer, a0
		lea	OBJECT_RAM, a1
		moveq	#$7, d3
		move.b	#SCREEN_START_X, d5

		move.b	#$0, REG_OBJECT_RAM_BANK
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
		move.b	#$1, REG_OBJECT_RAM_BANK
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
