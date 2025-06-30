	include "cpu/68000/include/common.inc"

	section vectors, data

		dc.l	SP_INIT_ADDR
		dc.l	_start
