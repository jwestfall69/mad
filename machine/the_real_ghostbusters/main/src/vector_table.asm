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
		ldd	r_irq_vblank_count
		incd
		std	r_irq_vblank_count
		rti

irq_handler:
firq_handler:
swi_handler:
		rti

	section bss

r_irq_vblank_count:	dcb.w 1
