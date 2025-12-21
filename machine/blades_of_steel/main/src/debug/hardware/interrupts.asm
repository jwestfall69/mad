	include "cpu/6309/include/common.inc"
	include "cpu/6x09/include/handlers/memory_write.inc"

	global interrupts_debug

	section code

interrupts_debug:

		ldd	#$1f
		std	LAYER_A_TILE_PALETTE + $18

		ldy	#d_xys_screen_list
		jsr	print_xy_string_list

		ldd	#LAYER_A_TILE
		std	r_old_highlight

		clrd
		std	r_mw_buffer
		std	r_mw_buffer + 2
		std	r_nmi_count
		std	r_irq_count
		std	r_firq_count

		CPU_INTS_ENABLE

		ldx	#d_mw_settings
		jsr	memory_write_handler

		clr	$2600

		CPU_INTS_DISABLE

		rts

; params:
;  x = fix ram location to set highlight
; we are also on the hook for clearing out the
; previous highlight
highlight_cb:

		ldy	r_old_highlight
		lda	, y
		anda	#$1
		sta	, y

		lda	#$30
		lda	, x
		ora	#$30
		sta	, x
		stx	r_old_highlight
		rts

write_memory_cb:
		lda	r_mw_buffer
		sta	$2600

		SEEK_XY	(SCREEN_START_X + 6), (SCREEN_START_Y + 10)
		RSUB	print_hex_byte

		lda	r_mw_buffer + 1
		sta	$2f90
		SEEK_XY	(SCREEN_START_X + 6), (SCREEN_START_Y + 11)
		RSUB	print_hex_byte

		lda	r_mw_buffer + 2
		sta	$2f91
		SEEK_XY	(SCREEN_START_X + 6), (SCREEN_START_Y + 12)
		RSUB	print_hex_byte

		lda	r_mw_buffer + 3
		sta	$2f92
		SEEK_XY	(SCREEN_START_X + 6), (SCREEN_START_Y + 13)
		RSUB	print_hex_byte
		rts

loop_cb:
		SEEK_XY	(SCREEN_START_X + 6), (SCREEN_START_Y + 16)
		ldd	r_nmi_count
		RSUB	print_hex_word

		SEEK_XY	(SCREEN_START_X + 6), (SCREEN_START_Y + 17)
		ldd	r_firq_count
		RSUB	print_hex_word

		SEEK_XY	(SCREEN_START_X + 6), (SCREEN_START_Y + 18)
		ldd	r_irq_count
		RSUB	print_hex_word

		rts


	section data

d_mw_settings:		MW_SETTINGS 4, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb

d_xys_screen_list:
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 2), "ADDR"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 4), "2600"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 5), "2F90"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 6), "2F91"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 7), "2F92"
			XY_STRING SCREEN_START_X, (SCREEN_START_Y + 9), "LAST WRITTEN"
			XY_STRING SCREEN_START_X, (SCREEN_START_Y + 10), "2600"
			XY_STRING SCREEN_START_X, (SCREEN_START_Y + 11), "2F90"
			XY_STRING SCREEN_START_X, (SCREEN_START_Y + 12), "2F91"
			XY_STRING SCREEN_START_X, (SCREEN_START_Y + 13), "2F92"
			XY_STRING SCREEN_START_X, (SCREEN_START_Y + 16), " NMI"
			XY_STRING SCREEN_START_X, (SCREEN_START_Y + 17), "FIRQ"
			XY_STRING SCREEN_START_X, (SCREEN_START_Y + 18), " IRQ"
			XY_STRING_LIST_END

	section bss

r_mw_buffer:		dcb.b 4
r_old_highlight:	dcb.w 1
r_x_offset:		dcb.b 1
