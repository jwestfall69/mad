	include "diag_rom.inc"

	global INTERRUPT_VBLANK_COUNT

	section vectors, data

		dc.l	SP_INIT_ADDR
		dc.l	_start

		rorg $78, $ff
		dc.l	irq6_handler

	section code

; vblank
irq6_handler:
		addq.l	#1, INTERRUPT_VBLANK_COUNT
		move.b	d0, REG_IRQ6_ACK
		rte

	section bss
	align 2

INTERRUPT_VBLANK_COUNT:	dc.l $0
