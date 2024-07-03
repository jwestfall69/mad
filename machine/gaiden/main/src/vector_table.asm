	include "cpu/68000/include/macros.inc"

	include "machine.inc"
	include "mad_rom.inc"

	section vectors, data

		dc.l	SP_INIT_ADDR
		dc.l	_start

		rorg $64, $ff
