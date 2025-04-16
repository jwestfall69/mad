	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"

	include "machine.inc"
	include "input.inc"

	global memory_viewer_handler

	section code

; params:
;  a0 = start memory location
;  a1 = read_memory_cb or #$0000 to use default memory read
; read_memory_cb params:
;  a0 = address to start reading from
;  d0 = 0 (use word reads) or 1 (use byte reads)
; read_memory_cb return:
;  d0 = read data
;  function should write a long worth of data in d0
memory_viewer_handler:
		movem.l	a0-a1, -(a7)
		RSUB	screen_init

		clr.b	r_read_mode
		clr.b	r_debug_memory

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		lea	d_str_memory_viewer, a0
		RSUB	print_string

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 1)
		lea	d_str_read_mode_word, a0
		RSUB	print_string

		SEEK_XY (SCREEN_START_X + 5), (SCREEN_START_Y + 1)
		lea	d_str_read_mode, a0
		RSUB	print_string

		movem.l	(a7)+, a0-a1

	.loop_next_input:
		WATCHDOG
		bsr	memory_dump
		bsr	input_update
		move.b	r_input_edge, d0

		btst	#INPUT_UP_BIT, d0
		beq	.up_not_pressed
		suba.l	#4, a0
		bra	.loop_next_input

	.up_not_pressed:
		btst	#INPUT_DOWN_BIT, d0
		beq	.down_not_pressed
		adda.l	#4, a0
		bra	.loop_next_input

	.down_not_pressed:
		btst	#INPUT_LEFT_BIT, d0
		beq	.left_not_pressed
		suba.l	#$50, a0
		bra	.loop_next_input

	.left_not_pressed:
		btst	#INPUT_RIGHT_BIT, d0
		beq	.right_not_pressed
		adda.l	#$50, a0
		bra	.loop_next_input

	.right_not_pressed:
		btst	#INPUT_B1_BIT, d0
		beq	.b1_not_pressed

	ifd _DEBUG_MEMORY_
		move.b	r_debug_memory, d0
		move.b	d0, (a0)
		move.b	d0, (1, a0)
		move.b	d0, (2, a0)
		move.b	d0, (3, a0)
		addq.b	#$1, d0
		move.b	d0, r_debug_memory
	endif

		movem.l	a0, -(a7)
		move.b	r_read_mode, d0
		add.b	#$1, d0
		and.b	#$1, d0
		move.b	d0, r_read_mode
		tst.b	d0
		beq	.read_mode_word
		lea	d_str_read_mode_byte, a0
		bra	.print_read_mode

	.read_mode_word:
		lea	d_str_read_mode_word, a0

	.print_read_mode:
		SEEK_XY	(SCREEN_START_X + 5), (SCREEN_START_Y + 1)
		RSUB	print_string
		movem.l	(a7)+, a0

	.b1_not_pressed:
		btst	#INPUT_B2_BIT, d0
		beq	.loop_next_input

		rts

ROW_START	equ SCREEN_START_Y + 3
ROW_END		equ ROW_START + 20
; params:
;  a0 = start adddress
;  a1 = read_memory_cb or #$0000 to use default memory read
;  READ_MODE = 0 (word reads), 1 (byte reads)
memory_dump:

		movem.l	d0-d6/a0-a1, -(a7)

		moveq	#ROW_START, d3
		moveq	#(ROW_END - ROW_START - 1), d4

		bra	.loop_start_address

	.loop_next_address:
		add.b	#$1, d3			; line number

	.loop_start_address:

		moveq	#SCREEN_START_X, d0
		move.w	d3, d1
		RSUB	screen_seek_xy

		move.l	a0, d0
		RSUB	print_hex_3_bytes	; address

		moveq	#(SCREEN_START_X + 13), d0
		move.w	d3, d1
		RSUB	screen_seek_xy

		cmp	#$0, a1
		beq	.no_read_memory_cb

		movem.l	a0-a1, -(a7)
		moveq	#$0, d0
		move.b	r_read_mode, d0
		jsr	(a1)
		movem.l	(a7)+, a0-a1
		bra	.read_memory_done

	.no_read_memory_cb:
		btst	#$0, r_read_mode
		beq	.read_mode_word
		move.b	(a0), d0
		lsl.l	#8, d0
		move.b	(1,a0), d0
		lsl.l	#8, d0
		move.b	(2,a0), d0
		lsl.l	#8, d0
		move.b	(3, a0), d0
		bra	.read_memory_done

	.read_mode_word:
		move.w	(a0), d0
		swap	d0
		move.w	(2, a0), d0

	.read_memory_done:
		move.l	d0, d5
		RSUB	print_hex_word			; lower word

		moveq	#(SCREEN_START_X + 8), d0
		move.w	d3, d1
		RSUB	screen_seek_xy

		move.l	d5, d0
		swap	d0
		RSUB	print_hex_word			; upper word

		moveq	#SCREEN_START_X + 22, d2	; x offset
		moveq	#3, d6				; num of chars

	.loop_next_char:
		move.w	d2, d0
		move.w	d3, d1
		RSUB	screen_seek_xy

		move.l	d5, d0
		and.l	#$ff, d0
		RSUB	print_byte

		lsr.l	#8, d5
		sub.b	#1, d2
		dbra	d6, .loop_next_char


		adda.l	#4, a0
		dbra	d4, .loop_next_address

		movem.l (a7)+, d0-d6/a0-a1
		rts


	section data
	align 1

d_str_memory_viewer:		STRING "MEMORY VIEWER"
d_str_read_mode:		STRING "READ"
d_str_read_mode_byte:		STRING "BYTE"
d_str_read_mode_word:		STRING "WORD"

	section bss
	align 1

r_read_memory_cb:	dcb.l 1
r_debug_memory:		dcb.b 1
r_read_mode:		dcb.b 1
