	include "diag_rom.inc"

	section vectors, data

		dc.l	SP_INIT_ADDR
		dc.l	_start

	rorg $68
		dc.l	vblank_interrupt
