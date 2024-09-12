	include "machine.inc"
	include "mad_rom.inc"

	global r_irq_timer_count
	global r_irq_vblank_count

	section vectors, data

		dc.l	SP_INIT_ADDR
		dc.l	_start

		rorg $68, $ff
		dc.l	irq2_handler
		dc.l	irq3_handler


	section code
; timer
irq2_handler:
		addq.l	#1, r_irq_timer_count
		move.w	#$0, $140016
		move.w	#$0, REG_IRQ2_ACK
		rte

; vblank
irq3_handler:
		addq.l	#1, r_irq_vblank_count
		move.w	#$0, REG_IRQ3_ACK
		rte

	section bss
	align 2

r_irq_timer_count:	dc.l $0
r_irq_vblank_count:	dc.l $0
