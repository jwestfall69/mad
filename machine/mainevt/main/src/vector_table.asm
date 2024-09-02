	section vectors

		word	handle_swi
		word	handle_swi
		word	handle_firq
		word	handle_irq
		word	handle_swi
		word	handle_nmi
		word	handle_reset

	section reset
handle_reset:
		jmp	_start

	section code

handle_nmi:
handle_irq:
handle_firq:
handle_swi:
		rti
