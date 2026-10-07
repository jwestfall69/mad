	include "cpu/6309/include/common.inc"
	include "cpu/6x09/include/handlers/memory_write.inc"

	global sprite_debug

	section code

sprite_debug:
		jsr	k007121_g15_sprite_viewer_palette_setup

		; highlight color
		ldd	#$1e00
		std	K007121_G15_TILE_B_PALETTE + $4

		ldd	#K007121_G15_TILE_B
		std	r_old_highlight

		; setup initial values
		ldx	#r_mw_buffer
		ldd	#$d303		; sprite code
		std	, x
		ldd	#$50b0		; x + y offset
		std	2, x
		lda	#$88		; more sprite code?
		sta	4, x

		ldx	#d_mw_settings
		jsr	memory_write_handler
		rts

; params:
;  x = fix ram location to set highlight
; we are also on the hook for clearing out the
; previous highlight
highlight_cb:
		ldy	r_old_highlight
		clr	-$400, y

		lda	#$2
		sta	-$400, x
		stx	r_old_highlight
		rts

write_memory_cb:
		ldx	#K007121_G15_SPRITE
		jsr	memory_write_generic_write
loop_cb:
		rts

	section data

d_mw_settings:		MW_SETTINGS 5, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb

	section bss

r_mw_buffer:		dcb.b 5
r_old_highlight:	dcb.w 1
