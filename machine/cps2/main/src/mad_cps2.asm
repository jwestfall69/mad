	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"

	include "machine.inc"
	include "mad_rom.inc"

	global _start

	section code

_start:
		INTS_DISABLE

		; doing it like this so the same compiled rom
		; can be used to make a suicided rom or encrypted
		cmp.l	#(WORK_RAM_START + WORK_RAM_SIZE), $0
		beq	.suicide

		; unclear at this point if this might be required
		; to be different depending on romset or if we
		; could get away with them all being the same
		ROMSET_INIT
		bra	.init_done

	.suicide:
		SUICIDE_INIT

	.init_done:
		move.w	#$ffc0, REGA_SCROLL1_X
		move.w	#$0, REGA_SCROLL1_Y
		move.b	#$0, REG_OBJECT_RAM_BANK

		; At power up the z80 cpu is held in RESET until
		; we send the following command to the eeprom port.
		; If you attempt to access the shared qsound ram
		; while the z80 is held in RESET the 68k cpu will
		; stall.
		move.w	#$f08, REG_EEPROM_PORT

		PSUB_INIT
		PSUB	screen_init

		SOUND_INIT

		PSUB	auto_dsub_tests

		;RSUB_INIT
		moveq	#$1c, d7
		move.l	#SP_INIT_ADDR, sp

		bsr	auto_func_tests

		clr.b	r_menu_cursor
		bra	main_menu
