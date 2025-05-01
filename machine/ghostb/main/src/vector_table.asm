	include "machine.inc"

	global r_irq_vblank_count

	section vectors

		dc.w	swi_handler
		dc.w	swi_handler
		dc.w	firq_handler
		dc.w	irq_handler
		dc.w	swi_handler
		dc.w	nmi_handler
		dc.w	_start

	section code

nmi_handler:
		pshs	d
		ldd	r_irq_vblank_count
		incd
		std	r_irq_vblank_count
		puls	d
		rti

irq_handler:
firq_handler:
swi_handler:
		rti

	section bss

r_irq_vblank_count:	dcb.w 1
