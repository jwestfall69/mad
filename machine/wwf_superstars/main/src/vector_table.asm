	include "cpu/68000/include/common.inc"

	global r_irq_timer_count
	global r_irq_vblank_count

	section vectors, data

		dc.l	SP_INIT_ADDR
		dc.l	_start

		rorg	$74, $ff
		dc.l	irq5_handler
		dc.l	irq6_handler

	section code

; timer
irq5_handler:
		addq.l	#1, r_irq_timer_count
		move.w	d0, REG_IRQ5_ACK
		rte

; vblank
irq6_handler:
		addq.l	#1, r_irq_vblank_count
		move.w	d0, REG_IRQ6_ACK
		rte

	section bss
	align 1

r_irq_timer_count:		dcb.l 1
r_irq_vblank_count:		dcb.l 1
