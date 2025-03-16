	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/xy_string.inc"

	include "machine.inc"

	global fg_set_bank
	global r_fg_current_bank

	section code

; Per info in mame, fg tile bank switching is handled by
; an 74ls259 latch.
; Influencing the output of the latch is done via what
; address the latch is accessed at.
;
; latch base = 0x0c001 with the following
;   0000 1100 0000 0000 xDbb b001
; Where:
;  b = bit of the latch output we are trying to change
;  D = value of the bit being changed
;
; The fg tile bank is set by adjusting the latch output
; for bits 4-6. In order to do this we need to write to
; the following bbb values of the latch input, plus
; setting D appropriately.
;  bit4: bbb = 100
;  bit5: bbb = 101
;  bit6: bbb = 110
;
; Setting the fg tile bank will effect all tiles on the
; screen.  With the exception of bank1 all banks have
; the character set in them, so the screen is renderly
; fully on those.  For bank1 the screen text will go
; blank and the only thing drawn will be the tiles
; (time solder logo).
; params:
;  d0 = bank number
fg_set_bank:
		move.b	(r_fg_current_bank), d1
		cmp.b	d0, d1
		beq	.skip_bank_switch

		move.b	d0, (r_fg_current_bank)

		lea	REG_LATCH_BANK_BIT0, a0
		btst	#$0, d0
		beq	.set_bank_bit0
		add.w	#$40, a0
	.set_bank_bit0:
		move.b	d0, (a0)

		lea	REG_LATCH_BANK_BIT1, a0
		btst	#$1, d0
		beq	.set_bank_bit1
		add.w	#$40, a0
	.set_bank_bit1:
		move.b	d0, (a0)

		lea	REG_LATCH_BANK_BIT2, a0
		btst	#$2, d0
		beq	.set_bank_bit2
		add.w	#$40, a0
	.set_bank_bit2:
		move.b	d0, (a0)

	.skip_bank_switch:
		rts

	section bss
	align 1

r_fg_current_bank:	dcb.b 1
