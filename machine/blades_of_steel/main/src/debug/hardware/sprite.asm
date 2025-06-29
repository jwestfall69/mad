	include "global/include/macros.inc"
	include "global/include/screen.inc"

	include "cpu/6x09/include/macros.inc"
	include "cpu/6x09/include/handlers/memory_write.inc"

	include "cpu/6309/include/dsub.inc"

	include "machine.inc"

	global sprite_debug

	section code

sprite_debug:
		jsr	sprite_viewer_palette_setup

		ldd	#$1f
		std	LAYER_A_TILE_PALETTE + $18

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 13)
		ldy	#d_str_last_written
		RSUB	print_string

		ldd	#LAYER_A_TILE
		std	r_old_highlight

		; setup initial values
		ldx	#r_mw_buffer
		ldd	#$d0b4		; y offset + sprite code
		std	, x
		ldd	#$3a		; x off set
		std	2, x
		ldd	#$4080		; size + zoom
		std	4, x
		clrd			; unused
		std	6, x

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
		ldx	#SPRITE_RAM
		ldy	#r_mw_buffer
		lda	#$4
		sta	r_scratch
		lda	#SCREEN_START_X
		sta	r_x_offset

	.loop_next_word:
		pshs	x
		lda	r_x_offset
		ldb	#SCREEN_START_Y + 15
		RSUB	screen_seek_xy

		ldd	, y++
		pshs	d
		RSUB	print_hex_word
		puls	d

		puls	x
		std	, x++

		lda	r_x_offset
		adda	#$5
		sta	r_x_offset
		dec	r_scratch
		bne	.loop_next_word
		rts

loop_cb:
		rts


	section data

d_mw_settings:		MW_SETTINGS 8, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb
d_str_last_written:	STRING "LAST WRITTEN"

	section bss

r_mw_buffer:		dcb.b 8
r_old_highlight:	dcb.w 1
r_x_offset:		dcb.b 1
