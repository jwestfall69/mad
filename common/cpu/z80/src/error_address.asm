
	include "cpu/z80/include/macros.inc"

	global error_address

	section code

; params
;  a = error code
; The z80 uses A0 to A6 for memory refreshing so they will always
; be pusling.  This leaves us with 6 useable address lines (A7 to A12)
; to communicate the error code to the user.
error_address:
		and	$3f		; error codes can only be 6 bits

		ld	bc, $2000	; base of error addresses

		ld	hl, $0		; make the error code be bits 7 to 12 of hl
		ld	h, a
		srl	h
		rr	l

		add	hl, bc		; add on base address
		jp	(hl)

	section error_addresses

		; this will fill $2000 to almost $4000 with jr to self instructions
		blkw (0xff8),0xfe18
