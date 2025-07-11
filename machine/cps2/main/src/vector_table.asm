	include "cpu/68000/include/common.inc"

	global r_irq_vblank_count

	section vectors, data

		dc.l	SP_INIT_ADDR
		dc.l	_start

		rorg $68, $ff
		dc.l	irq2_handler

	section code

; vblank
irq2_handler:
		addq.l	#1, r_irq_vblank_count
		rte

	section bss
	align 1

r_irq_vblank_count:	dcb.l 1
