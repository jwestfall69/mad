	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/memory_write.inc"

	global fix_tile_debug

	section code

fix_tile_debug:
		jsr	fix_tile_viewer_palette_setup

		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list

		move.w	#$3401, r_mw_buffer	; tile + tile_attr

		CPU_INTS_ENABLE

		move.l	#d_palette_data, r_vblank_copy_src
		move.l	#FIX_TILE_PALETTE + (2 * FIX_TILE_PALETTE_SIZE) + 2, r_vblank_copy_dst
		move.w	#$1, r_vblank_copy_size
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

		; change tile to 3nd palette
		move.b	#$2, ($801, a6)
		move.l	a6, r_old_highlight
		rts

write_memory_cb:
		lea	r_mw_buffer, a0
		lea	FIX_TILE + $3d0, a1

		move.b	(a0), d0
		move.b	d0, (1, a1)
		SEEK_XY	(SCREEN_START_X + 10), (SCREEN_START_Y + 16)
		RSUB	print_hex_byte

		move.b	(1, a0), d0
		move.b	d0, ($801, a1)
		SEEK_XY	(SCREEN_START_X + 10), (SCREEN_START_Y + 17)
		RSUB	print_hex_byte
		rts

loop_cb:
		rts

	section data
	align 1

d_mw_settings:		MW_SETTINGS 2, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb

d_palette_data:
			dc.w	$f00f

d_screen_xys_list:
	XY_STRING (SCREEN_START_X + 13), (SCREEN_START_Y + 4), "TILE NUM"
	XY_STRING (SCREEN_START_X + 13), (SCREEN_START_Y + 5), "TILE ATTR"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 14), "LAST WRITTEN"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 16), "TILE NUM"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 17), "TILE ATTR"
	XY_STRING_LIST_END

	section bss
	align 1

r_old_highlight:	dcb.l 1
r_mw_buffer:		dcb.b 2
