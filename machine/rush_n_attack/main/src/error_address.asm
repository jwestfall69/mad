	include "cpu/z80/include/common.inc"

	global error_address

	section code

; params:
;  a = error code
; The z80 uses A0 to A6 for memory refreshing so they will always
; be pusling.  This leaves us with 6 useable address lines (A7 to A12)
; to communicate the error code to the user.
error_address:
		; jump address is $2000 | (a << 7)
		and	EC_MASK
		ld	bc, $2000
		ld	hl, $0		; make the error code be bits 7 to 12 of hl
		ld	h, a
		srl	h
		rr	l

		add	hl, bc		; add on base address

		; The top bit of the R register is used for PSUB nesting.  We need
		; to make sure its 0 or it will make address line a7 participate
		; in the z80's dram refresh logic. This would cause a conflict for
		; us since we use A7 for error address.
		ld	a, r
		and	a, $7f
		ld	r, a

		jp	(hl)

	section error_addresses
	; The mad_<machine>.ld file is setup to put the error_addresses section
	; starting at $2000 of the rom.  Below will fill $2000 to $3ff0.

	; watchdog address vs error address
	;   watchdog address: $f600 = 1111 0110 1100 0000
	;   error address:    $2000 = 001E EEEE E000 0000
	;     E = error code

	; The watchdog address is in conflict with the error address.
	; However the loop below will mean we are in the error address
	; range 99.9+% of the time.  This is enough for the error addresses
	; to still be viable to use with a logic probe.

	; error address jump points are every 128 bytes, so we need to make
	; sure the below code block is a power of 2 that is <= 128 bytes.  In
	; this case its 16 bytes.
	rept $1ff0 / 16
	inline
	.loop:
		WATCHDOG		; $3200 f6
		ld	b, $ff		; $06ff
	.delay:
		nop			; $00
		nop			; $00
		nop			; $00
		nop			; $00
		nop			; $00
		nop			; $00
		nop			; $00
		djnz	.delay		; $10f7
		jr	.loop		; $18f0
	einline
	endr
