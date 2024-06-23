	include "cpu/z80/include/macros.inc"
	include "cpu/z80/include/z80.inc"

	section vectors

	roffs RST_ENTRY
		jp	_start

	roffs RST_IRQ
		jp	irq_handler

	roffs RST_NMI
		jp	nmi_handler


	section code

irq_handler:
		STALL

nmi_handler:
		jp	_start

