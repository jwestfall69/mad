	include "cpu/z80/include/common.inc"

	global error_address

	section code

; params:
;  a = error code
; The z80 uses A0 to A6 for memory refreshing so they will always
; be pusling.  This leaves us with 6 useable address lines (A7 to A12)
; to communicate the error code to the user.
error_address:
		; jump address is ERROR_ADDRESS_BASE | (a << 7)
		and	EC_MASK
		ld	bc, ERROR_ADDRESS_BASE
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
	; starting at ERROR_ADDRESS_BASE of the rom.

	; error address jump points are every 128 bytes, so we need to make
	; sure the below code block is a power of 2 that is <= 128 bytes.  In
	; this case its 2 bytes.
	rept $1ff0 / 2
	inline
	.loop:
		jr	.loop		; $18fe
	einline
	endr
