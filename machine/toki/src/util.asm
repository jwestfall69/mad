	; global includes
	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"

	; machine includes
	include "diag_rom.inc"
	include "machine.inc"

	global input_p1_update
	global input_system_update

	global INPUT_P1_EDGE
	global INPUT_P1_RAW
	global INPUT_P2_EDGE
	global INPUT_P2_RAW
	global INPUT_SYSTEM_EDGE
	global INPUT_SYSTEM_RAW

	section code

input_p1_update:
		move.b	REG_INPUT_P1, d0
		not.b	d0
		move.b	INPUT_P1_RAW, d1
		eor.b	d0, d1
		and.b	d0, d1
		move.b	d1, INPUT_P1_EDGE
		move.b	d0, INPUT_P1_RAW
		rts

input_system_update:
		move.b	REG_INPUT_SYSTEM, d0
		not.b	d0
		move.b	INPUT_SYSTEM_RAW, d1
		eor.b	d0, d1
		and.b	d0, d1
		move.b	d1, INPUT_SYSTEM_EDGE
		move.b	d0, INPUT_SYSTEM_RAW
		rts

	section bss

INPUT_P1_EDGE:		dc.b $0
INPUT_P1_RAW:		dc.b $0
INPUT_P2_EDGE:		dc.b $0
INPUT_P2_RAW:		dc.b $0
INPUT_SYSTEM_EDGE: 	dc.b $0
INPUT_SYSTEM_RAW:	dc.b $0
