	include "cpu/6809/include/common.inc"
	include "cpu/6x09/include/handlers/memory_write.inc"

	global k005885_sprite_debug

	section code

k005885_sprite_debug:
		ldd	#K005885_TILE_A
		std	r_old_highlight

		; setup initial values
		ldd	#$2701
		std	r_mw_buffer
		ldd	#$4020
		std	r_mw_buffer + 2
		lda	#$0
		sta	r_mw_buffer + 4

		ldx	#d_mw_settings
		jsr	memory_write_handler
		rts

; params:
;  x = fix ram location to set highlight
; we are also on the hook for clearing out the
; previous highlight
highlight_cb:
		ldy	r_old_highlight
		lda	#$0
		sta	-$400, y

		lda	#$3
		sta	-$400, x
		stx	r_old_highlight
		rts

write_memory_cb:
		ldx	#K005885_SPRITE
		jsr	memory_write_generic_write
loop_cb:
		rts

	section data

d_mw_settings:		MW_SETTINGS 5, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb

	section bss

r_mw_buffer:		dcb.b 5
r_old_highlight:	dcb.w 1
