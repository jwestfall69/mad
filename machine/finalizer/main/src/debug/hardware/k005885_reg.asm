	include "cpu/6809/include/common.inc"
	include "cpu/6x09/include/handlers/memory_write.inc"

	global k005885_reg_debug

	section code

k005885_reg_debug:
		ldy	#d_screen_xys_list
		jsr	print_xy_string_list

		ldd	#K005885_TILE_A
		std	r_old_highlight

		CPU_INTS_ENABLE

		ldd	#$0
		std	r_firq_count
		std	r_irq_count
		std	r_nmi_count
		sta	r_reg_control_saved

		std	r_mw_buffer
		sta	r_mw_buffer + 2
		sta	r_mw_buffer + 4
		lda	#$04
		sta	r_mw_buffer + 3

		ldx	#d_mw_settings
		jsr	memory_write_handler

		CPU_INTS_DISABLE

		lda	#(CTRL_FIRQ_DISABLE|CTRL_IRQ_DISABLE|CTRL_NMI_DISABLE)
		sta	>REG_CONTROL
		sta	r_reg_control_saved
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

		lda	#$5
		sta	r_scratch
		lda	#SCREEN_START_X
		sta	r_x_offset

		ldx	#$0
		ldy	#r_mw_buffer
	.loop_next_byte:
		pshs	x
		lda	r_x_offset
		ldb	#(SCREEN_START_Y + 15)
		RSUB	screen_seek_xy

		lda	,y+
		pshs	a,y
		RSUB	print_hex_byte
		puls	y,a
		puls	x

		sta	,x+

		lda	r_x_offset
		adda	#$3
		sta	r_x_offset
		dec	r_scratch
		bne	.loop_next_byte

		lda	r_mw_buffer + 4
		sta	r_reg_control_saved
		rts

loop_cb:

		SEEK_XY	(SCREEN_START_X + 6), (SCREEN_START_Y + 17)
		ldd	r_firq_count
		RSUB	print_hex_word

		SEEK_XY	(SCREEN_START_X + 6), (SCREEN_START_Y + 18)
		ldd	r_irq_count
		RSUB	print_hex_word

		SEEK_XY	(SCREEN_START_X + 6), (SCREEN_START_Y + 19)
		ldd	r_nmi_count
		RSUB	print_hex_word

		rts

	section data

d_mw_settings:		MW_SETTINGS 5, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb

d_screen_xys_list:
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 13), "LAST WRITTEN"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 17), "FIRQ"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 18), "IRQ"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 19), "NMI"
		XY_STRING_LIST_END

	section bss

r_mw_buffer:		dcb.b 5
r_old_highlight:	dcb.w 1
r_x_offset:		dcb.b 1
