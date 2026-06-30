	include "cpu/68000/include/common.inc"

	global r_irq2_count
	global r_irq4_count
	global r_sprite_dma_req
	global r_vblank_copy_src
	global r_vblank_copy_dst
	global r_vblank_copy_size
	global r_vblank_fill_addr
	global r_vblank_fill_data
	global r_vblank_fill_size

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
		;move.w	#$ffff, FIX_TILE_PALETTE + 2

		tst.w	r_vblank_copy_size
		beq	.skip_vblank_copy
		movem.l	d0/a0-a1, -(a7)
		move.l	r_vblank_copy_src, a0
		move.l	r_vblank_copy_dst, a1
		move.w	r_vblank_copy_size, d0
		subq.w	#$1, d0

	.loop_next_copy_word:
		move.w	(a0)+, (a1)+
		dbra	d0, .loop_next_copy_word

		move.w	#$0, r_vblank_copy_size
		movem.l	(a7)+, d0/a0-a1
	.skip_vblank_copy:

		tst.w	r_vblank_fill_size
		beq	.skip_vblank_fill
		movem.l	d0-d1/a0, -(a7)

		move.l	r_vblank_fill_addr, a0
		move.w	r_vblank_fill_data, d0
		move.w	r_vblank_fill_size, d1
		subq.w	#$1, d1
	.loop_next_fill_word:
		move.w	d0, (a0)+
		dbra	d1, .loop_next_fill_word

		move.w	#$0, r_vblank_fill_size
		movem.l (a7)+, d0-d1/a0
	.skip_vblank_fill:

		tst.b	r_sprite_dma_req
		beq	.skip_sprite_dma_req
		move.w	#$0, REG_SPRITE_COPY_REQUEST
		nop
		nop
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
r_vblank_copy_src:	dcb.l 1
r_vblank_copy_dst:	dcb.l 1
r_vblank_copy_size:	dcb.w 1
r_vblank_fill_addr:	dcb.l 1
r_vblank_fill_data:	dcb.w 1
r_vblank_fill_size:	dcb.w 1

r_sprite_dma_req:	dcb.b 1
