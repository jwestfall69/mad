	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/memory_write.inc"

	global fc0000_debug

	section code

fc0000_debug:
		jsr	bg_tile_viewer_palette_setup
		jsr	fg_tile_viewer_palette_setup
		jsr	fix_tile_viewer_palette_setup
		jsr	sprite_viewer_palette_setup

		SEEK_XY SCREEN_START_X, (SCREEN_START_Y + 14)
		lea	d_str_last_written, a0
		RSUB	print_string

		move.w	#$f00f, FIX_TILE_PALETTE + (FIX_TILE_PALETTE_SIZE * 2) + 2
		move.w	#$f00f, FIX_TILE_PALETTE + (FIX_TILE_PALETTE_SIZE * 2) + 4

		move.l	#FIX_TILE_RAM, r_old_highlight

		move.w	#$0000, r_mw_buffer
		move.w	#$0000, r_mw_buffer + 2
		move.b	#$00, r_mw_buffer + 4

		move.w	#$10d0, FIX_TILE_RAM + $342
		move.w	#$0070, FG_TILE_RAM + $440
		move.w	#$0071, BG_TILE_RAM + $540

		move.l	#$00b70000, SPRITE_RAM
		move.l	#$00700100, SPRITE_RAM + 4
		move.w	#$0, REG_SPRITE_COPY_REQUEST

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

		; change tile to 3nd palette
		move.b	#$20, (a6)
		move.l	a6, r_old_highlight
		rts

write_memory_cb:
		move.l	r_mw_buffer, $fc0000
		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 15)
		move.w	r_mw_buffer, d0
		RSUB	print_hex_word

		SEEK_XY	(SCREEN_START_X + 5), (SCREEN_START_Y + 15)
		move.w	r_mw_buffer + 2, d0
		RSUB	print_hex_word


		tst.b	r_mw_buffer + 4
		beq	.skip_sprite_copy_request
		move.w	#$0, REG_SPRITE_COPY_REQUEST
	.skip_sprite_copy_request:
		rts

loop_cb:
		rts

	section data
	align 1

d_mw_settings:		MW_SETTINGS 5, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb
d_str_last_written:	STRING "LAST WRITTEN"

	section bss
	align 1

r_old_highlight:	dcb.l 1
r_mw_buffer:		dcb.b 5
