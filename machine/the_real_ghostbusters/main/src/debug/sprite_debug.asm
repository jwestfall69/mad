	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/handlers/memory_write.inc"

	include "machine.inc"

	global sprite_debug

	section code

sprite_debug:
		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 13)
		ldy	#d_str_last_written
		PSUB	print_string

		ldd	FIX_TILE
		std	r_old_highlight

		; setup initial values
		ldx	#r_mw_buffer
		ldd	#$809f		; enable + y offset
		std	, x
		ldd	#$1		; another enable?
		std	2, x
		ldd	#$39		; x offset
		std	4, x
		ldd	#$102		; sprite num
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
		clr	, y

		lda	#$4
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
		PSUB	screen_seek_xy

		ldd	, y++
		pshs	d
		PSUB	print_hex_word
		puls	d

		puls	x
		std	, x++

		lda	r_x_offset
		adda	#$5
		sta	r_x_offset
		dec	r_scratch
		bne	.loop_next_word

		PSUB	sprite_trigger_copy
		rts

loop_cb:
		rts


	section data

d_mw_settings:		MW_SETTINGS 8, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb
;d_mw_settings:		MW_SETTINGS 3, $dc0c, highlight_cb, write_memory_cb, loop_cb
d_str_last_written:	STRING "LAST WRITTEN"

	section bss

r_mw_buffer:		dcb.b 8
r_old_highlight:	dcb.w 1
r_x_offset:		dcb.b 1
