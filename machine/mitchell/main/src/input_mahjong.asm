	include "cpu/z80/include/common.inc"

	global	get_input
	global	get_input_misc

	section code

; For mahjong games map
;  a-f to inputs
; NOTE: pkladies doesn't have 'f' as in input so
; we needt to use 'i' instead.
; returns
;  a = input data
get_input:
		push	bc

		ld	b, $0
		ld	a, $80
		out	(IO_INPUT_P1), a
		nop
		nop
		nop

		in	a, (IO_INPUT_P1)
		bit	$7, a
		jr	nz, .a_not_pressed
		set	$0, b

	.a_not_pressed:
		bit	$6, a
		jr	nz, .e_not_pressed
		set	$4, b

	.e_not_pressed:

	ifd _ROMSET_PKLADIES_
		bit	$5, a
		jr	nz, .i_not_pressed
		set	$5, b

	.i_not_pressed:

	endif
		ld	a, $40
		out	(IO_INPUT_P1), a
		nop
		nop
		nop

		in	a, (IO_INPUT_P1)
		bit	$7, a
		jr	nz, .b_not_pressed
		set	$1, b

	.b_not_pressed:

	ifnd _ROMSET_PKLADIES_
		bit	$6, a
		jr	nz, .f_not_pressed
		set	$5, b

	.f_not_pressed:

	endif
		ld	a, $20
		out	(IO_INPUT_P1), a
		nop
		nop
		nop

		in	a, (IO_INPUT_P1)
		bit	$7, a
		jr	nz, .c_not_pressed
		set	$2, b

	.c_not_pressed:
		ld	a, $10
		out	(IO_INPUT_P1), a
		nop
		nop
		nop

		in	a, (IO_INPUT_P1)
		bit	$7, a
		jr	nz, .d_not_pressed
		set	$3, b

	.d_not_pressed:
		ld	a, b
		pop	bc
		cpl
		ret

; params:
;  d = com#
;  e = io port
get_input_misc:
		ld	a, d
		cp	$ff
		jr	z, .skip_com_select

		ld	c, e
		out	(c), a
		nop
		nop
		nop

	.skip_com_select:
		in	a, (c)
		ret
