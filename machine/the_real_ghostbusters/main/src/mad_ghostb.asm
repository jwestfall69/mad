	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"

	include "machine.inc"
	include "mad.inc"

	global _start

	section code

_start:
		INTS_DISABLE
		SOUND_STOP

		clr	$3840
		lda	#$82
		sta	$3820
		lda	#$03
		sta	$3822
		clra
		sta	$3824
		lda	#$1
		sta	$3826
		clr	$3837
		clr	$3835
		ldx	#$3830
		lda	#$10
	.loop_clear:
		clr	,x+
		deca
		bne	.loop_clear

		PSUB	screen_init
		PSUB	auto_mad_rom_address_test
		PSUB	auto_mad_rom_crc32_test
		PSUB	auto_work_ram_tests

		lds	#(WORK_RAM + WORK_RAM_SIZE - 2)
		jsr	auto_func_tests

		lda	#SOUND_NUM_SUCCESS
		SOUND_PLAY

		jsr	main_menu
