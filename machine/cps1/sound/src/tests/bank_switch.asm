	include "cpu/z80/include/common.inc"

	global bank_switch_tests

	section code

; The rom is 0x10000 in size and is comprised of 4 copies of
; the diag rom
;   0x0000 = original
;   0x4000 = mirror 1
;   0x8000 = mirror 2
;   0xc000 = mirror 3
; cpu memory regions:
;   0x0000 to 0x7fff is mapped directly to the rom
;   0x8000 to 0xbfff is used for bank switching
; The default it will point at 0x8000 of the rom, switching the
; bank will map it to 0xc000 of the rom.
bank_switch_tests:

		ld	hl, $8000 + MAD_ROM_MIRROR_ADDRESS
		ld	de, REG_BANK_SWITCH

		; verify mirror 2 is already at 0x8000
		ld	a, $2
		cp	(hl)
		jr	nz, .test_failed

		; switch to 0xc000 of rom
		ld	a, $1
		ld	(de), a

		; verify mirror is now 3
		ld	a, $3
		cp	(hl)
		jr	nz, .test_failed

		; switch back to 0x8000 of rom
		xor	a
		ld	(de), a
		ret

	.test_failed:
		ld	a, EC_BANK_SWITCH
		jp	error_address
