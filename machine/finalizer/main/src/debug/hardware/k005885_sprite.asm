	include "cpu/6809/include/common.inc"
	include "cpu/6x09/include/handlers/memory_write.inc"

	global k005885_sprite_debug

	section code

k005885_sprite_debug:
		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 13)
		ldy	#d_str_last_written
		RSUB	print_string

		ldd	#K005885_TILE_A
		std	r_old_highlight

		; setup initial values
		ldd	#$2701
		std	r_mw_buffer
		ldd	#$4020
		std	r_mw_buffer + 2
		lda	#$0
		sta	r_mw_buffer + 4

		ldx	#d_mw_settings
		jsr	memory_write_handler
		rts

; params:
;  x = fix ram location to set highlight
; we are also on the hook for clearing out the
; previous highlight
highlight_cb:
		ldy	r_old_highlight
		lda	#$0
		sta	-$400, y

		lda	#$3
		sta	-$400, x
		stx	r_old_highlight
		rts

write_memory_cb:
		lda	r_mw_buffer
		sta	K005885_SPRITE
		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 15)
		RSUB	print_hex_byte

		lda	r_mw_buffer + 1
		sta	K005885_SPRITE + 1
		SEEK_XY	(SCREEN_START_X + 3), (SCREEN_START_Y + 15)
		RSUB	print_hex_byte

		lda	r_mw_buffer + 2
		sta	K005885_SPRITE + 2
		SEEK_XY	(SCREEN_START_X + 6), (SCREEN_START_Y + 15)
		RSUB	print_hex_byte

		lda	r_mw_buffer + 3
		sta	K005885_SPRITE + 3
		SEEK_XY	(SCREEN_START_X + 9), (SCREEN_START_Y + 15)
		RSUB	print_hex_byte

		lda	r_mw_buffer + 4
		sta	K005885_SPRITE + 4
		SEEK_XY	(SCREEN_START_X + 12), (SCREEN_START_Y + 15)
		RSUB	print_hex_byte
		rts

loop_cb:
		rts


	section data

d_mw_settings:		MW_SETTINGS 5, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb
d_str_last_written:	STRING "LAST WRITTEN"

	section bss

r_mw_buffer:		dcb.b 5
r_old_highlight:	dcb.w 1
