	include "cpu/68000/macros.inc"
	include "diag_rom.inc"
	include "machine.inc"

	section vectors, data

		dc.l	SP_INIT_ADDR
		dc.l	_start

		rorg $64, $ff
		dc.l	irq1_handler

	section code

; vblank
irq1_handler:
		SCREEN_UPDATE
		rte
