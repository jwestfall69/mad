	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/konami/include/dsub.inc"
	include "cpu/konami/include/macros.inc"
	include "cpu/konami/include/xy_string.inc"

	include "input.inc"
	include "machine.inc"

	global	opcode_inh_test

	section code

opcode_inh_test:
		clr	r_opcode

		ldy	#d_xys_screen_list
		jsr	print_xy_string_list

		; copy exg test code from rom to ram
		ldx	#d_opcode_code
		ldy	#r_opcode_code
		ldb	#$6
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
		RSUB	print_hex_byte

		; init values
		lda	#$bb
		pshs	a
		puls	dp
		lda 	#$11
		ldb	#$22
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

		; not rts because stack will have been re-init
		jmp	opcode_test_return

	section data

d_opcode_code:	dc.w $00ae, $a807, opcode_return ; <opcode inh>, nop, jmp opcode_return

d_xys_screen_list:
		XY_STRING SCREEN_START_X, SCREEN_START_Y, "OPCODE INH TEST"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "BEFORE VALUES"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), " A   11  X 3344   S 99AA"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 4), " B   22  Y 5566  DP   BB"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 5), " D 1122  U 7788  CC   ??"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 8), "OPCODE"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 11), "AFTER VALUES FOR OPCODE"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 12), " A       X        S"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 13), " B       Y       DP"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 14), " D       U       CC"
		XY_STRING SCREEN_START_X, (SCREEN_B1_Y - 1), "JOY - ADJUST OPCODE"
		XY_STRING SCREEN_START_X, SCREEN_B1_Y, " B1 - RUN OPCODE"
		XY_STRING SCREEN_START_X, SCREEN_B2_Y, " B2 - RETURN TO MENU"
		XY_STRING_LIST_END

	section bss

r_opcode:	dcb.b	1
r_opcode_code:	dcb.b	6
r_stack:	dcb.w	1
