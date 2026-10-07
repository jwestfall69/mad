	include "cpu/konami2/include/common.inc"
	include "cpu/6x09/include/handlers/memory_write.inc"

	global sprite_debug

	section code

sprite_debug:
		jsr	sprite_viewer_palette_setup

		; bank to palette ram
		lda	#$a0
		sta	REG_CONTROL

		; highlight color
		ldd	#$001f
		std	FIX_TILE_PALETTE + PALETTE_SIZE + $16

		lda	#$80
		sta	REG_CONTROL

		ldd	#FIX_TILE
		std	r_old_highlight

		; setup initial values
		ldx	#r_mw_buffer
		ldd	#$ff60		; enabled + pri + size
		std	, x
		ldd	#$4400		; sprite code
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
		jsr	memory_write_generic_write
loop_cb:
		rts

	section data

d_mw_settings:		MW_SETTINGS 8, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb

	section bss

r_mw_buffer:		dcb.b 8
r_old_highlight:	dcb.w 1
