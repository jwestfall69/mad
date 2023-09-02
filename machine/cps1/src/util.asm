	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"
	include "cpu/68000/ssa3.inc"

	include "diag_rom.inc"
	include "machine.inc"

	global p1_input_update

	global P1_INPUT_EDGE
	global P1_INPUT_RAW
	global P2_INPUT_EDGE
	global P2_INPUT_RAW

	section code

p1_input_update:
		move.b	REG_P1_INPUT, d0
		not.b	d0
		move.b	P1_INPUT_RAW, d1
		eor.b	d0, d1
		and.b	d0, d1
		move.b	d1, P1_INPUT_EDGE
		move.b	d0, P1_INPUT_RAW
                rts

	section bss

P1_INPUT_EDGE:	dc.b $0
P1_INPUT_RAW:	dc.b $0
P2_INPUT_EDGE:	dc.b $0
P2_INPUT_RAW:	dc.b $0
