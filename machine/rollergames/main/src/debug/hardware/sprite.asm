	include "cpu/konami2/include/common.inc"
	include "cpu/6x09/include/handlers/memory_write.inc"

	global sprite_debug

	section code

sprite_debug:
		jsr	sprite_viewer_palette_setup

		ldd	#$001f
		std	TILE_PALETTE + PALETTE_SIZE + $2

		SEEK_XY	(SCREEN_START_X + 16), (SCREEN_START_Y + 14)
		ldy	#d_str_last_written
		RSUB	print_string

		ldd	#TILE_RAM
		std	r_old_highlight

		; setup initial values
		ldx	#r_mw_buffer
		ldd	#$c502		; enabled + aspect + size + zcode
		std	, x
		ldd	#$0080		; sprite
		std	2, x
		ldd	#$0098		; y offset
		std	4, x
		ldd	#$0138		; x offset
		std	6, x
		ldd	#$0040		; zoom
		std	8, x
		clrd
		std	10, x
		std	12, x
		std	14, x


		ldx	#d_mw_settings
		jsr	memory_write_handler
		rts

; params:
;  x = fix ram location to set highlight
; we are also on the hook for clearing out the
; previous highlight
highlight_cb:

		ldy	r_old_highlight
		lda	$400, y
		anda	#$f
		sta	$400, y

		lda	$400, x
		ora	#$10
		sta	$400, x
		stx	r_old_highlight
		rts

write_memory_cb:
		ldx	#SPRITE_RAM
		ldy	#r_mw_buffer
		lda	#$4
		sta	r_scratch
		lda	#SCREEN_START_Y + 16
		sta	r_y_offset

	.loop_next_word:
		pshs	x
		lda	#SCREEN_START_X + 17
		ldb	r_y_offset
		RSUB	screen_seek_xy

		ldd	, y++
		pshs	d,y
		RSUB	print_hex_word
		puls	y,d

		puls	x
		std	, x++

		pshs	x
		lda	#SCREEN_START_X + 22
		ldb	r_y_offset
		RSUB	screen_seek_xy

		ldd	, y++
		pshs	d,y
		RSUB	print_hex_word

		puls	y,d

		puls	x
		std	, x++

		inc	r_y_offset
		dec	r_scratch
		bne	.loop_next_word

		clr	REG_SPRITE_REFRESH
		rts

loop_cb:
		rts


	section data

d_mw_settings:		MW_SETTINGS 16, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb
d_str_last_written:	STRING "LAST WRITTEN"

	section bss

r_mw_buffer:		dcb.b 16
r_old_highlight:	dcb.w 1
r_y_offset:		dcb.b 1
