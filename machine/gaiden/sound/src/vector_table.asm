	include "cpu/z80/include/macros.inc"
	include "cpu/z80/include/z80.inc"

	global r_irq_seen

	section vectors

	roffs RST_ENTRY
		jp	_start

	roffs RST_IRQ
		jp	irq_handler

	roffs RST_NMI
		jp	nmi_handler


	section code

irq_handler:
		di

		push	af

		xor	a
		inc	a

		ld	(r_irq_seen), a

		pop	af
		reti

nmi_handler:
		jp	_start

	section bss

r_irq_seen:
		blk	1
