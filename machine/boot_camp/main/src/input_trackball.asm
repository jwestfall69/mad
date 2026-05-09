	include "cpu/6x09/include/common.inc"

	global get_input

	section code

THRESHOLD		equ $8

get_input:

		pshs	d
		ldd	#$fff
		jsr	delay
		puls	d

		lda	REG_INPUT
		coma
		anda	#$3
		sta	r_input_tmp

		lda	REG_INPUT_P1_TB_Y
		asla
		sta	r_scratch
		suba	r_tb_y_prev
		sta	r_tb_y_signed

		bpl	.y_positive
		nega
	.y_positive:
		cmpa	#THRESHOLD
		bls	.skip_up_down


		lda	r_tb_y_signed
		bpl	.do_up
		lda	#INPUT_DOWN
		bra	.update_up_down

	.do_up:
		lda	#INPUT_UP

	.update_up_down:
		ora	r_input_tmp
		sta	r_input_tmp

	.skip_up_down:
		lda	r_scratch
		sta	r_tb_y_prev

		lda	REG_INPUT_P1_TB_X
		asla
		sta	r_scratch
		suba	r_tb_x_prev
		sta	r_tb_x_signed

		bpl	.x_positive
		nega
	.x_positive:
		cmpa	#THRESHOLD
		bls	.skip_left_right


		lda	r_tb_x_signed
		bpl	.do_right
		lda	#INPUT_LEFT
		bra	.update_right_left

	.do_right:
		lda	#INPUT_RIGHT

	.update_right_left:
		ora	r_input_tmp
		sta	r_input_tmp

	.skip_left_right:
		lda	r_scratch
		sta	r_tb_x_prev

		lda	r_input_tmp
		rts

	section bss

r_input_tmp:		dcb.b 1

r_tb_x_prev:		dcb.b 1
r_tb_x_signed:		dcb.b 1
r_tb_y_prev:		dcb.b 1
r_tb_y_signed:		dcb.b 1
