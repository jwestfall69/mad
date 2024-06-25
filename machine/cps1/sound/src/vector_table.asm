	include "cpu/z80/include/macros.inc"
	include "cpu/z80/include/z80.inc"

	global IRQ_SEEN

	section vectors

	roffs RST_ENTRY
		jp	_start

	roffs RST_IRQ
		jp	irq_handler

	roffs RST_NMI
		jp	nmi_handler


	section code

irq_handler:
		ex	af, af'

		xor	a
		inc	a

		ld	(IRQ_SEEN), a

		ex	af, af'
		reti

nmi_handler:
		jp	_start


	section bss

IRQ_SEEN:
		blk	1
