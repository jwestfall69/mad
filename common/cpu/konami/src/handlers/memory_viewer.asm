	include "cpu/konami/include/dsub.inc"
	include "cpu/konami/include/macros.inc"
	include "cpu/konami/include/xy_string.inc"
	include "global/include/screen.inc"

	include "machine.inc"
	include "input.inc"

	global memory_viewer_handler

	section code

memory_viewer_handler:
		stx	r_cb_read_memory
		pshs	y
		RSUB	screen_init

		ldy	#d_screen_xys_list
		jsr	print_xy_string_list
		puls	y

	.loop_next_input:
		WATCHDOG
		pshs	y
		jsr	memory_dump
		puls	y

		jsr	input_update
		lda	r_input_edge

		bita	#INPUT_UP
		beq	.up_not_pressed
		leay	-4, y
		bra	.loop_next_input

	.up_not_pressed:
		bita	#INPUT_DOWN
		beq	.down_not_pressed
		leay	4, y
		bra	.loop_next_input

	.down_not_pressed:
		bita	#INPUT_LEFT
		beq	.left_not_pressed
		leay	-$50, y
		bra	.loop_next_input

	.left_not_pressed:
		bita	#INPUT_RIGHT
		beq	.right_not_pressed
		leay	$50, y
		bra	.loop_next_input

	.right_not_pressed:
		bita	#INPUT_B2
		beq	.loop_next_input
		rts


NUM_ROWS	equ 20
START_ROW	equ SCREEN_START_Y + 3
; params:
;  y = start address
memory_dump:
		sty	r_dump_address

		lda	#START_ROW
		sta	r_dump_row

	.loop_next_address:
		ldy	r_dump_address

		; if a cb was supplied use that, otherwise
		; just do normal reads
		ldx	r_cb_read_memory
		beq	.no_cb_read_word

		ldx	#r_dump_data
		jsr	[r_cb_read_memory]

		bra	.do_dump

	.no_cb_read_word:
		ldd	, y
		std	r_dump_data
		ldd	2, y
		std	r_dump_data + 2

	.do_dump:
		; address
		lda	#SCREEN_START_X
		ldb	r_dump_row
		RSUB	screen_seek_xy
		ldd	r_dump_address
		RSUB	print_hex_word

		; 1st word
		lda	#(SCREEN_START_X + 6)
		ldb	r_dump_row
		RSUB	screen_seek_xy
		ldd	r_dump_data
		RSUB	print_hex_word

		; 2nd word
		lda	#(SCREEN_START_X + 11)
		ldb	r_dump_row
		RSUB	screen_seek_xy
		ldd	r_dump_data + 2
		RSUB	print_hex_word

		; 1st byte
		lda	#(SCREEN_START_X + 17)
		ldb	r_dump_row
		RSUB	screen_seek_xy
		lda	r_dump_data
		RSUB	print_byte

		; 2nd byte
		lda	#(SCREEN_START_X + 18)
		ldb	r_dump_row
		RSUB	screen_seek_xy
		lda	r_dump_data + 1
		RSUB	print_byte

		; 3rd byte
		lda	#(SCREEN_START_X + 19)
		ldb	r_dump_row
		RSUB	screen_seek_xy
		lda	r_dump_data + 2
		RSUB	print_byte

		; 4th btye
		lda	#(SCREEN_START_X + 20)
		ldb	r_dump_row
		RSUB	screen_seek_xy
		lda	r_dump_data + 3
		RSUB	print_byte

		lda	r_dump_row
		inca
		cmpa	#(START_ROW + NUM_ROWS)
		beq	.dump_done
		sta	r_dump_row

		ldd	r_dump_address
		addd	#$4
		std	r_dump_address
		lbra	.loop_next_address

	.dump_done:
		rts

	section data

d_screen_xys_list:
	XY_STRING SCREEN_START_X, SCREEN_START_Y, "MEMORY VIEWER"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "ADDR"
	XY_STRING (SCREEN_START_X + 8), (SCREEN_START_Y + 2), "DATA"
	XY_STRING (SCREEN_START_X + 17), (SCREEN_START_Y + 2), "CHAR"
	XY_STRING_LIST_END

	section bss

r_cb_read_memory:	dcb.w	1
r_dump_address:		dcb.w	1
r_dump_data:		dcb.w	2
r_dump_row:		dcb.b	1
