	include "cpu/68000/include/common.inc"

	global sprite_ram_clear

	section code

; fill sprite ram with $0000, then wait for a sprite dma copy
sprite_ram_clear:
		lea	SPRITE_RAM, a0
		move.w	#SPRITE_RAM_SIZE, d0
		moveq	#$0, d1
		RSUB	memory_fill

		move.w	#$0, r_irq2_count
		move.b	#$1, r_sprite_dma_req

		CPU_INTS_ENABLE

	; its possible irq2 could be in a pending state,
	; so the initial irq2 handler call might not actually
	; be the vblank.  Ignore the first handler call before
	; asking for the sprite dma copy
	.loop_wait_irq2:
		move.w	r_irq2_count, d0
		beq	.loop_wait_irq2

	.loop_wait_dma_copy:
		tst.b	r_sprite_dma_req
		bne	.loop_wait_dma_copy

		CPU_INTS_DISABLE

		rts

