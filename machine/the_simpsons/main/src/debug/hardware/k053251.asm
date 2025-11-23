	include "cpu/konami2/include/common.inc"
	include "cpu/6x09/include/handlers/memory_write.inc"

	global k053251_debug

	section code

k053251_debug:

		ldd	#$0
		std	r_irq_count
		std	r_firq_count

		lda	#CTRL_PALETTE_BANK
		sta	REG_CONTROL

		; highlight color
		ldd	#$001f
		std	FIX_TILE_PALETTE + PALETTE_SIZE + $2

		clr	REG_CONTROL

		jsr	sprite_viewer_palette_setup

		ldy	#d_xys_screen_list
		jsr	print_xy_string_list

		ldd	#FIX_TILE
		std	r_old_highlight

		; setup initial values
		ldx	#r_mw_buffer
		ldd	#$3f00
		std	r_mw_buffer

		ldd	#$0428
		std	r_mw_buffer + 2

		ldd	#$1800
		std	r_mw_buffer + 4

		ldd	#$1727
		std	r_mw_buffer + 6

		ldd	#$3713
		std	r_mw_buffer + 8

		ldd	#$2c00
		std	r_mw_buffer + 10

		ldd	#$0500
		std	r_mw_buffer + 12

		ldd	#$000
		std	r_mw_buffer + 14

		ldx	#d_mw_settings
		jsr	memory_write_handler
		rts

; params:
;  x = fix ram location to set highlight
; we are also on the hook for clearing out the
; previous highlight
highlight_cb:

		ldy	r_old_highlight
		clr	-$2000, y

		lda	#$40
		sta	-$2000, x
		stx	r_old_highlight
		rts

write_memory_cb:
		SEEK_XY	(SCREEN_START_X + 20), (SCREEN_START_Y + 4)
		lda	r_mw_buffer
		RSUB	print_hex_byte
		lda	r_mw_buffer
		sta	$1fb0

		SEEK_XY	(SCREEN_START_X + 20), (SCREEN_START_Y + 5)
		lda	r_mw_buffer + 1
		RSUB	print_hex_byte
		lda	r_mw_buffer + 1
		sta	$1fb1

		SEEK_XY	(SCREEN_START_X + 20), (SCREEN_START_Y + 6)
		lda	r_mw_buffer + 2
		RSUB	print_hex_byte
		lda	r_mw_buffer + 2
		sta	$1fb2

		SEEK_XY	(SCREEN_START_X + 20), (SCREEN_START_Y + 7)
		lda	r_mw_buffer + 3
		RSUB	print_hex_byte
		lda	r_mw_buffer + 3
		sta	$1fb3

		SEEK_XY	(SCREEN_START_X + 20), (SCREEN_START_Y + 8)
		lda	r_mw_buffer + 4
		RSUB	print_hex_byte
		lda	r_mw_buffer + 4
		sta	$1fb4

		SEEK_XY	(SCREEN_START_X + 20), (SCREEN_START_Y + 9)
		lda	r_mw_buffer + 5
		RSUB	print_hex_byte
		lda	r_mw_buffer + 5
		sta	$1fb5

		SEEK_XY	(SCREEN_START_X + 20), (SCREEN_START_Y + 10)
		lda	r_mw_buffer + 6
		RSUB	print_hex_byte
		lda	r_mw_buffer + 6
		sta	$1fb6

		SEEK_XY	(SCREEN_START_X + 20), (SCREEN_START_Y + 11)
		lda	r_mw_buffer + 7
		RSUB	print_hex_byte
		lda	r_mw_buffer + 7
		sta	$1fb7

		SEEK_XY	(SCREEN_START_X + 20), (SCREEN_START_Y + 12)
		lda	r_mw_buffer + 8
		RSUB	print_hex_byte
		lda	r_mw_buffer + 8
		sta	$1fb8

		SEEK_XY	(SCREEN_START_X + 20), (SCREEN_START_Y + 13)
		lda	r_mw_buffer + 9
		RSUB	print_hex_byte
		lda	r_mw_buffer + 9
		sta	$1fb9

		SEEK_XY	(SCREEN_START_X + 20), (SCREEN_START_Y + 14)
		lda	r_mw_buffer + 10
		RSUB	print_hex_byte
		lda	r_mw_buffer + 10
		sta	$1fba

		SEEK_XY	(SCREEN_START_X + 20), (SCREEN_START_Y + 15)
		lda	r_mw_buffer + 11
		RSUB	print_hex_byte
		lda	r_mw_buffer + 11
		sta	$1fbb

		SEEK_XY	(SCREEN_START_X + 20), (SCREEN_START_Y + 16)
		lda	r_mw_buffer + 12
		RSUB	print_hex_byte
		lda	r_mw_buffer + 12
		sta	$1fbc

		SEEK_XY	(SCREEN_START_X + 20), (SCREEN_START_Y + 17)
		lda	r_mw_buffer + 13
		RSUB	print_hex_byte
		lda	r_mw_buffer + 13
		sta	$1fbd

		SEEK_XY	(SCREEN_START_X + 20), (SCREEN_START_Y + 18)
		lda	r_mw_buffer + 14
		RSUB	print_hex_byte
		lda	r_mw_buffer + 14
		sta	$1fbe

		SEEK_XY	(SCREEN_START_X + 20), (SCREEN_START_Y + 19)
		lda	r_mw_buffer + 15
		RSUB	print_hex_byte
		lda	r_mw_buffer + 15
		sta	$1fbf



		rts

loop_cb:
		rts


	section data

d_mw_settings:		MW_SETTINGS 16, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb

d_xys_screen_list:
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 2), "ADDR  LW"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 4), "1FB0"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 5), "1FB1"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 6), "1FB2"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 7), "1FB3"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 8), "1FB4"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 9), "1FB5"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 10), "1FB6"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 11), "1FB7"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 12), "1FB8"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 13), "1FB9"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 14), "1FBA"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 15), "1FBB"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 16), "1FBC"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 17), "1FBD"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 18), "1FBE"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 19), "1FBF"
			XY_STRING_LIST_END

	section bss

r_mw_buffer:		dcb.b 16
r_old_highlight:	dcb.w 1
