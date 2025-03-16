	include "machine.inc"
	include "mad.inc"

	global r_irq_vblank_count

	section vectors, data

		dc.l	SP_INIT_ADDR
		dc.l	_start

		rorg $78, $ff
		dc.l	irq6_handler

	section code

; vblank
irq6_handler:
		addq.l	#1, r_irq_vblank_count
		move.b	d0, REG_IRQ6_ACK
		rte

	section bss
	align 1

r_irq_vblank_count:	dcb.l 1
