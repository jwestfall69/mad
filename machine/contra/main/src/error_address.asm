	include "machine.inc"

	global error_address_psub

	section code

; params:
;  a = error code
error_address_psub:

		; covert the error code into a error_address
		; then jump to it.  jump address is $f000 | (error_code << 4)
		clrb
		rord
		rord
		rord
		rord
		ldx	#$f000
		jmp	d, x


	; The mad_<machine>.ld file should be setup to put the error_addresses
	; section at $f000 of the rom.  Below will fill $f000 to $ffe0 with
	; a bunch of loops taking into account the watchdog.  The loop needs
	; to <= 16 bytes and a power of 2.  It can't fit in 8 bytes so its
	; been padded with nops to get to 16 bytes.
	section error_addresses

	rept $fe0 / 16
	inline
	.loop:
		sta	REG_WATCHDOG	; $971e
		ldw	#$1ff		; $10861ff
	.delay:
		nop			; $12
		nop			; $12
		nop			; $12
		nop			; $12
		decw			; $105a
		bne	.delay		; $26f8
		bra	.loop		; $20f0
 	einline
	endr

