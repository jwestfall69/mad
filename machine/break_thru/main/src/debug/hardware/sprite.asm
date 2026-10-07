	include "cpu/6809/include/common.inc"
	include "cpu/6x09/include/handlers/memory_write.inc"

	global sprite_debug

	section code

sprite_debug:
		ldd	#FG_RAM + $400
		std	r_old_highlight

		; setup initial values
		ldd	#$0902
		std	r_mw_buffer
		ldd	#$a040
		std	r_mw_buffer + 2

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
		cmpa	#$12
		bgt	.skip_remove_highlight
		adda	#$a
		sta	, y

	.skip_remove_highlight:
		lda	, x
		cmpa	#$12
		blt	.skip_add_highlight
		suba	#$a
		sta	, x

	.skip_add_highlight:
		stx	r_old_highlight
		rts

write_memory_cb:
		ldx	#SPRITE_RAM
		jsr	memory_write_generic_write
loop_cb:
		rts

	section data

d_mw_settings:		MW_SETTINGS 4, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb

	section bss

r_mw_buffer:		dcb.b 4
r_old_highlight:	dcb.w 1
