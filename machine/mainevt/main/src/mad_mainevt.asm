	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"

	include "machine.inc"

	global	_start

	section code

_start:
		ldd	#$1380
		sta	$7c00	; reset of customs? no rendering without
		stb	$1f80	; bank switch

		ldd	#$1032
		sta	$1d80	; more bank switch?
		stb	$1f00	; more bank switch?

		clra
		sta	$1d00	; irq enable/disable?
		sta	$1c80	; row/column scroll
		sta	$3801	; shadow?
		sta	$1f88	; snd irq trigger
		sta	$380c	; scroll y

		ldd	#$0200
		sta	$1e80	; screen flip
		stb	$3800	; irq?


		PSUB	screen_init
		lds	#(WORK_RAM_START + WORK_RAM_SIZE - 2)
		jsr	main_menu