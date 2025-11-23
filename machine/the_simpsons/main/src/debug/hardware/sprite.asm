	include "cpu/konami2/include/common.inc"
	include "cpu/6x09/include/handlers/memory_write.inc"

	global sprite_debug

	section code

sprite_debug:
		jsr	sprite_viewer_palette_setup

		lda	#CTRL_PALETTE_BANK
		sta	REG_CONTROL

		ldd	#$001f
		std	FIX_TILE_PALETTE + PALETTE_SIZE + $2

		clr	REG_CONTROL

		SEEK_XY	(SCREEN_START_X + 16), (SCREEN_START_Y + 14)
		ldy	#d_str_last_written
		RSUB	print_string

		ldd	#FIX_TILE
		std	r_old_highlight

		; setup initial values
		ldx	#r_mw_buffer
		ldd	#$8407		; enabled + aspect + size + zcode
		std	, x
		ldd	#$092d		; sprite
		std	2, x
		ldd	#$0120		; y offset
		std	4, x
		ldd	#$0120		; x offset
		std	6, x
		ldd	#$0040		; zoom
		std	8, x
		ldd	#$0040		; zoom
		std	10, x
		clrd
		std	12, x
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
		clr	-$2000, y

		lda	#$40
		sta	-$2000, x
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

		lda	#CTRL_SPRITE_BANK
		sta	REG_CONTROL
		puls	y,d

		puls	x
		std	, x++

		clr	REG_CONTROL

		pshs	x
		lda	#SCREEN_START_X + 22
		ldb	r_y_offset
		RSUB	screen_seek_xy

		ldd	, y++
		pshs	d,y
		RSUB	print_hex_word

		lda	#CTRL_SPRITE_BANK
		sta	REG_CONTROL
		puls	y,d

		puls	x
		std	, x++

		clr	REG_CONTROL

		inc	r_y_offset
		dec	r_scratch
		bne	.loop_next_word

		lda	#CTRL_SPRITE_RENDER
		sta	REG_CONTROL
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
