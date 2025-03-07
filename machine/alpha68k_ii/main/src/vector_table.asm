	include "machine.inc"
	include "mad.inc"

	global r_irq1_count
	global r_irq2_count
	global r_irq3_count

	section vectors, data

		dc.l	SP_INIT_ADDR
		dc.l	_start

		rorg	$64, $ff
		dc.l	irq1_handler
		dc.l	irq2_handler
		dc.l	irq3_handler

	section code

; some random things from testing
; - irq2 doesn't have an ack
; - move.b #$1, $300041 (which the game does) will
;   cause irq3's interval to match up with irq1 (vblank)
;   and also cause irq2 to trigger at around 0.01ms
; - if irq1 is disable and irqs 2+ enabled. irq2
;   will not trigger.  You can get it to trigger
;   by doing irq1's ack (during vblank only?).
;   This will cause irq2 to trigger multiple times
;   then it will stop (at next vblank?)

; vblank
irq1_handler:
		addq.l	#1, r_irq1_count
		tst.b	REG_IRQ1_ACK
		rte

; scanline? by default seems to happen every 0.06 - 0.07 ms
irq2_handler:
		addq.l	#1, r_irq2_count
		rte

; timer? by default seems to happen every ~60ms?
irq3_handler:
		addq.l	#1, r_irq3_count
		tst.b	REG_IRQ3_ACK
		rte

	section bss
	align 1

r_irq1_count:	dc.l $0
r_irq2_count:	dc.l $0
r_irq3_count:	dc.l $0
