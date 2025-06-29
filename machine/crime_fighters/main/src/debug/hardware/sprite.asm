	include "global/include/macros.inc"
	include "global/include/screen.inc"

	include "cpu/6x09/include/macros.inc"
	include "cpu/6x09/include/handlers/memory_write.inc"

	include "cpu/konami2/include/dsub.inc"
	include "cpu/konami2/include/macros.inc"

	include "machine.inc"

	global sprite_debug

	section code

sprite_debug:
		jsr	sprite_viewer_palette_setup

		; bank to palette ram
		setln	#(SETLN_WATCHDOG_POLL|SETLN_SELECT_RAM_PALETTE)

		; highlight color
		MEMORY_FILL16 #(FIX_TILE_PALETTE + PALETTE_SIZE + $2), #$7, #$001f

		setln	#(SETLN_WATCHDOG_POLL|SETLN_SELECT_RAM_WORK)

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 13)
		ldy	#d_str_last_written
		RSUB	print_string

		ldd	#FIX_TILE
		std	r_old_highlight

		; setup initial values
		ldx	#r_mw_buffer
		ldd	#$ff60		; enabled + pri + size
		std	, x
		ldd	#$0400		; sprite code
		std	2, x
		ldd	#$00b0		; y offset
		std	4, x
		ldd	#$0130		; x offset
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
		lda	#SCREEN_START_X
		sta	r_x_offset

	.loop_next_word:
		pshs	x
		lda	r_x_offset
		ldb	#SCREEN_START_Y + 15
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
		rts


	section data

d_mw_settings:		MW_SETTINGS 8, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb
d_str_last_written:	STRING "LAST WRITTEN"

	section bss

r_mw_buffer:		dcb.b 8
r_old_highlight:	dcb.w 1
r_x_offset:		dcb.b 1
