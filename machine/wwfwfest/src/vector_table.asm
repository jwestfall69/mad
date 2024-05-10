	include "diag_rom.inc"
	include "machine.inc"

	global INTERRUPT_TIMER_COUNT
	global INTERRUPT_VBLANK_COUNT

	section vectors, data

		dc.l	SP_INIT_ADDR
		dc.l	_start

		rorg $68, $ff
		dc.l	irq2_handler
		dc.l	irq3_handler


	section code
; timer
irq2_handler:
		addq.l	#1, INTERRUPT_TIMER_COUNT
		move.w	#$0, $140016
		move.w	#$0, REG_IRQ2_ACK
		rte

; vblank
irq3_handler:
		addq.l	#1, INTERRUPT_VBLANK_COUNT
		move.w	#$0, REG_IRQ3_ACK
		rte

	section bss
	align 2

INTERRUPT_TIMER_COUNT:	dc.l $0
INTERRUPT_VBLANK_COUNT:	dc.l $0
