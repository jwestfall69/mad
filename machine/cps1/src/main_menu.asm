	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"
	include "cpu/68000/main_menu_handler.inc"

	include "diag_rom.inc"
	include "machine.inc"

	global main_menu

	section code

main_menu:
		RSUB	screen_init
		lea	MAIN_MENU_LIST, a0
		lea	main_menu_get_input, a1
		moveq	#'*', d0
		moveq	#' ', d1
		jsr	main_menu_handler

		bra	main_menu

; these are call backs from global main_menu that are machine specific

; returns:
;  d0 = 0, MAIN_MENU_UP, MAIN_MENU_DOWN, MAIN_MENU_BUTTON
main_menu_get_input:
		move.w	#$1fff, d0
		RSUB	delay

		jsr	p1_input_update

		moveq	#0, d0

		move.b	P1_INPUT_EDGE, d1

		btst	#P1_DOWN_BIT, d1
		bne	.down_pressed

		btst	#P1_UP_BIT, d1
		bne	.up_pressed

		btst	#P1_B1_BIT, d1
		bne	.a_pressed

		rts

	.down_pressed:
		bset	#MAIN_MENU_DOWN_BIT, d0
		rts

	.up_pressed:
		bset	#MAIN_MENU_UP_BIT, d0
		rts

	.a_pressed:
		bset	#MAIN_MENU_BUTTON_BIT, d0
		rts


MAIN_MENU_LIST:
	MAIN_MENU_ENTRY pal_normal, STR_TEST1
	MAIN_MENU_ENTRY pal_red, STR_TEST2
	MAIN_MENU_ENTRY pal_copy, STR_TEST3
	MAIN_MENU_ENTRY pal_reg_copy, STR_TEST4
	MAIN_MENU_ENTRY video_regs, STR_TEST5
	MAIN_MENU_ENTRY cps_a_init, STR_TEST6
	MAIN_MENU_ENTRY irq_method, STR_TEST7
	MAIN_MENU_ENTRY capt_init, STR_TEST8
	MAIN_MENU_ENTRY manual_work_ram_tests, STR_WORK_RAM_TEST
	MAIN_MENU_ENTRY_LIST_END

STR_TEST1:		STRING "PAL NORMAL"
STR_TEST2:		STRING "PAL RED"
STR_TEST3:		STRING "PAL COPY REQ"
STR_TEST4:		STRING "PAL CTRL + COPY REQ"
STR_TEST5:		STRING "VIDEO REGS"
STR_TEST6:		STRING "CPS_A_INIT"
STR_TEST7:		STRING "IRQ METHOD"
STR_TEST8:		STRING "CAPT INIT"
STR_WORK_RAM_TEST:	STRING "WORK RAM TEST"


pal_normal:
		ROMSET_PALETTE_SETUP
		bra	wait_b_button

pal_red:
;		ROMSET_PALETTE_SETUP_RED
		bra	wait_b_button

pal_copy:
		move.w	#PALETTE_RAM_START / 256, REGA_PALETTE_RAM_BASE
		bra	wait_b_button

pal_reg_copy:
		move.w	#ROMSET_PALETTE_CTRL, REGB_PALETTE_CTRL
		move.w	#PALETTE_RAM_START / 256, REGA_PALETTE_RAM_BASE
		bra	wait_b_button

video_regs:
                move.w  #ROMSET_LAYER_CTRL, REGB_LAYER_CTRL
                move.w  #ROMSET_PALETTE_CTRL, REGB_PALETTE_CTRL
                move.w  #PALETTE_RAM_START / 256, REGA_PALETTE_RAM_BASE
                move.w  #ROMSET_VIDEO_CTRL, REGA_VIDEO_CONTROL
		bra	wait_b_button

cps_a_init:
		RSUB	cps_a_init
		bra	wait_b_button

irq_method:
		clr.w	DERP
		move.w	#$2100, sr

	.wait_irq:
		move.w	DERP, d4
		tst.w	d4
		bne	.disable_int
		bra	.wait_irq

	.disable_int:
		move.w	#$2700, sr
		bra	wait_b_button

capt_init:
	move.b #$f0, $800181
	move.w #$ffc0, $80010c
	move.w #$0000, $80010e
	move.w #$90c0, $800102
	move.w #$12e0, $800160
	move.w #$003f, $800170
	move.w #$9000, $80010a
	move.w #$003e, $800122
	move.w #$003e, $800122
	move.w #$12e2, $800160
	move.w #$9100, $800100
	move.w #$90c0, $800102
	move.w #$9040, $800104
	move.w #$9080, $800106
	move.w #$9200, $800108
	move.w #$9100, $800100
	move.w #$9200, $800108
	move.w #$0000, $800120
	move.w #$003e, $800122
	move.w #$12f2, $800160
	move.w #$003f, $800170
	move.w #$9000, $80010a
	move.w #$0000, $800174
	move.w #$ffc0, $80010c
	move.w #$0000, $80010e
	move.w #$ffc0, $800110
	move.w #$0300, $800112
	move.w #$ffc0, $800114
	move.w #$0700, $800116
	move.w #$0000, $80016e
	move.w #$0000, $80016c
	move.w #$0000, $80016A
	move.w #$0000, $800168
	move.b #$ff, $800181
	move.w #$0000, $80014e
	move.w #$0010, $800146
	move.w #$0080, $800144
	move.w #$0015, $800146
	bra wait_b_button

wait_b_button:
		jsr	p1_input_update
		btst	#5, P1_INPUT_EDGE + 1
		beq	wait_b_button
		rts


