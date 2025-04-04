	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/konami/include/dsub.inc"
	include "cpu/konami/include/macros.inc"

	include "machine.inc"
	include "mad.inc"

	global _start

	section code

_start:
		INTS_DISABLE

		lda	#$12
		sta	$7c00

		lda	#$80
		sta	$3f9c

		; hardware seems to ignore watchdog ping until this
		; instruction is called the first time
		setline	$80

		DSUB_MODE_PSUB

		PSUB	screen_init

		PSUB	mad_rom_address_test
		PSUB	mad_rom_crc16_test
		PSUB	work_ram_output_test
		PSUB	work_ram_write_test
		PSUB	work_ram_data_test
		PSUB	work_ram_address_test
		PSUB	work_ram_march_test

		ldx	#WORK_RAM_START
		PSUB	memory_output_test

		DSUB_MODE_RSUB

		jsr	main_menu
