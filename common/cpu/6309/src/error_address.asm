	include "machine.inc"

	global error_address_psub

	section code

; params:
;  a = error code
error_address_psub:
		; jump address is $f000 | (error_code << 4)
		anda	#$3f
		clrb
		rord
		rord
		rord
		rord
		ldx	#$f000
		jmp	d, x

	section error_addresses
	; The mad_<machine>.ld file is setup to put the error_addresses section
	; starting at $f000 of the rom.  Below will fill $f000 to $f400.

	; error address jump points are every 16 bytes, so we need to make
	; sure the below code block is a power of 2 that is <= 16 bytes.  In
	; this case its 2 bytes.
	rept $400 / 2
	inline
	.loop:
		bra	.loop	; $20fe
	einline
	endr

