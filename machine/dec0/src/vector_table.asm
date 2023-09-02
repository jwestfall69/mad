	include "diag_rom.inc"

	global INTERRUPT_VBLANK_COUNT

	section vectors, data

		dc.l	SP_INIT_ADDR
		dc.l	_start

	rorg $78
		dc.l	interrupt_vblank	; irq6

	section code

interrupt_vblank:
		addq.l  #1, INTERRUPT_VBLANK_COUNT
		move.b  d0, $30c018
		rte

	section bss
	align 2

INTERRUPT_VBLANK_COUNT:	dc.l $0
