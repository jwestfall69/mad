; gaiden sound cpu has a watchdog and requires some special stuff to
; work around it, more below

	include "cpu/z80/include/macros.inc"

	include "machine.inc"

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

		; The top bit of the R register is used for PSUB nesting.  We need
		; to make sure its 0 or it will make address line a7 participate
		; in the z80's dram refresh logic. This would cause a conflict for
		; us since we use A7 for error address.
		ld	a, r
		and	a, $7f
		ld	r, a

		ld	de, REG_WATCHDOG

		jp	(hl)

	section error_addresses

; watchdog address 0xfc00 = 1111 1100 0rrr rrrr
; error addresses  0x2000 = 001x xxxx xrrr rrrr
;  x = error code
;  r = refresh/useable
; This puts 3 of the error code bits in conflict with having to write to
; the watchdog.  error address jump locations exist every 128 bytes, 0x2000,
; 0x2080, 0x2100, etc.  Normally we would just have a jump self at each of
; those locations.  However to work around the watchdog conflict we are
; instead using the entire 128 bytes for the error address loops

;  - ping watchdog
;  - bunch of nops to fill almost all of the 128 bytes
;  - loop

; If any of the top 3 bits of the error address end up being low and in
; conflict with the watchdog address they will show up on a logic probe
; as LOW 99% of the time and 1% HIGH.  So you hear/see it being LOW with
; and occasional HIGH pulse.

	rept 63
	inline
	.loop:
		ld	(de), a		; 0x12 opcode
		blk.b	124, $00	; fill with nops
		jp	.loop		; 0xc3xxxx opcode (xxxx being .loop address)
	einline
	endr
