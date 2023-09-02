	include "diag_rom.inc"

	global INTERRUPT_TIMER_COUNT
	global INTERRUPT_VBLANK_COUNT

	section vectors, data

		dc.l	SP_INIT_ADDR
		dc.l	_start

		rorg	$74, $ff
		dc.l	interrupt_timer		; irq5
		dc.l	interrupt_vblank	; irq6

	section code

interrupt_timer:
		addq.l	#1, INTERRUPT_TIMER_COUNT
		move.b	d0, $180002
		rte

interrupt_vblank:
		addq.l	#1, INTERRUPT_VBLANK_COUNT
		move.b	d0, $180000
		rte

	section bss
	align 2

INTERRUPT_TIMER_COUNT:	dc.l $0
INTERRUPT_VBLANK_COUNT:	dc.l $0
