	include "cpu/6809/include/common.inc"
	include "cpu/6x09/include/handlers/memory_write.inc"

	; testing REG_CONTROL2 / $1803
	global reg1803_debug

	section code

reg1803_debug:
		ldy	#d_screen_xys_list
		jsr	print_xy_string_list

		ldd	#FG_RAM + $400
		std	r_old_highlight

		CPU_INTS_ENABLE

		ldd	#$0
		std	r_irq_count
		std	r_nmi_count
		clr	r_mw_buffer
		clr	r_reg_control2_saved

		ldx	#d_mw_settings
		jsr	memory_write_handler

		CPU_INTS_DISABLE

		lda	#(CTRL2_NMI_DISABLE|CTRL2_IRQ_DISABLE)
		sta	REG_CONTROL2
		sta	r_reg_control2_saved
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
		lda	r_mw_buffer
		sta	r_reg_control2_saved
		sta	REG_CONTROL2

		SEEK_XY	(SCREEN_START_X + 14), (SCREEN_START_Y + 13)
		RSUB	print_hex_byte
		rts

loop_cb:
		SEEK_XY	(SCREEN_START_X + 6), (SCREEN_START_Y + 14)
		ldd	r_irq_count
		RSUB	print_hex_word

		SEEK_XY	(SCREEN_START_X + 6), (SCREEN_START_Y + 15)
		ldd	r_nmi_count
		RSUB	print_hex_word

		rts

	section data

d_mw_settings:		MW_SETTINGS 1, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb

d_screen_xys_list:
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 13), "LAST WRITTEN"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 14), "IRQ"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 15), "NMI"
		XY_STRING_LIST_END

	section bss

r_mw_buffer:		dcb.b 1
r_old_highlight:	dcb.w 1
r_x_offset:		dcb.b 1
