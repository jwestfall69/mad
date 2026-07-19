	include "cpu/6809/include/common.inc"
	include "cpu/6x09/include/handlers/memory_write.inc"

	global sprite_debug

	section code

sprite_debug:
		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 13)
		ldy	#d_str_last_written
		RSUB	print_string

		jsr	sprite_viewer_palette_setup

		; setup highlight color on 2nd fg palette
		CPU_INTS_ENABLE

		ldd	#d_palette_data
		std	r_vblank_copy_src
		ldd	#FG_TILE_PALETTE + FG_TILE_PALETTE_SIZE
		std	r_vblank_copy_dst
		ldd	#FG_TILE_PALETTE_SIZE
		std	r_vblank_copy_size

		jsr	wait_vblank_copy

		CPU_INTS_DISABLE

		ldd	#FG_TILE_RAM
		std	r_old_highlight

		; setup initial values
		ldd	#$0801
		std	r_mw_buffer
		ldd	#$c060
		std	r_mw_buffer + 2

		ldx	#d_mw_settings
		jsr	memory_write_handler

		ldd	#$0
		std	SPRITE_RAM
		std	SPRITE_RAM + 2
		rts

; params:
;  x = fix ram location to set highlight
; we are also on the hook for clearing out the
; previous highlight
highlight_cb:

		ldy	r_old_highlight
		lda	#$0
		sta	,y

		lda	#$4
		sta	,x
		stx	r_old_highlight
		rts

write_memory_cb:
		lda	r_mw_buffer
		sta	SPRITE_RAM
		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 15)
		RSUB	print_hex_byte

		lda	r_mw_buffer + 1
		sta	SPRITE_RAM + 1
		SEEK_XY	(SCREEN_START_X + 3), (SCREEN_START_Y + 15)
		RSUB	print_hex_byte

		lda	r_mw_buffer + 2
		sta	SPRITE_RAM + 2
		SEEK_XY	(SCREEN_START_X + 6), (SCREEN_START_Y + 15)
		RSUB	print_hex_byte

		lda	r_mw_buffer + 3
		sta	SPRITE_RAM + 3
		SEEK_XY	(SCREEN_START_X + 9), (SCREEN_START_Y + 15)
		RSUB	print_hex_byte
		rts

loop_cb:
		rts


	section data

d_mw_settings:		MW_SETTINGS 4, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb
d_str_last_written:	STRING "LAST WRITTEN"

d_palette_data:
	dc.w		$0000, $0000, $f000, $0000
	section bss

r_mw_buffer:		dcb.b 4
r_old_highlight:	dcb.w 1
r_x_offset:		dcb.b 1
