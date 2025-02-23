	include "cpu/68000/include/macros.inc"

	include "machine.inc"
	include "mad.inc"

	global r_irq_vblank_count
	section vectors, data

		dc.l	SP_INIT_ADDR
		dc.l	_start

		rorg	$74, $ff
		dc.l	irq5_handler

	section code

; vblank
irq5_handler:
		addq.l	#1, r_irq_vblank_count
		move.w	d0, REG_IRQ5_ACK
		rte

	section bss
	align 2

r_irq_vblank_count:	dc.l $0
