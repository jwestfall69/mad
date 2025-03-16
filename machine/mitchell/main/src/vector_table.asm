	include "cpu/z80/include/macros.inc"
	include "cpu/z80/include/z80.inc"

	global r_irq_count

	section vectors

	rorg RST_ENTRY
		jp	_start

	rorg RST_IRQ
		jp	irq_handler

	rorg RST_NMI
		jp	nmi_handler


	section code

irq_handler:
		di
		push	af
		push	hl

		ld	hl, (r_irq_count)
		inc	hl
		ld	(r_irq_count), hl

		; pang does this in irq, but doing
		; it here causes dashes on the screen?
		;out	($06), a
		pop	hl
		pop	af
		ei
		reti

nmi_handler:
		jp	_start


	section bss

r_irq_count:	dcb.w 1
