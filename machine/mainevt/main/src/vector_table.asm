	section vectors

		word	swi_handler
		word	swi_handler
		word	firq_handler
		word	irq_handler
		word	swi_handler
		word	nmi_handler
		word	reset_handler

	section reset

reset_handler:
		jmp	_start

	section code

nmi_handler:
irq_handler:
firq_handler:
swi_handler:
		rti
