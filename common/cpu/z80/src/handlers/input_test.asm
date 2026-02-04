	include "cpu/z80/include/common.inc"

	global input_test_handler

	section code

INPUT_X_OFFSET		equ SCREEN_START_X + 5
INPUT_Y_OFFSET		equ SCREEN_START_Y + 3

; params:
;  ix = INPUT_TEST_ENTRY list
;  iy = loop callback
input_test_handler:
		ld	(r_input_list), ix
		ld	(r_loop_cb), iy

		ld	de, d_screen_xys_list
		call	print_xy_string_list

	.loop_input_test:
		WATCHDOG

		ld	ix, (r_input_list)
		call	print_input_list

		ld	de, .loop_cb_return
		ld	hl, (r_loop_cb)
		push	de
		jp	(hl)

	.loop_cb_return:
		; avoid input_update because it calls delay
		; which causes problems with vbp counters
		GET_INPUT
		xor	$ff

		and	a, INPUT_B2 | INPUT_RIGHT
		cp	a, INPUT_B2 | INPUT_RIGHT
		jr	nz, .loop_input_test
		ret

; ix = INPUT_TEST_ENTRY list
print_input_list:
		ld	iy, r_print_line
		ld	(iy), INPUT_Y_OFFSET

	.loop_next_entry:
		ld	b, INPUT_X_OFFSET
		ld	c, (iy)
		RSUB	screen_seek_xy

		ld	d, (ix + 1)
		ld	e, (ix + 0)

		; exit out if input addr is $0000
		ld	a, $ff
		cp	d
		jr	nz, .not_list_end

		cp	e
		jr	z, .list_end
	.not_list_end:

		GET_INPUT_MISC

		xor	$ff
		ld	c, a
		RSUB	print_bits_byte

		inc	ix
		inc	ix
		inc	(iy)
		jr	.loop_next_entry

	.list_end:
		ret

	section data

d_screen_xys_list:
	XY_STRING (SCREEN_START_X + 5), (SCREEN_START_Y + 2), "76543210"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "EXIT  HOLD R B2"
	XY_STRING_LIST_END


	section bss

r_input_list:		dcb.w 1
r_loop_cb:		dcb.w 1
r_print_line:		dcb.b 1
