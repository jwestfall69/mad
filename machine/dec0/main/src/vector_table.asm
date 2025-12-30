	include "cpu/68000/include/common.inc"

	global r_irq6_count

	section vectors

		dc.l	SP_INIT_ADDR
		dc.l	_start

		rorg	$64, $ff
		dc.l	irq1_handler
		dc.l	irq2_handler
		dc.l	irq3_handler
		dc.l	irq4_handler
		dc.l	irq5_handler
		dc.l	irq6_handler
		dc.l	irq7_handler

	section code

; vblank
irq6_handler:
		addq.w	#1, r_irq6_count
		move.b	d0, REG_IRQ6_ACK
		rte

irq1_handler:
irq2_handler:
irq3_handler:
irq4_handler:
irq5_handler:
irq7_handler:
	rte

	section bss
	align 1

r_irq6_count:		dcb.w 1
