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
	; opcode $20fe (bra self)
	section error_addresses

		; fills the errors section with bra to self instructions
		blk.w (0xfe0/2),0x20fe

