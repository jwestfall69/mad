	include "diag_rom.inc"
	include	"machine.inc"

	section vectors, data

		dc.l	SP_INIT_ADDR
		dc.l	_start

		rorg $68, $ff
		dc.l	irq2_handler

	section code

; vblank
irq2_handler:
		rte
