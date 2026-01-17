	include "cpu/6309/include/common.inc"

	global _start

	section code

_start:
		WATCHDOG
		ldd	#$fff
	.loop:
		subd	#$1
		bne	.loop

		clra
		sta	$0007
		sta	$0000
		sta	$0002
		lda	#$0c
		sta	$0001

		ldd	#$24e0
		std	$0003
		ldd	#$010d
		std	$0005

		clra
		sta	$040c
		sta	$0410
		sta	$0003
		lda	#$40
		sta	$0410

		ldd	#$000c
		std	$0000
		ldd	#$0010
		std	$0002
		ldd	#$c08d
		std	$0004
		ldd	#$0500
		std	$0006
		clra
		sta	$0410

		DSUB_MODE_PSUB

		PSUB	screen_init
		PSUB	auto_mad_rom_address_test
		PSUB	auto_mad_rom_crc32_test
		PSUB	auto_work_ram_tests

		DSUB_MODE_RSUB

		lds	#(WORK_RAM + WORK_RAM_SIZE - 2)
		jsr	auto_func_tests

		lda	#SOUND_NUM_SUCCESS
		SOUND_PLAY

		jsr	main_menu
