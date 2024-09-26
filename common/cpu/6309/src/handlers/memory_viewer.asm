	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/xy_string.inc"
	include "global/include/screen.inc"

	include "machine.inc"
	include "input.inc"

	global memory_viewer_handler

	section code

NUM_ROWS	equ 20
START_ROW	equ SCREEN_START_Y + 3

; params:
;  y = start address
memory_viewer_handler:
		pshs	y
		PSUB	screen_init

		ldy	#d_screen_xys_list
		PSUB	print_xy_string_list
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

; params:
;  y = start address
memory_dump:

		ldf	#START_ROW
		stf	r_current_row

		lde	#NUM_ROWS
		ste	r_remaining_rows

	.loop_next_address:
		; address
		lda	#SCREEN_START_X
		ldb	r_current_row
		PSUB	screen_seek_xy
		tfr	y, d
		PSUB	print_hex_word

		; 1st word
		lda	#(SCREEN_START_X + 6)
		ldb	r_current_row
		PSUB	screen_seek_xy
		ldd	0, y
		PSUB	print_hex_word

		; 2nd word
		lda	#(SCREEN_START_X + 11)
		ldb	r_current_row
		PSUB	screen_seek_xy
		ldd	2, y
		PSUB	print_hex_word

		; 1st byte
		lda	#(SCREEN_START_X + 17)
		ldb	r_current_row
		PSUB	screen_seek_xy
		lda	0, y
		PSUB	print_byte

		; 2nd byte
		lda	#(SCREEN_START_X + 18)
		ldb	r_current_row
		PSUB	screen_seek_xy
		lda	1, y
		PSUB	print_byte

		; 3rd byte
		lda	#(SCREEN_START_X + 19)
		ldb	r_current_row
		PSUB	screen_seek_xy
		lda	2, y
		PSUB	print_byte

		; 4th btye
		lda	#(SCREEN_START_X + 20)
		ldb	r_current_row
		PSUB	screen_seek_xy
		lda	3, y
		PSUB	print_byte

		leay	4, y
		inc	r_current_row
		dec	r_remaining_rows
		lbne	.loop_next_address

		rts

	section data

d_screen_xys_list:
	XY_STRING SCREEN_START_X, SCREEN_START_Y, "MEMORY VIEWER"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "ADDR"
	XY_STRING (SCREEN_START_X + 8), (SCREEN_START_Y + 2), "DATA"
	XY_STRING (SCREEN_START_X + 17), (SCREEN_START_Y + 2), "CHAR"
	XY_STRING_LIST_END

	section bss

r_current_row:		blk	1
r_remaining_rows:	blk	1
