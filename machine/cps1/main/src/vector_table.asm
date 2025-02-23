	include	"machine.inc"
	include "mad.inc"

	section vectors, data

		dc.l	SP_INIT_ADDR
		dc.l	_start

		rorg $68, $ff
		dc.l	irq2_handler

	section code

; vblank
irq2_handler:
		move.w	#PALETTE_RAM_START / 256, REGA_PALETTE_RAM_BASE
		rte
