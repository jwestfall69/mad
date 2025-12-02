	include "cpu/68000/include/common.inc"

	global	r_sprite_copy_req

	section vectors, data

		dc.l	SP_INIT_ADDR
		dc.l	_start

		rorg $64, $ff
		dc.l	irq1_handler

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
		; debug stuff trying to figure out fg/bg tile not working on hw
		;move.w	#$01bf, $a000c
		;move.w	#$0010, $a000a

		;move.w	#$00df, $a002c
		;move.w	#$0000, $a002a

		;move.w	#$0100, $a003c
		;move.w	#$0010, $a003a
		;move.w	#$c0f0, $a0050

		;move.w	#$0028, $a0018
		;move.w	#$0028, $a0038

		;move.w	$c0004, d0
		;move.w	$c0000, d0

		move.w	#$c0f0, REG_SCREEN_FLIP
		movem.l	(a7)+, d0
		rte

	section bss
	align 1

r_sprite_copy_req:	dcb.b 1
