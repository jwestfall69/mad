	include "cpu/konami2/include/common.inc"

	global	exgtfr_test

	section code

exgtfr_test:
		clr	r_dst_reg
		clr	r_src_reg

		ldy	#d_xys_screen_list
		jsr	print_xy_string_list

		; copy exg test code from rom to ram
		ldx	#d_exg_code
		ldy	#r_exg_code
		ldb	#$6
	.loop_next_exg_code_byte:
		lda	, x+
		sta	, y+
		decb
		bne	.loop_next_exg_code_byte

		; copy tfr test code from rom to ram
		ldx	#d_tfr_code
		ldy	#r_tfr_code
		ldb	#$6
	.loop_next_tfr_code_byte:
		lda	, x+
		sta	, y+
		decb
		bne	.loop_next_tfr_code_byte

exgtfr_test_return:

	.draw_regs:
		SEEK_XY	(SCREEN_START_X + 9), (SCREEN_START_Y + 8)
		lda	r_src_reg
		RSUB	print_hex_nibble

		SEEK_XY	(SCREEN_START_X + 9), (SCREEN_START_Y + 9)
		lda	r_dst_reg
		RSUB	print_hex_nibble

	.loop_input:
		WATCHDOG
		jsr	input_update
		lda	r_input_edge

		bita	#INPUT_UP
		beq	.up_not_pressed
		lda	r_src_reg
		inca
		anda	#$f
		sta	r_src_reg
		bra	.draw_regs
	.up_not_pressed:

		bita	#INPUT_DOWN
		beq	.down_not_pressed
		lda	r_src_reg
		deca
		anda	#$f
		sta	r_src_reg
		bra	.draw_regs
	.down_not_pressed:

		bita	#INPUT_RIGHT
		beq	.right_not_pressed
		lda	r_dst_reg
		inca
		anda	#$f
		sta	r_dst_reg
		bra	.draw_regs
	.right_not_pressed:

		bita	#INPUT_LEFT
		beq	.left_not_pressed
		lda	r_dst_reg
		deca
		anda	#$f
		sta	r_dst_reg
		bra	.draw_regs
	.left_not_pressed:

		bita	#INPUT_B1
		beq	.b1_not_pressed
		jsr	run_exg_test
		bra	.loop_input
	.b1_not_pressed:

		bita	#INPUT_B2
		beq	.loop_input
		jsr	run_tfr_test
		bra	.loop_input


run_exg_test:

		; built the oparg and store in the exg test code in ram
		lda	r_dst_reg
		asla
		asla
		asla
		asla
		ora	r_src_reg
		sta	r_exg_code + 1

		SEEK_XY	 (SCREEN_START_X + 24), (SCREEN_START_Y + 11)
		ldd	r_exg_code
		RSUB	print_hex_word

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
		jmp	r_exg_code
	exg_return:

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

		; not rts because stack will have been re-init
		jmp	exgtfr_test_return

run_tfr_test:

		; built the oparg and store in the exg test code in ram
		lda	r_dst_reg
		asla
		asla
		asla
		asla
		ora	r_src_reg

		; this will for tfr behaviour instead of exg
		;ora	#$80

		sta	r_tfr_code + 1

		SEEK_XY	 (SCREEN_START_X + 24), (SCREEN_START_Y + 16)
		ldd	r_tfr_code
		RSUB	print_hex_word


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
		jmp	r_tfr_code
	tfr_return:

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
		SEEK_XY (SCREEN_START_X + 11), (SCREEN_START_Y + 17)
		puls	d	; x
		RSUB	print_hex_word

		SEEK_XY (SCREEN_START_X + 11), (SCREEN_START_Y + 18)
		puls	d	; y
		RSUB	print_hex_word

		SEEK_XY (SCREEN_START_X + 11), (SCREEN_START_Y + 19)
		puls	d	; u
		RSUB	print_hex_word

		SEEK_XY	(SCREEN_START_X + 5), (SCREEN_START_Y + 17)
		puls	a	; a
		RSUB	print_hex_byte

		SEEK_XY	(SCREEN_START_X + 5), (SCREEN_START_Y + 18)
		puls	a	; b
		RSUB	print_hex_byte

		SEEK_XY	(SCREEN_START_X + 3), (SCREEN_START_Y + 19)
		puls	d	; d
		RSUB	print_hex_word

		SEEK_XY (SCREEN_START_X + 20), (SCREEN_START_Y + 17)
		ldd	r_stack
		RSUB	print_hex_word

		SEEK_XY (SCREEN_START_X + 22), (SCREEN_START_Y + 18)
		puls	a	; dp
		RSUB	print_hex_byte

		SEEK_XY (SCREEN_START_X + 22), (SCREEN_START_Y + 19)
		puls	a	; cc
		RSUB	print_hex_byte

		; not rts because stack will have been re-init
		jmp	exgtfr_test_return

	section data

d_exg_code:	dc.w	$3e00, $a807, exg_return ; exg 0,0;jmp exg_return
d_tfr_code:	dc.w	$3f00, $a807, tfr_return ; tfr 0,0;jmp tfr_return

d_xys_screen_list:
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "BEFORE VALUES"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), " A   11  X 3344   S 99AA"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 4), " B   22  Y 5566  DP   BB"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 5), " D 1122  U 7788  CC   ??"

		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 7), "PARAMS"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 8), " SRC REG"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 9), " DST REG"

		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 11), "AFTER VALUES EXG OPCODE"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 12), " A       X        S"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 13), " B       Y       DP"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 14), " D       U       CC"

		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 16), "AFTER VALUES TFR OPCODE"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 17), " A       X        S"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 18), " B       Y       DP"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 19), " D       U       CC"

		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 21), "B1 RUN EXG    UD ADJ SRC REG"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 22), "B2 RUN TFR    LR ADJ DST REG"
		XY_STRING_LIST_END

	section bss

r_dst_reg:	dcb.b	1
r_src_reg:	dcb.b	1
r_exg_code:	dcb.b	6
r_tfr_code:	dcb.b	6
r_stack:	dcb.w	1
