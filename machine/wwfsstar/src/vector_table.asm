	include "diag_rom.inc"
	include "machine.inc"

	global INTERRUPT_TIMER_COUNT
	global INTERRUPT_VBLANK_COUNT

	section vectors, data

		dc.l	SP_INIT_ADDR
		dc.l	_start

		rorg	$74, $ff
		dc.l	irq5_handler
		dc.l	irq6_handler

	section code

; timer
irq5_handler:
		addq.l	#1, INTERRUPT_TIMER_COUNT
		move.w	d0, REG_IRQ5_ACK
		rte

; vblank
irq6_handler:
		addq.l	#1, INTERRUPT_VBLANK_COUNT
		move.w	d0, REG_IRQ6_ACK
		rte

	section bss
	align 2

INTERRUPT_TIMER_COUNT:	dc.l $0
INTERRUPT_VBLANK_COUNT:	dc.l $0
