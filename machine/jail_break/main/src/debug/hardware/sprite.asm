	include "cpu/6809/include/common.inc"
	include "cpu/6x09/include/handlers/memory_write.inc"

	global sprite_debug

	section code

sprite_debug:
		ldy	#d_screen_xys_list
		jsr	print_xy_string_list

		ldd	#TILE_RAM
		std	r_old_highlight

		; setup initial values
		ldd	#$d500
		std	r_mw_buffer
		ldd	#$b050
		std	r_mw_buffer + 2

		lda	#$42
		sta	r_mw_buffer + 4

		ldx	#d_mw_settings
		jsr	memory_write_handler

		lda	#$42
		sta	$2043
		rts

; params:
;  x = fix ram location to set highlight
; we are also on the hook for clearing out the
; previous highlight
highlight_cb:
		ldy	r_old_highlight
		lda	#$0
		sta	-$800, y

		lda	#$5
		sta	-$800, x
		stx	r_old_highlight
		rts

write_memory_cb:
		lda	r_mw_buffer
		sta	SPRITE_RAM

		inca
		sta	SPRITE_RAM + $100
		deca

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 15)
		RSUB	print_hex_byte

		lda	r_mw_buffer + 1
		sta	SPRITE_RAM + 1
		sta	SPRITE_RAM + $100 + 1
		SEEK_XY	(SCREEN_START_X + 3), (SCREEN_START_Y + 15)
		RSUB	print_hex_byte

		lda	r_mw_buffer + 2
		sta	SPRITE_RAM + 2

		adda	#$10
		sta	SPRITE_RAM + $100 + 2
		suba	#$10

		SEEK_XY	(SCREEN_START_X + 6), (SCREEN_START_Y + 15)
		RSUB	print_hex_byte

		lda	r_mw_buffer + 3
		sta	SPRITE_RAM + 3
		sta	SPRITE_RAM + $100 + 3
		SEEK_XY	(SCREEN_START_X + 9), (SCREEN_START_Y + 15)
		RSUB	print_hex_byte

		lda	r_mw_buffer + 4
		sta	$2043
		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 17)
		RSUB	print_hex_byte
		rts

loop_cb:
		rts


	section data

d_mw_settings:		MW_SETTINGS 5, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb

d_screen_xys_list:
	XY_STRING (SCREEN_START_X + 13), (SCREEN_START_Y + 8), "REG 2043"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 13), "LAST WRITTEN"
	XY_STRING_LIST_END

	section bss

r_mw_buffer:		dcb.b 5
r_old_highlight:	dcb.w 1
