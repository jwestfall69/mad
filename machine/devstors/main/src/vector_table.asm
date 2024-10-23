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

nmi_handler:
irq_handler:
firq_handler:
swi_handler:
		rti
