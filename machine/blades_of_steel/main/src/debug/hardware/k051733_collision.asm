	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/6309/include/dsub.inc"
	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/xy_string.inc"
	include "cpu/6309/include/handlers/memory_write.inc"

	include "machine.inc"

	global k051733_collision_debug

	section code

k051733_collision_debug:
		; highlight color
		ldd	#$001f
		std	LAYER_A_TILE_PALETTE + $18

		ldy	#d_xys_screen_list
		RSUB	print_xy_string_list

		ldd	#LAYER_A_TILE
		std	r_old_highlight

		; setup initial values
		ldx	#r_mw_buffer
		lda	#$0
		ldw	#11
		PSUB	memory_fill

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
		ldx	#K051733_BASE + $6
		ldy	#r_mw_buffer
		lda	#$a
		sta	r_scratch
		lda	#SCREEN_START_Y + 4
		sta	r_y_offset

	.loop_next_word:
		pshs	x
		lda	#SCREEN_START_X + 20
		ldb	r_y_offset
		RSUB	screen_seek_xy

		lda	, y+
		pshs	a,y
		RSUB	print_hex_byte
		puls	y,a

		puls	x
		std	, x+

		inc	r_y_offset
		dec	r_scratch
		bne	.loop_next_word

		lda	#SCREEN_START_X + 20
		ldb	r_y_offset
		RSUB	screen_seek_xy

		lda	,y
		sta	K051733_BASE + $13
		RSUB	print_hex_byte

		SEEK_XY	(SCREEN_START_X + 5), (SCREEN_START_Y + 18)
		lda	K051733_BASE + $7
		RSUB	print_hex_byte

loop_cb:
		rts


	section data

d_mw_settings:		MW_SETTINGS 11, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb

d_xys_screen_list:
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 2), "ADDR  LW"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 4), "2F86"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 5), "2F87"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 6), "2F88"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 7), "2F89"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 8), "2F8A"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 9), "2F8B"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 10), "2F8C"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 11), "2F8D"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 12), "2F8E"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 13), "2F8F"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 14), "2F93"
			XY_STRING SCREEN_START_X, (SCREEN_START_Y + 16), "READ VALUE"
			XY_STRING SCREEN_START_X, (SCREEN_START_Y + 18), "2F87"
			XY_STRING_LIST_END

	section bss

r_mw_buffer:		dcb.b 11
r_old_highlight:	dcb.w 1
r_y_offset:		dcb.b 1
