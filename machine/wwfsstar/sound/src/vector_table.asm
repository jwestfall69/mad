	include "cpu/z80/include/macros.inc"
	include "cpu/z80/include/z80.inc"

	global r_irq_seen

	section vectors

	rorg RST_ENTRY
		jp	_start

	rorg RST_IRQ
		jp	irq_handler

	rorg RST_NMI
		jp	nmi_handler


	section code

irq_handler:
		push	af

		xor	a
		inc	a

		ld	(r_irq_seen), a

		pop	af
		reti

nmi_handler:
		jp	_start


	section bss

r_irq_seen:	dcb.b 1
