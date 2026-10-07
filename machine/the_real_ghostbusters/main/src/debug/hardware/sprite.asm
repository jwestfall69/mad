	include "cpu/6309/include/common.inc"
	include "cpu/6x09/include/handlers/memory_write.inc"

	global sprite_debug

	section code

sprite_debug:
		ldd	#FIX_TILE
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
		jsr	memory_write_generic_write

		RSUB	sprite_trigger_copy
loop_cb:
		rts

	section data

d_mw_settings:		MW_SETTINGS 8, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb

	section bss

r_mw_buffer:		dcb.b 8
r_old_highlight:	dcb.w 1
