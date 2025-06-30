	include "cpu/6309/include/common.inc"
	include "cpu/6x09/include/handlers/memory_write.inc"

	global k051733_rand_debug

	section code

; This debug is to verify that any k051733 register read or write
; will cause reg6's "random" number to goto the next number.
; This is the sequence if there is only a single access to reg6 (ie
; from reading the register in order to print)
; ff ff fe fc f9 f3 e7 cf 9f 3f 7f fe fc f8 f0 e1 c3 87 0f 1f 3e 7c f9 f3 e6 cc 99 ...
; The value input is added to K051733_BASE to get the register the
; test will run against.  The test consists of
;  - print register addr
;  - read reg6 and print
;  - read register addr
;  - read reg6 and print
;  - write register addr
;  - read reg6 and print
k051733_rand_debug:

		; highlight color
		ldd	#$001f
		std	LAYER_A_TILE_PALETTE + $18

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 13)
		ldy	#d_str_results
		RSUB	print_string

		ldd	#LAYER_A_TILE
		std	r_old_highlight

		; setup initial values
		clr	r_mw_buffer

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
		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 15)
		lda	r_mw_buffer
		ldy	#K051733_BASE
		leay	a, y
		tfr	y, d
		pshs	y
		RSUB	print_hex_word

		SEEK_XY	(SCREEN_START_X + 5), (SCREEN_START_Y + 15)
		lda	K051733_BASE + $6
		RSUB	print_hex_byte

		puls	y
		lda	, y
		pshs	y
		SEEK_XY	(SCREEN_START_X + 8), (SCREEN_START_Y + 15)
		lda	K051733_BASE + $6
		RSUB	print_hex_byte


		puls	y
		lda	#$0
		sta	, y
		SEEK_XY	(SCREEN_START_X + 11), (SCREEN_START_Y + 15)
		lda	K051733_BASE + $6
		RSUB	print_hex_byte
		rts


loop_cb:
		rts


	section data

d_mw_settings:		MW_SETTINGS 1, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb
d_str_results:		STRING "RESULTS"

	section bss

r_mw_buffer:		dcb.b 1
r_old_highlight:	dcb.w 1
r_x_offset:		dcb.b 1
r_y_offset:		dcb.b 1
r_prev:			dcb.b 1
