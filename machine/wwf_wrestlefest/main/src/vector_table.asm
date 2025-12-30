	include "cpu/68000/include/common.inc"

	global r_irq2_count
	global r_irq3_count

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
; timer
irq2_handler:
		addq.w	#1, r_irq2_count
		move.w	#$0, $140016
		move.w	#$0, REG_IRQ2_ACK
		rte

; vblank
irq3_handler:
		addq.w	#1, r_irq3_count
		move.w	#$0, REG_IRQ3_ACK
		rte

irq1_handler:
irq4_handler:
irq5_handler:
irq6_handler:
irq7_handler:
		rte

	section bss
	align 1

r_irq2_count:		dcb.w 1
r_irq3_count:		dcb.w 1
