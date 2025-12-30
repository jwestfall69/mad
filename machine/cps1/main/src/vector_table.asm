	include "cpu/68000/include/common.inc"

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
irq2_handler:
		move.w	#PALETTE_RAM / 256, REGA_PALETTE_RAM_BASE
		rte

irq1_handler:
irq3_handler:
irq4_handler:
irq5_handler:
irq6_handler:
irq7_handler:
		rte
