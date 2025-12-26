	include "cpu/68000/include/common.inc"

	global r_irq3_count
	global r_irq5_count

	section vectors, data

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

irq1_handler:
irq2_handler:
irq4_handler:
irq6_handler:
irq7_handler:
	rte

irq3_handler:
	move.b	#$0, $18fa01
	addq.w	#$1, r_irq3_count
	move.b	#$4, $18fa01
	rte

irq5_handler:
	move.b	#$0, $108001
	addq.w	#$1, r_irq5_count
	move.b	#$20, $108001
	rte


	section bss
	align 1

r_irq3_count:	dcb.w 1
r_irq5_count:	dcb.w 1
