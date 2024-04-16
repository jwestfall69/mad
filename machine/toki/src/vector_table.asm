	include "cpu/68000/macros.inc"
	include "diag_rom.inc"
	include "machine.inc"

	section vectors, data

		dc.l	SP_INIT_ADDR
		dc.l	_start

		rorg $64, $ff
		dc.l	interrupt_vblank	; irq1

	section code

interrupt_vblank:
		SCREEN_UPDATE
		rte
