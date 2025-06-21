	include "cpu/6309/include/dsub.inc"
	include "cpu/6309/include/macros.inc"

	include "machine.inc"
	include "mad.inc"

	global _start

	section code

_start:
		INTS_DISABLE

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

		DSUB_MODE_PSUB

		SOUND_STOP

		PSUB	screen_init
		PSUB	auto_mad_rom_address_test
		PSUB	auto_mad_rom_crc32_test
		PSUB	auto_work_ram_tests

		DSUB_MODE_RSUB

		jsr	auto_func_tests

		lda	#SOUND_NUM_SUCCESS
		SOUND_PLAY

		jsr	main_menu
