	global r_irq_vblank_count

	section vectors

		dc.w	swi_handler
		dc.w	swi_handler
		dc.w	firq_handler
		dc.w	irq_handler
		dc.w	swi_handler
		dc.w	nmi_handler
		dc.w	reset_handler

	section reset

reset_handler:
		jmp	_start

	section code

irq_handler:
		pshs	d
		ldd	r_irq_vblank_count
		incd
		std	r_irq_vblank_count
		puls	d
		rti

nmi_handler:
firq_handler:
swi_handler:
		rti

	section bss

r_irq_vblank_count:
	dc.w	1