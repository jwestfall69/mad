	include "cpu/68000/include/common.inc"

	global _start

	section code

_start:
		CPU_INTS_DISABLE

		; Normally contents of 0x000000 in the rom is the initial
		; value the CPU gives sp on boot.  However on an encrypted
		; rom it will be scrambled if we try to read it.  We can use
		; this fact to determine if we are running an encrypted or
		; suicided rom.  Each require a different init process.
		cmp.l	#SP_INIT_ADDR, $0
		beq	.init_suicide

		; Unclear if this will work for all encrypted games.  It
		; probably does since all games are CPS B-21 with default
		; values
		move.w	#$0, $8040a0
		move.w	#$7000, $400000
		move.w	#$807d, $400002
		move.w	#$0, $400004
		move.w	#$0, $400006
		move.w	#$0, $400008
		move.w	#$0, $40000a
		bra	.init_done

	.init_suicide:
		; This comes from razoola's suicided tester / phoenix roms.
		move.w	#$0, $8040a0
		move.w	#$7000, $fffff0
		move.w	#$807d, $fffff2
		move.w	#$0, $fffff4
		move.w	#$0, $fffff6
		move.w	#$0, $fffff8
		move.w	#$0, $fffffa

	.init_done:
		; At power up the z80 cpu is held in RESET until
		; we send the following command to the eeprom port.
		; If you attempt to access the shared qsound ram
		; while the z80 is held in RESET the 68k cpu will
		; stall.
		move.w	#$f08, REG_EEPROM_PORT

		DSUB_MODE_PSUB
		PSUB	screen_init

		SOUND_INIT

		PSUB	auto_test_dsub_handler

		; DSUB_MODE_RSUB uses $0 to setup sp, but on encrypted
		; roms it will be scrambled
		moveq	#$1c, d7
		move.l	#SP_INIT_ADDR, sp

		bsr	auto_func_tests

		move.w	#SOUND_NUM_SUCCESS, d0
		SOUND_PLAY

		clr.b	r_menu_cursor
		bra	main_menu
