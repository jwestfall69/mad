	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/memory_write.inc"

	global sprite_debug

	section code

sprite_debug:
		jsr	sprite_viewer_palette_setup

		SEEK_XY	(SCREEN_START_X + 14), (SCREEN_START_Y + 2)
		lea	d_str_lw, a0
		RSUB	print_string

		SEEK_XY	(SCREEN_START_X + 14), (SCREEN_START_Y + 12)
		lea	d_str_write_a0048, a0
		RSUB	print_string

		; highlight color on 2nd pallette
		move.w	#$1f, TXT_PALETTE + PALETTE_SIZE + $16
		move.l	#TXT_PALETTE, r_old_highlight

		; initial values
		move.l	#$44001040, r_mw_buffer
		move.l	#$007000a0, r_mw_buffer + 4
		move.b	#$1, r_mw_buffer + 8		; write to a0048 by default (sprite dma)

		lea	d_mw_settings, a0
		jsr	memory_write_handler
		rts

; params:
;  a6 = video ram location for hightlight
; we are also on the hook for clearing out the
; previous highlight
highlight_cb:
		move.l	r_old_highlight, a0
		move.b	#$0, (a0)

		move.b	#$10, (a6)
		move.l	a6, r_old_highlight
		rts

write_memory_cb:
		moveq	#$7, d5
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


		move.b	r_mw_buffer + 8, d0
		beq	.no_sprite_copy_req
		move.b	#$1, r_sprite_copy_req
	.no_sprite_copy_req:
		rts

loop_cb:
		rts

	section data
	align 1

d_mw_settings:		MW_SETTINGS 9, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb
d_str_lw:		STRING "LW"
d_str_write_a0048:	STRING "WRITE A0048?",

	section bss
	align 1

r_old_highlight:	dcb.l 1
r_mw_buffer:		dcb.b 9
