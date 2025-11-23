	include "cpu/konami2/include/common.inc"
	include "cpu/6x09/include/handlers/memory_write.inc"

	global irq_debug

	section code

irq_debug:

		ldd	#$0
		std	r_irq_count
		std	r_firq_count

		lda	#(CTRL_PALETTE_BANK | CTRL_SPRITE_BANK)
		sta	REG_CONTROL

		; highlight color
		ldd	#$001f
		std	FIX_TILE_PALETTE + PALETTE_SIZE + $2

		ldx	#SPRITE_RAM + $700
		ldd	#$8407
		std	, x
		ldd	#$092d
		std	2, x
		ldd	#$00ff
		std	4, x
		ldd	#$00ff
		std	6, x
		ldd	#$0040
		std	8, x
		std	10, x
		clrd
		std	12, x
		std	14, x

		lda	#CTRL_SPRITE_RENDER
		sta	REG_CONTROL

		ldy	#d_xys_screen_list
		jsr	print_xy_string_list

		INTS_ENABLE

		ldd	#FIX_TILE
		std	r_old_highlight

		; setup initial values
		ldx	#r_mw_buffer
		ldd	#$0
		std	r_mw_buffer
		std	r_mw_buffer + 2
		std	r_mw_buffer + 4
		std	r_mw_buffer + 6
		std	r_mw_buffer + 8

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
		sta	$1fa0

		SEEK_XY	(SCREEN_START_X + 20), (SCREEN_START_Y + 5)
		lda	r_mw_buffer + 1
		RSUB	print_hex_byte
		lda	r_mw_buffer + 1
		sta	$1fa1

		SEEK_XY	(SCREEN_START_X + 20), (SCREEN_START_Y + 6)
		lda	r_mw_buffer + 2
		RSUB	print_hex_byte
		lda	r_mw_buffer + 2
		sta	$1fa2

		SEEK_XY	(SCREEN_START_X + 20), (SCREEN_START_Y + 7)
		lda	r_mw_buffer + 3
		RSUB	print_hex_byte
		lda	r_mw_buffer + 3
		sta	$1fa3

		SEEK_XY	(SCREEN_START_X + 20), (SCREEN_START_Y + 8)
		lda	r_mw_buffer + 4
		RSUB	print_hex_byte
		lda	r_mw_buffer + 4
		sta	$1fa4

		SEEK_XY	(SCREEN_START_X + 20), (SCREEN_START_Y + 9)
		lda	r_mw_buffer + 5
		RSUB	print_hex_byte
		lda	r_mw_buffer + 5
		sta	$1fa5

		SEEK_XY	(SCREEN_START_X + 20), (SCREEN_START_Y + 10)
		lda	r_mw_buffer + 6
		RSUB	print_hex_byte
		lda	r_mw_buffer + 6
		sta	$1fa6

		SEEK_XY	(SCREEN_START_X + 20), (SCREEN_START_Y + 11)
		lda	r_mw_buffer + 7
		RSUB	print_hex_byte
		lda	r_mw_buffer + 7
		sta	$1fa7

		SEEK_XY	(SCREEN_START_X + 20), (SCREEN_START_Y + 12)
		lda	r_mw_buffer + 8
		RSUB	print_hex_byte
		lda	r_mw_buffer + 8
		sta	$1fc2

		SEEK_XY	(SCREEN_START_X + 20), (SCREEN_START_Y + 13)
		lda	r_mw_buffer + 9
		RSUB	print_hex_byte
		lda	r_mw_buffer + 9
		sta	$1d00
		rts

loop_cb:
		SEEK_XY	(SCREEN_START_X + 6), (SCREEN_START_Y + 15)
		ldd	r_irq_count
		RSUB	print_hex_word

		SEEK_XY	(SCREEN_START_X + 6), (SCREEN_START_Y + 16)
		ldd	r_firq_count
		RSUB	print_hex_word
		rts


	section data

d_mw_settings:		MW_SETTINGS 10, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb

d_xys_screen_list:
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 2), "ADDR  LW"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 4), "1FA0"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 5), "1FA1"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 6), "1FA2"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 7), "1FA3"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 8), "1FA4"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 9), "1FA5"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 10), "1FA6"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 11), "1FA7"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 12), "1FC2"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 13), "1D00"
			XY_STRING SCREEN_START_X, (SCREEN_START_Y + 15), "IRQ"
			XY_STRING SCREEN_START_X, (SCREEN_START_Y + 16), "FIRQ"
			XY_STRING_LIST_END

	section bss

r_mw_buffer:		dcb.b 10
r_old_highlight:	dcb.w 1
