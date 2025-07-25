	include "cpu/konami2/include/common.inc"

	global	opcode_idx_test

	section code

opcode_idx_test:
		clr	r_opcode

		ldy	#d_xys_screen_list
		jsr	print_xy_string_list

		; copy exg test code from rom to ram
		ldx	#d_opcode_code
		ldy	#r_opcode_code
		ldb	#$8
	.loop_next_opcode_byte:
		lda	, x+
		sta	, y+
		decb
		bne	.loop_next_opcode_byte

opcode_test_return:

	.draw_opcode:
		SEEK_XY	(SCREEN_START_X + 7), (SCREEN_START_Y + 8)
		lda	r_opcode
		RSUB	print_hex_byte

	.loop_input:
		WATCHDOG
		jsr	input_update
		lda	r_input_edge

		bita	#INPUT_UP
		beq	.up_not_pressed
		lda	r_opcode
		inca
		sta	r_opcode
		bra	.draw_opcode
	.up_not_pressed:

		bita	#INPUT_DOWN
		beq	.down_not_pressed
		lda	r_opcode
		deca
		sta	r_opcode
		bra	.draw_opcode
	.down_not_pressed:

		bita	#INPUT_RIGHT
		beq	.right_not_pressed
		lda	r_opcode
		adda	#$10
		sta	r_opcode
		bra	.draw_opcode
	.right_not_pressed:

		bita	#INPUT_LEFT
		beq	.left_not_pressed
		lda	r_opcode
		suba	#$10
		sta	r_opcode
		bra	.draw_opcode
	.left_not_pressed:

		bita	#INPUT_B1
		beq	.b1_not_pressed
		jsr	run_opcode_test
		bra	.loop_input
	.b1_not_pressed:
		bita	#INPUT_B2
		beq	.loop_input
		jmp	main_menu

run_opcode_test:

		lda	r_opcode
		sta	r_opcode_code

		SEEK_XY	 (SCREEN_START_X + 24), (SCREEN_START_Y + 11)
		ldd	r_opcode_code
		RSUB	print_hex_word

		SEEK_XY	 (SCREEN_START_X + 29), (SCREEN_START_Y + 11)
		ldd	r_opcode_code+2
		RSUB	print_hex_word

		ldd	#$8191
		std	r_opcode_mem

		; init values
		lda	#$bb
		pshs	a
		puls	dp
		lda 	#$12
		ldb	#$23
		ldx	#$3344
		ldy	#$5566
		ldu	#$7788
		lds	#$99aa

		; run the opcode from ram
		jmp	r_opcode_code
	opcode_return:

		; Stack may have changed, backup and re-init.
		; This is going to screw up whatever cc was
		sts	r_stack
		lds	#(WORK_RAM_START + WORK_RAM_SIZE)

		pshs	cc
		pshs	dp
		pshs	d
		pshs	b
		pshs	a
		pshs	u
		pshs	y
		pshs	x

		; reset dp or stuff could break
		lda	#$0
		pshs	a
		puls	dp

		; now the fun task of printing it all
		SEEK_XY (SCREEN_START_X + 11), (SCREEN_START_Y + 12)
		puls	d	; x
		RSUB	print_hex_word

		SEEK_XY (SCREEN_START_X + 11), (SCREEN_START_Y + 13)
		puls	d	; y
		RSUB	print_hex_word

		SEEK_XY (SCREEN_START_X + 11), (SCREEN_START_Y + 14)
		puls	d	; u
		RSUB	print_hex_word

		SEEK_XY	(SCREEN_START_X + 5), (SCREEN_START_Y + 12)
		puls	a	; a
		RSUB	print_hex_byte

		SEEK_XY	(SCREEN_START_X + 5), (SCREEN_START_Y + 13)
		puls	a	; b
		RSUB	print_hex_byte

		SEEK_XY	(SCREEN_START_X + 3), (SCREEN_START_Y + 14)
		puls	d	; d
		RSUB	print_hex_word

		SEEK_XY (SCREEN_START_X + 20), (SCREEN_START_Y + 12)
		ldd	r_stack
		RSUB	print_hex_word

		SEEK_XY (SCREEN_START_X + 22), (SCREEN_START_Y + 13)
		puls	a	; dp
		RSUB	print_hex_byte

		SEEK_XY (SCREEN_START_X + 22), (SCREEN_START_Y + 14)
		puls	a	; cc
		RSUB	print_hex_byte

		SEEK_XY (SCREEN_START_X + 20), (SCREEN_START_Y + 15)
		ldd	r_opcode_mem
		RSUB	print_hex_word

		; not rts because stack will have been re-init
		jmp	opcode_test_return

	section data

d_opcode_code:	dc.w $0007, r_opcode_mem, $a807, opcode_return ; <opcode + ext>, r_opcode_mem, jmp opcode_return

d_xys_screen_list:
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "BEFORE VALUES"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), " A   12  X 3344   S 99AA"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 4), " B   23  Y 5566  DP   BB"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 5), " D 1223  U 7788  CC   ??"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 8), "OPCODE     MEM DATA 8191"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 11), "AFTER VALUES FOR OPCODE"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 12), " A       X        S"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 13), " B       Y       DP"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 14), " D       U       CC"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 15), "           MEM DATA"

		XY_STRING SCREEN_START_X, (SCREEN_B1_Y - 1), "JOY - ADJUST OPCODE"
		XY_STRING SCREEN_START_X, SCREEN_B1_Y, " B1 - RUN OPCODE"
		XY_STRING SCREEN_START_X, SCREEN_B2_Y, " B2 - RETURN TO MENU"
		XY_STRING_LIST_END

	section bss

r_opcode:	dcb.b	1
r_opcode_code:	dcb.b	8
r_stack:	dcb.w	1
r_opcode_mem:	dcb.w	1
