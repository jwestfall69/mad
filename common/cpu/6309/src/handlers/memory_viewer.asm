	include "global/include/screen.inc"
	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/xy_string.inc"

	include "machine.inc"
	include "input.inc"

	global memory_viewer_handler

	section code

; params:
;  x = start address
;  y = read_memory_cb or #$0000 to use default memory read
; read_memory_cb params:
;  x = address to start reading from
;  y = address to start writing data
;  function should write a long worth of data at y
memory_viewer_handler:
		sty	r_read_memory_cb
		pshs	x
		PSUB	screen_init

		ldy	#d_screen_xys_list
		PSUB	print_xy_string_list
		puls	x

	.loop_next_input:
		WATCHDOG
		pshs	x
		jsr	memory_dump
		puls	x

		jsr	input_update
		lda	r_input_edge

		bita	#INPUT_UP
		beq	.up_not_pressed
		leax	-4, x
		bra	.loop_next_input

	.up_not_pressed:
		bita	#INPUT_DOWN
		beq	.down_not_pressed
		leax	4, x
		bra	.loop_next_input

	.down_not_pressed:
		bita	#INPUT_LEFT
		beq	.left_not_pressed
		leax	-$50, x
		bra	.loop_next_input

	.left_not_pressed:
		bita	#INPUT_RIGHT
		beq	.right_not_pressed
		leax	$50, x
		bra	.loop_next_input

	.right_not_pressed:
		bita	#INPUT_B2
		beq	.loop_next_input
		rts

ROW_START	equ SCREEN_START_Y + 3
ROW_END		equ ROW_START + 20
; params:
;  x = start address
memory_dump:
		stx	r_dump_address

		lda	#ROW_START
		sta	r_dump_row

	.loop_next_address:
		ldx	r_dump_address

		; if a cb was supplied use that, otherwise
		; just do normal reads
		ldy	r_read_memory_cb
		beq	.no_read_memory_cb

		ldy	#r_dump_data
		jsr	[r_read_memory_cb]
		bra	.read_memory_done

	.no_read_memory_cb:
		ldd	, x
		std	r_dump_data
		ldd	2, x
		std	r_dump_data + 2

	.read_memory_done:
		; address
		lda	#SCREEN_START_X
		ldb	r_dump_row
		PSUB	screen_seek_xy
		ldd	r_dump_address
		PSUB	print_hex_word

		; 1st word
		lda	#(SCREEN_START_X + 6)
		ldb	r_dump_row
		PSUB	screen_seek_xy
		ldd	r_dump_data
		PSUB	print_hex_word

		; 2nd word
		lda	#(SCREEN_START_X + 11)
		ldb	r_dump_row
		PSUB	screen_seek_xy
		ldd	r_dump_data + 2
		PSUB	print_hex_word

		; 1st byte
		lda	#(SCREEN_START_X + 17)
		ldb	r_dump_row
		PSUB	screen_seek_xy
		lda	r_dump_data
		PSUB	print_byte

		; 2nd byte
		lda	#(SCREEN_START_X + 18)
		ldb	r_dump_row
		PSUB	screen_seek_xy
		lda	r_dump_data + 1
		PSUB	print_byte

		; 3rd byte
		lda	#(SCREEN_START_X + 19)
		ldb	r_dump_row
		PSUB	screen_seek_xy
		lda	r_dump_data + 2
		PSUB	print_byte

		; 4th btye
		lda	#(SCREEN_START_X + 20)
		ldb	r_dump_row
		PSUB	screen_seek_xy
		lda	r_dump_data + 3
		PSUB	print_byte

		lda	r_dump_row
		inca
		cmpa	#ROW_END
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

r_read_memory_cb:	dcb.w 1
r_dump_address:		dcb.w 1
r_dump_data:		dcb.w 2
r_dump_row:		dcb.b 1
