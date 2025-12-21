	include "cpu/6809/include/common.inc"
	include "cpu/6x09/include/handlers/memory_write.inc"

	global sprite_debug

	section code

sprite_debug:
		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 13)
		ldy	#d_str_last_written
		RSUB	print_string

		ldd	#FG_RAM + $400
		std	r_old_highlight

		; setup initial values
		ldd	#$0902
		std	r_mw_buffer
		ldd	#$a040
		std	r_mw_buffer + 2

		ldx	#d_mw_settings
		jsr	memory_write_handler
		rts

; params:
;  x = fix ram location to set highlight
; we are also on the hook for clearing out the
; previous highlight
highlight_cb:
		ldy	r_old_highlight
		lda	, y
		cmpa	#$12
		bgt	.skip_remove_highlight
		adda	#$a
		sta	, y

	.skip_remove_highlight:
		lda	, x
		cmpa	#$12
		blt	.skip_add_highlight
		suba	#$a
		sta	, x

	.skip_add_highlight:
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

	section bss

r_mw_buffer:		dcb.b 4
r_old_highlight:	dcb.w 1
r_x_offset:		dcb.b 1
