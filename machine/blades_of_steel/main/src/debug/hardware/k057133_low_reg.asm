	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/6309/include/dsub.inc"
	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/xy_string.inc"
	include "cpu/6309/include/handlers/memory_write.inc"

	include "machine.inc"

	global k057133_low_reg_debug

	section code

k057133_low_reg_debug:
		; highlight color
		ldd	#$001f
		std	LAYER_A_TILE_PALETTE + $18

		ldy	#d_xys_screen_list
		RSUB	print_xy_string_list

		ldd	#LAYER_A_TILE
		std	r_old_highlight

		; setup initial values
		ldx	#r_mw_buffer
		clrd
		std	, x
		std	2, x
		std	4, x

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
		anda	#$1
		sta	, y

		lda	#$30
		lda	, x
		ora	#$30
		sta	, x
		stx	r_old_highlight
		rts

write_memory_cb:
		ldx	#K057133_BASE
		ldy	#r_mw_buffer
		lda	#$3
		sta	r_scratch
		lda	#SCREEN_START_X
		sta	r_x_offset

	.loop_next_word:
		pshs	x
		lda	r_x_offset
		ldb	#SCREEN_START_Y + 12
		RSUB	screen_seek_xy

		ldd	, y++
		pshs	d,y
		RSUB	print_hex_word
		puls	y,d

		puls	x
		std	, x++

		lda	r_x_offset
		adda	#$5
		sta	r_x_offset
		dec	r_scratch
		bne	.loop_next_word
		rts

loop_cb:

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 15)
		ldd	K057133_BASE
		RSUB	print_hex_word

		SEEK_XY	(SCREEN_START_X + 5), (SCREEN_START_Y + 15)
		ldd	K057133_BASE + $2
		RSUB	print_hex_word

		SEEK_XY	(SCREEN_START_X + 10), (SCREEN_START_Y + 15)
		ldd	K057133_BASE + $4
		RSUB	print_hex_word

		SEEK_XY	(SCREEN_START_X + 15), (SCREEN_START_Y + 15)
		lda	K057133_BASE + $6
		RSUB	print_hex_byte

		rts


	section data

d_mw_settings:		MW_SETTINGS 6, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb

d_xys_screen_list:
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 2), "ADDR"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 4), "2F80"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 5), "2F81"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 6), "2F82"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 7), "2F83"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 8), "2F84"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 9), "2F85"
			XY_STRING SCREEN_START_X, (SCREEN_START_Y + 11), "LAST WRITTEN"
			XY_STRING SCREEN_START_X, (SCREEN_START_Y + 14), "READING VALUES"
			XY_STRING_LIST_END

	section bss

r_mw_buffer:		dcb.b 6
r_old_highlight:	dcb.w 1
r_x_offset:		dcb.b 1
