	include "cpu/68000/include/common.inc"

	section vectors, data

		dc.l	SP_INIT_ADDR
		dc.l	_start

		rorg $68, $ff
		dc.l	irq2_handler

	section code

; vblank
irq2_handler:
		move.w	#PALETTE_RAM / 256, REGA_PALETTE_RAM_BASE
		rte
