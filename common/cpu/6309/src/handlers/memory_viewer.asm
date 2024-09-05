	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/xy_string.inc"

	include "machine.inc"
	include "input.inc"

	global memory_viewer_handler

	section code

NUM_ROWS	equ 20
START_ROW	equ 6

; params:
;  y = start address
memory_viewer_handler:
		pshs	y
		PSUB	screen_clear

		ldy	#SCREEN_XY_LIST
		PSUB	print_xy_string_list
		puls	y

	.loop_next_input:
		WATCHDOG
		pshs	y
		jsr	memory_dump
		puls	y

		jsr	input_update
		lda	INPUT_EDGE

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
		bita	#INPUT_RIGHT
		beq	.right_not_pressed
		leay	$50, y
		bra	.loop_next_input

	.right_not_pressed:
		bita	#INPUT_LEFT
		beq	.left_not_pressed
		leay	-$50, y
		bra	.loop_next_input

	.left_not_pressed:
		bita	#INPUT_B2
		beq	.loop_next_input
		rts

; params:
;  y = start address
memory_dump:

		ldf	#START_ROW
		stf	CURRENT_ROW

		lde	#NUM_ROWS
		ste	REMAINING_ROWS

	.loop_next_address:
		; address
		lda	#4
		ldb	CURRENT_ROW
		PSUB	screen_seek_xy
		tfr	y, d
		PSUB	print_hex_word

		; 1st word
		lda	#11
		ldb	CURRENT_ROW
		PSUB	screen_seek_xy
		ldd	0, y
		PSUB	print_hex_word

		; 2nd word
		lda	#16
		ldb	CURRENT_ROW
		PSUB	screen_seek_xy
		ldd	2, y
		PSUB	print_hex_word

		; 1st byte
		lda	#23
		ldb	CURRENT_ROW
		PSUB	screen_seek_xy
		lda	0, y
		PSUB	print_byte

		; 2nd byte
		lda	#24
		ldb	CURRENT_ROW
		PSUB	screen_seek_xy
		lda	1, y
		PSUB	print_byte

		; 3rd byte
		lda	#25
		ldb	CURRENT_ROW
		PSUB	screen_seek_xy
		lda	2, y
		PSUB	print_byte

		; 4th btye
		lda	#26
		ldb	CURRENT_ROW
		PSUB	screen_seek_xy
		lda	3, y
		PSUB	print_byte

		leay	4, y
		inc	CURRENT_ROW
		dec	REMAINING_ROWS
		lbne	.loop_next_address

		rts

	section data

SCREEN_XY_LIST:
	XY_STRING  9, 3, "MEMORY_VIEWER"
	XY_STRING  4, 4, "ADDR"
	XY_STRING 13, 4, "DATA"
	XY_STRING 23, 4, "CHAR"
	XY_STRING_LIST_END

	section bss

CURRENT_ROW:	blk	1
REMAINING_ROWS:	blk	1
