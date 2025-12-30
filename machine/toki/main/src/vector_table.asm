	include "cpu/68000/include/common.inc"

	global	r_sprite_copy_req

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
irq1_handler:
		movem.l	d0, -(a7)
		SCREEN_UPDATE
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		move.b	r_sprite_copy_req, d0
		beq	.skip_sprite_copy
		move.w	d0, REG_SPRITE_COPY
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		move.b	#$0, r_sprite_copy_req

	.skip_sprite_copy:
		move.w	#$c0f0, REG_SCREEN_FLIP
		movem.l	(a7)+, d0
		rte

irq2_handler:
irq3_handler:
irq4_handler:
irq5_handler:
irq6_handler:
irq7_handler:
		rte

	section bss
	align 1

r_sprite_copy_req:	dcb.b 1
