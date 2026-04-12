	include "cpu/68000/include/common.inc"

	global r_irq2_count
	global r_irq4_count
	global r_sprite_dma_req

	section vectors

		dc.l	SP_INIT_ADDR
		dc.l	_start

		rorg	$64, $ff
		dc.l	irq1_handler
		dc.l	irq2_handler
		dc.l	irq3_handler
		dc.l	irq4_handler
		dc.l	irq5_handler
		dc.l	irq6_handler
		dc.l	irq7_handler

	section code

; vblank
irq2_handler:
		addq.w	#$1, r_irq2_count

		tst.b	r_sprite_dma_req
		beq	.skip_sprite_dma_req
		move.w	#$0, REG_SPRITE_COPY_REQUEST
		clr.b	r_sprite_dma_req

	.skip_sprite_dma_req:
		rte

; timer
irq4_handler:
		addq.w	#$1, r_irq4_count
		rte

irq1_handler:
irq3_handler:
irq5_handler:
irq6_handler:
irq7_handler:
		rte

	section bss
	align 1

r_irq2_count:		dcb.w 1
r_irq4_count:		dcb.w 1

r_sprite_dma_req:	dcb.b 1
