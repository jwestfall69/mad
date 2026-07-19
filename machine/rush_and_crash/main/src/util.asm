	include "cpu/6809/include/common.inc"

	global sprite_ram_clear
	global wait_irq
	global wait_vblank_copy
	global wait_vblank_fill

	section code

sprite_ram_clear:

		CPU_INTS_ENABLE

		jsr	wait_irq

		ldd	#SPRITE_RAM_SIZE / $80
		ldy	#SPRITE_RAM

	.loop_next_block:
		pshs	d, y
		lda	#$0
		sty	r_vblank_fill_addr
		ldd	#$80
		std	r_vblank_fill_size

		jsr	wait_vblank_fill

		puls	d, y
		leay	$80, y
		subd	#$1
		bne	.loop_next_block

		CPU_INTS_DISABLE

		rts


wait_irq:
		ldd	#$0
		std	r_irq_count

	.loop_wait:
		ldd	r_irq_count
		beq	.loop_wait
		rts

wait_vblank_copy:
		ldd	r_vblank_copy_size
		bne	wait_vblank_copy
		rts

wait_vblank_fill:
		ldd	r_vblank_fill_size
		bne	wait_vblank_fill
		rts
